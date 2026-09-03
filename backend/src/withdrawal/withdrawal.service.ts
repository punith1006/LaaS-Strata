import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

const PLATFORM_FEE_RATE = 0.20; // 20%
const MIN_WITHDRAWAL_CENTS = 1000; // Rs 10 minimum
const MAX_DAILY_WITHDRAWAL_CENTS = 5000000; // Rs 50,000 daily limit

interface BankDetails {
  accountNumber: string;
  ifscCode: string;
  accountHolderName: string;
}

export interface PayoutResult {
  success: boolean;
  withdrawal?: {
    id: string;
    amountCents: number;
    platformFeeCents: number;
    netPayoutCents: number;
    status: string;
    createdAt: string;
  };
  error?: string;
}

@Injectable()
export class WithdrawalService {
  private readonly logger = new Logger(WithdrawalService.name);
  private readonly razorpayKeyId: string;
  private readonly razorpayKeySecret: string;
  private readonly razorpayBaseUrl = 'https://api.razorpay.com';

  constructor(private prisma: PrismaService) {
    this.razorpayKeyId = process.env.RAZORPAY_KEY_ID || '';
    this.razorpayKeySecret = process.env.RAZORPAY_KEY_SECRET || '';
  }

  private get basicAuthHeader(): string {
    return 'Basic ' + Buffer.from(`${this.razorpayKeyId}:${this.razorpayKeySecret}`).toString('base64');
  }

  /**
   * Request a withdrawal to bank account.
   * Debits wallet, creates audit records, and initiates RazorpayX payout.
   */
  async requestWithdrawal(
    userId: string,
    amountCents: number,
    bankDetails: BankDetails,
  ): Promise<PayoutResult> {
    // 1. Validate amount
    if (amountCents < MIN_WITHDRAWAL_CENTS) {
      throw new BadRequestException(`Minimum withdrawal amount is ₹${MIN_WITHDRAWAL_CENTS / 100}`);
    }

    // 2. Calculate fees
    const platformFeeCents = Math.round(amountCents * PLATFORM_FEE_RATE);
    const netPayoutCents = amountCents - platformFeeCents;

    // 3. Fetch user and wallet
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new BadRequestException('User not found');

    const wallet = await this.prisma.wallet.findUnique({ where: { userId } });
    if (!wallet) throw new BadRequestException('Wallet not found');

    // Wallet frozen check
    if (wallet.isFrozen) {
      throw new BadRequestException('Your wallet is currently frozen. Please contact support.');
    }

    // Balance check
    if (wallet.balanceCents < BigInt(amountCents)) {
      throw new BadRequestException('Insufficient wallet balance');
    }

    // 3b. Concurrent withdrawal guard — block if another withdrawal is still processing
    const pendingCount = await this.prisma.withdrawalRequest.count({
      where: { userId, status: 'processing' },
    });
    if (pendingCount > 0) {
      throw new BadRequestException('You have a withdrawal still processing. Please wait for it to complete.');
    }

    // 3c. Daily withdrawal limit check
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);
    const dailyTotal = await this.prisma.withdrawalRequest.aggregate({
      where: {
        userId,
        createdAt: { gte: todayStart },
        status: { not: 'failed' }, // Count all non-failed (processed + processing + pending)
      },
      _sum: { amountCents: true },
    });
    const dailyUsed = dailyTotal._sum.amountCents ?? 0;
    if (dailyUsed + amountCents > MAX_DAILY_WITHDRAWAL_CENTS) {
      const remaining = MAX_DAILY_WITHDRAWAL_CENTS - dailyUsed;
      throw new BadRequestException(
        `Daily withdrawal limit exceeded. Remaining today: ₹${(remaining / 100).toFixed(2)}`,
      );
    }

    // 4. Validate bank details format
    if (!bankDetails.accountNumber || bankDetails.accountNumber.length < 9) {
      throw new BadRequestException('Invalid account number');
    }
    if (!/^[A-Z]{4}0[A-Z0-9]{6}$/.test(bankDetails.ifscCode)) {
      throw new BadRequestException('Invalid IFSC code format');
    }
    if (!bankDetails.accountHolderName || bankDetails.accountHolderName.length < 3) {
      throw new BadRequestException('Invalid account holder name');
    }

    // 5. Execute withdrawal in transaction (debit wallet + create audit records)
    const idempotencyKey = crypto.randomUUID();
    const now = new Date();

    const withdrawal = await this.prisma.$transaction(async (tx) => {
      // Re-read wallet inside transaction to prevent race conditions
      const freshWallet = await tx.wallet.findUnique({ where: { id: wallet.id } });
      if (!freshWallet || freshWallet.balanceCents < BigInt(amountCents)) {
        throw new BadRequestException('Insufficient wallet balance (concurrent request)');
      }

      // Debit wallet
      const newBalance = freshWallet.balanceCents - BigInt(amountCents);
      const updatedWallet = await tx.wallet.update({
        where: { id: wallet.id },
        data: { balanceCents: newBalance },
      });

      // Create WalletTransaction (debit)
      await tx.walletTransaction.create({
        data: {
          walletId: wallet.id,
          userId,
          txnType: 'debit',
          amountCents: BigInt(amountCents),
          balanceAfterCents: newBalance,
          referenceType: 'withdrawal',
          description: `Withdrawal to bank account (fee: ₹${(platformFeeCents / 100).toFixed(2)})`,
        },
      });

      // Create WithdrawalRequest record
      const withdrawalReq = await tx.withdrawalRequest.create({
        data: {
          userId,
          walletId: wallet.id,
          amountCents,
          platformFeeCents,
          netPayoutCents,
          status: 'processing',
          idempotencyKey,
        },
      });

      // Create Invoice
      const dateStr = now.toISOString().slice(0, 10).replace(/-/g, '');
      const randomSuffix = crypto.randomBytes(3).toString('hex').toUpperCase();
      const invoiceNumber = `WDR-${dateStr}-${randomSuffix}`;

      const invoice = await tx.invoice.create({
        data: {
          userId,
          invoiceNumber,
          periodStart: now,
          periodEnd: now,
          subtotalCents: BigInt(amountCents),
          taxCents: BigInt(0),
          totalCents: BigInt(amountCents),
          currency: 'INR',
          status: 'paid',
          issuedAt: now,
          paidAt: now,
        },
      });

      // Create InvoiceLineItems
      await tx.invoiceLineItem.create({
        data: {
          invoiceId: invoice.id,
          description: 'Withdrawal payout',
          quantity: 1,
          unitPriceCents: netPayoutCents,
          totalCents: BigInt(netPayoutCents),
          referenceType: 'withdrawal_request',
          referenceId: withdrawalReq.id,
        },
      });

      await tx.invoiceLineItem.create({
        data: {
          invoiceId: invoice.id,
          description: 'Platform fee (20%)',
          quantity: 1,
          unitPriceCents: platformFeeCents,
          totalCents: BigInt(platformFeeCents),
          referenceType: 'withdrawal_request',
          referenceId: withdrawalReq.id,
        },
      });

      // Create PaymentTransaction record (so it appears in Invoice & Payments tab)
      await tx.paymentTransaction.create({
        data: {
          userId,
          gateway: 'razorpayx',
          amountCents,
          currency: 'INR',
          status: 'completed',
          gatewayResponse: {
            type: 'withdrawal',
            withdrawalRequestId: withdrawalReq.id,
            platformFeeCents,
            netPayoutCents,
          },
        },
      });

      return withdrawalReq;
    });

    this.logger.log(
      `Withdrawal ${withdrawal.id} created: ₹${(amountCents / 100).toFixed(2)} requested, ` +
      `fee: ₹${(platformFeeCents / 100).toFixed(2)}, net: ₹${(netPayoutCents / 100).toFixed(2)}`,
    );

    // 6. Call RazorpayX APIs (outside transaction)
    try {
      // Create contact
      const contact = await this.createContact(userId, user);
      this.logger.log(`RazorpayX contact created: ${contact.id}`);

      // Create fund account
      const fundAccount = await this.createFundAccount(contact.id, bankDetails);
      this.logger.log(`RazorpayX fund account created: ${fundAccount.id}`);

      // Create payout
      const payout = await this.createPayout(fundAccount.id, netPayoutCents, idempotencyKey);
      this.logger.log(`RazorpayX payout created: ${payout.id}, status: ${payout.status}`);

      // Update withdrawal record with RazorpayX IDs
      const updatedWithdrawal = await this.prisma.withdrawalRequest.update({
        where: { id: withdrawal.id },
        data: {
          razorpayContactId: contact.id,
          razorpayPayoutId: payout.id,
          status: payout.status === 'queued' ? 'processing' : payout.status,
          utr: payout.utr || null,
        },
      });

      return {
        success: true,
        withdrawal: {
          id: updatedWithdrawal.id,
          amountCents: updatedWithdrawal.amountCents,
          platformFeeCents: updatedWithdrawal.platformFeeCents,
          netPayoutCents: updatedWithdrawal.netPayoutCents,
          status: updatedWithdrawal.status,
          createdAt: updatedWithdrawal.createdAt.toISOString(),
        },
      };
    } catch (error: any) {
      this.logger.error(`RazorpayX payout failed for withdrawal ${withdrawal.id}: ${error.message}`);

      // Re-credit wallet on failure
      await this.prisma.$transaction(async (tx) => {
        const currentWallet = await tx.wallet.findUnique({ where: { id: wallet.id } });
        if (!currentWallet) return;

        const restoredBalance = currentWallet.balanceCents + BigInt(amountCents);
        await tx.wallet.update({
          where: { id: wallet.id },
          data: { balanceCents: restoredBalance },
        });

        await tx.walletTransaction.create({
          data: {
            walletId: wallet.id,
            userId,
            txnType: 'credit',
            amountCents: BigInt(amountCents),
            balanceAfterCents: restoredBalance,
            referenceType: 'withdrawal_refund',
            referenceId: withdrawal.id,
            description: 'Withdrawal failed — amount refunded to wallet',
          },
        });

        await tx.withdrawalRequest.update({
          where: { id: withdrawal.id },
          data: {
            status: 'failed',
            failureReason: error.message || 'Payout API call failed',
          },
        });
      });

      return {
        success: false,
        error: `Payout failed: ${error.message}. Amount has been refunded to your wallet.`,
      };
    }
  }

  /** Get paginated withdrawal history */
  async getWithdrawalHistory(userId: string, page: number, limit: number) {
    const skip = (page - 1) * limit;

    const [withdrawals, total] = await Promise.all([
      this.prisma.withdrawalRequest.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.withdrawalRequest.count({ where: { userId } }),
    ]);

    return {
      withdrawals: withdrawals.map((w) => ({
        id: w.id,
        amountCents: w.amountCents,
        platformFeeCents: w.platformFeeCents,
        netPayoutCents: w.netPayoutCents,
        status: w.status,
        utr: w.utr,
        failureReason: w.failureReason,
        createdAt: w.createdAt.toISOString(),
      })),
      total,
      totalPages: Math.ceil(total / limit),
    };
  }

  /** Get withdrawable balance */
  async getWithdrawableBalance(userId: string) {
    const wallet = await this.prisma.wallet.findUnique({ where: { userId } });
    if (!wallet) return { balanceCents: 0 };
    return { balanceCents: Number(wallet.balanceCents) };
  }

  // ─── RazorpayX API Helpers ───

  private async razorpayRequest(method: string, path: string, body?: Record<string, any>, headers?: Record<string, string>) {
    const url = `${this.razorpayBaseUrl}${path}`;
    const res = await fetch(url, {
      method,
      headers: {
        'Authorization': this.basicAuthHeader,
        'Content-Type': 'application/json',
        ...headers,
      },
      body: body ? JSON.stringify(body) : undefined,
    });

    if (!res.ok) {
      const errorBody = await res.text();
      this.logger.error(`RazorpayX API error [${method} ${path}]: ${res.status} ${errorBody}`);
      throw new Error(`RazorpayX API error (${res.status}): ${errorBody}`);
    }

    return res.json();
  }

  private async createContact(userId: string, user: { firstName: string | null; lastName: string | null; email: string }) {
    const name = `${user.firstName || ''} ${user.lastName || ''}`.trim() || 'User';
    return this.razorpayRequest('POST', '/v1/contacts', {
      name,
      email: user.email,
      type: 'vendor',
      reference_id: userId,
    });
  }

  private async createFundAccount(contactId: string, bankDetails: BankDetails) {
    const payload = {
      contact_id: contactId,
      account_type: 'bank_account',
      bank_account: {
        name: bankDetails.accountHolderName,
        ifsc: bankDetails.ifscCode,
        account_number: bankDetails.accountNumber,
      },
    };
    this.logger.log(`Creating fund account: ${JSON.stringify({ ...payload, bank_account: { ...payload.bank_account, account_number: '***' } })}`);
    return this.razorpayRequest('POST', '/v1/fund_accounts', payload);
  }

  private async createPayout(fundAccountId: string, amountPaise: number, idempotencyKey: string) {
    // Note: 'account_number' here is YOUR (platform's) RazorpayX customer identifier,
    // NOT the beneficiary's bank account. For now we'll use a placeholder.
    // In production, this should come from env: RAZORPAYX_ACCOUNT_NUMBER
    const accountNumber = process.env.RAZORPAYX_ACCOUNT_NUMBER || '';

    return this.razorpayRequest('POST', '/v1/payouts', {
      account_number: accountNumber,
      fund_account_id: fundAccountId,
      amount: amountPaise,
      currency: 'INR',
      mode: 'IMPS',
      purpose: 'payout',
      queue_if_low_balance: false,
      reference_id: idempotencyKey,
      narration: 'LaaS Mentor Payout',
    }, {
      'X-Payout-Idempotency': idempotencyKey,
    });
  }
}
