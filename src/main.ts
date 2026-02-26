import 'dotenv/config';
// Global BigInt serialization fix — BigInt không serialize được JSON mặc định
(BigInt.prototype as any).toJSON = function () { return Number(this); };

import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import helmet from 'helmet';
import { json, urlencoded } from 'express';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Increase body size limit for large planning payloads
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ limit: '10mb', extended: true }));

  // Security
  app.use(helmet());

  // CORS - allow multiple localhost ports for development
  const envOrigin = process.env.CORS_ORIGIN?.replace(/\/$/, '');
  const allowedOrigins = [
    'http://localhost:4000', 'http://localhost:3000', 'http://localhost:3002', 'http://localhost:3006',
    ...(envOrigin ? [envOrigin] : []),
  ];
  app.enableCors({
    origin: (origin, callback) => {
      // Allow requests with no origin (like mobile apps or curl)
      if (!origin) return callback(null, true);
      if (allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(null, false);
      }
    },
    credentials: true,
  });

  // Global prefix
  app.setGlobalPrefix('api/v1');

  // Validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  // Swagger API Documentation
  const config = new DocumentBuilder()
    .setTitle('DAFC OTB Planning API')
    .setDescription('Open-To-Buy Planning Management System for Luxury Fashion')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('auth', 'Authentication & Authorization')
    .addTag('master-data', 'Brands, Stores, Collections, Categories, SKU Catalog')
    .addTag('budgets', 'Budget Management')
    .addTag('planning', 'OTB Planning & Versions')
    .addTag('proposals', 'SKU Proposals')
    .addTag('approvals', 'Approval Workflow')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 4000;
  await app.listen(port);

  console.log(`
  ┌──────────────────────────────────────────┐
  │   DAFC OTB Backend API                   │
  │   Running on: http://localhost:${port}       │
  │   Swagger:    http://localhost:${port}/api/docs │
  └──────────────────────────────────────────┘
  `);
}

bootstrap();
