import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import multipart from '@fastify/multipart';
import { AppModule } from './app.module';
import { GlobalExceptionFilter } from './common/http-exception.filter';
import { map } from 'rxjs';

// NestJS global interceptor that converts BigInt to Number before Fastify serialization
const BigIntInterceptor = {
  intercept: (_context: any, next: { handle: () => any }) =>
    next.handle().pipe(
      map((data: unknown) =>
        JSON.parse(
          JSON.stringify(data, (_key: string, value: unknown) =>
            typeof value === 'bigint' ? Number(value) : value,
          ),
        ),
      ),
    ),
};

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter(),
  );

  // Register multipart for file uploads (500MB limit)
  await app.register(multipart, { limits: { fileSize: 500 * 1024 * 1024 } });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  app.useGlobalFilters(new GlobalExceptionFilter());

  app.enableCors({
    origin: process.env.CORS_ORIGIN ?? true,
    credentials: true,
    methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE', 'OPTIONS'],
  });

  // Global interceptor to convert BigInt to Number before Fastify serialization
  app.useGlobalInterceptors(BigIntInterceptor);

  const port = process.env.PORT ?? 3001;
  await app.listen(port, '0.0.0.0');
  console.log(`Backend running on http://localhost:${port}`);
}
bootstrap();
