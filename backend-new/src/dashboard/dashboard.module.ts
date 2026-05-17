import { Module } from '@nestjs/common';
import { DashboardController } from './dashboard.controller';
import { DashboardService } from './dashboard.service';
import { AnalyticsAdminService } from './analytics-admin.service';
import { PrismaModule } from '../prisma/prisma.module';
import { StorageModule } from '../storage/storage.module';

@Module({
  imports: [PrismaModule, StorageModule],
  controllers: [DashboardController],
  providers: [DashboardService, AnalyticsAdminService],
  exports: [DashboardService, AnalyticsAdminService],
})
export class DashboardModule {}
