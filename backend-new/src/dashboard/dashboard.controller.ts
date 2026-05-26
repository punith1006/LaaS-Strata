import {
  Controller,
  Get,
  Param,
  Query,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import { FastifyReply } from 'fastify';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { DashboardService, HomeDashboardData, BillingData } from './dashboard.service';
import { AnalyticsAdminService } from './analytics-admin.service';

@Controller('api/dashboard')
export class DashboardController {
  constructor(
    private dashboardService: DashboardService,
    private analyticsAdminService: AnalyticsAdminService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Get('home')
  async getHomeData(
    @Req() req: { user: { id: string } },
  ): Promise<HomeDashboardData> {
    return this.dashboardService.getHomeData(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('billing')
  async getBillingData(
    @Req() req: { user: { id: string } },
  ): Promise<BillingData> {
    return this.dashboardService.getBillingData(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Get('health')
  async getPlatformHealth() {
    return this.dashboardService.getPlatformHealth();
  }

  @Get('activity')
  @UseGuards(JwtAuthGuard)
  async getActivity(
    @Req() req: { user: { id: string } },
    @Query('days') days?: string,
  ) {
    return this.dashboardService.getRecentActivity(
      req.user.id,
      parseInt(days || '30', 10),
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/kpi')
  async getAnalyticsKpi(
    @Query('timeRange') timeRange: string,
    @Query('clientId') clientId?: string,
  ) {
    return this.analyticsAdminService.getKpiData(
      (timeRange as '24H' | '7D' | '30D' | 'All') || '7D',
      clientId,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/revenue-chart')
  async getRevenueChart(
    @Query('timeRange') timeRange: string,
    @Query('clientId') clientId?: string,
  ) {
    return this.analyticsAdminService.getRevenueChartData(
      (timeRange as '24H' | '7D' | '30D' | 'All') || '7D',
      clientId,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/compute-activity')
  async getComputeActivity(
    @Query('timeRange') timeRange: string,
    @Query('clientId') clientId?: string,
  ) {
    return this.analyticsAdminService.getComputeActivityData(
      (timeRange as '24H' | '7D' | '30D' | 'All') || '7D',
      clientId,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/users/compute-activity')
  async getUserComputeActivity(
    @Query('userId') userId: string,
    @Query('timeRange') timeRange: string,
  ) {
    return this.analyticsAdminService.getUserComputeActivityData(
      userId,
      (timeRange as '24H' | '7D' | '30D' | 'All') || '30D',
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/active-sessions')
  async getActiveSessions(@Query('clientId') clientId?: string) {
    return this.analyticsAdminService.getActiveSessionsByTier(clientId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/recent-transactions')
  async getRecentTransactions(@Query('clientId') clientId?: string) {
    return this.analyticsAdminService.getRecentTransactions(clientId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/attention-required')
  async getAttentionRequired(@Query('clientId') clientId?: string) {
    return this.analyticsAdminService.getAttentionRequiredData(clientId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/fleet-health')
  async getFleetHealth() {
    return this.analyticsAdminService.getFleetHealthData();
  }

  @Get('analytics/revenue-growth')
  @UseGuards(JwtAuthGuard)
  async getRevenueGrowth(
    @Query('timeRange') timeRange: string,
    @Query('clientId') clientId?: string,
  ) {
    return this.analyticsAdminService.getNetRevenueRetention(timeRange || '7D', clientId);
  }

  @Get('analytics/retention')
  @UseGuards(JwtAuthGuard)
  async getRetention(
    @Query('timeRange') timeRange: string,
    @Query('clientId') clientId?: string,
  ) {
    return this.analyticsAdminService.getRetentionData(timeRange || '7D', clientId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/all-transactions')
  async getAllTransactions(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('search') search?: string,
    @Query('status') status?: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Query('clientId') clientId?: string,
  ) {
    return this.analyticsAdminService.getAllTransactions({
      page: parseInt(page || '1', 10),
      limit: parseInt(limit || '15', 10),
      search: search || undefined,
      status: status || undefined,
      startDate: startDate || undefined,
      endDate: endDate || undefined,
      clientId: clientId || undefined,
    });
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/users')
  async getAnalyticsUsers(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('search') search?: string,
    @Query('status') status?: string,
    @Query('clientId') clientId?: string,
    @Query('departmentId') departmentId?: string,
  ) {
    return this.analyticsAdminService.getAnalyticsUsers({
      page: parseInt(page || '1', 10),
      limit: parseInt(limit || '15', 10),
      search: search || undefined,
      status: status || undefined,
      clientId: clientId || undefined,
      departmentId: departmentId || undefined,
    });
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/users/:userId/detail')
  async getUserDetail(@Param('userId') userId: string) {
    return this.analyticsAdminService.getUserDetail(userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/clients')
  async getAnalyticsClients() {
    return this.analyticsAdminService.getAnalyticsClients();
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/departments')
  async getAnalyticsDepartments(@Query('clientId') clientId: string) {
    return this.analyticsAdminService.getAnalyticsDepartments(clientId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/invoice/:transactionId/download')
  async downloadAdminInvoice(
    @Param('transactionId') transactionId: string,
    @Res() res: FastifyReply,
  ): Promise<void> {
    try {
      const pdfBuffer =
        await this.analyticsAdminService.generateAdminInvoicePdf(transactionId);

      res
        .header('Content-Type', 'application/pdf')
        .header(
          'Content-Disposition',
          `attachment; filename="invoice-${transactionId.slice(0, 8)}.pdf"`,
        )
        .header('Content-Length', pdfBuffer.length)
        .send(pdfBuffer);
    } catch (error) {
      res
        .status(500)
        .send({
          message:
            (error as { message?: string })?.message ||
            'Failed to generate invoice',
        });
    }
  }
}
