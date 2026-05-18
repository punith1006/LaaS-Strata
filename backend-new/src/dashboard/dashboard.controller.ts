import {
  Controller,
  Get,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
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
  async getAnalyticsKpi(@Query('timeRange') timeRange: string) {
    return this.analyticsAdminService.getKpiData(
      (timeRange as '24H' | '7D' | '30D' | 'All') || '7D',
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytics/revenue-chart')
  async getRevenueChart(@Query('timeRange') timeRange: string) {
    return this.analyticsAdminService.getRevenueChartData(
      (timeRange as '24H' | '7D' | '30D' | 'All') || '7D',
    );
  }
}
