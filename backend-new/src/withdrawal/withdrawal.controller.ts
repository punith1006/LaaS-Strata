import {
  Controller,
  Post,
  Get,
  Body,
  Query,
  UseGuards,
  Req,
  ParseIntPipe,
  DefaultValuePipe,
  BadRequestException,
} from '@nestjs/common';
import { WithdrawalService } from './withdrawal.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/withdrawal')
export class WithdrawalController {
  constructor(private readonly withdrawalService: WithdrawalService) {}

  @Post('request')
  async requestWithdrawal(
    @Req() req: { user: { id: string } },
    @Body() body: { amountCents: number; accountNumber: string; ifscCode: string; accountHolderName: string },
  ) {
    const amountCents = typeof body.amountCents === 'number' ? body.amountCents : parseInt(String(body.amountCents), 10);
    if (isNaN(amountCents)) {
      throw new BadRequestException('amountCents must be a valid number');
    }
    return this.withdrawalService.requestWithdrawal(req.user.id, amountCents, {
      accountNumber: body.accountNumber,
      ifscCode: body.ifscCode,
      accountHolderName: body.accountHolderName,
    });
  }

  @Get('history')
  async getHistory(
    @Req() req: { user: { id: string } },
    @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
    @Query('limit', new DefaultValuePipe(10), ParseIntPipe) limit: number,
  ) {
    return this.withdrawalService.getWithdrawalHistory(req.user.id, page, limit);
  }

  @Get('balance')
  async getBalance(@Req() req: { user: { id: string } }) {
    return this.withdrawalService.getWithdrawableBalance(req.user.id);
  }
}
