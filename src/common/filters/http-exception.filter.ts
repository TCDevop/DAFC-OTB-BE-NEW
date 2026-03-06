import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { PrismaClientKnownRequestError } from '../../generated/prisma/runtime/library';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message: string | string[] = 'Internal server error';
    let extra: Record<string, unknown> = {};

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();

      if (typeof res === 'string') {
        message = res;
      } else if (typeof res === 'object' && res !== null) {
        const resObj = res as Record<string, unknown>;
        // ValidationPipe trả về mảng message
        if (Array.isArray(resObj.message)) {
          message = (resObj.message as string[]).join('; ');
        } else if (typeof resObj.message === 'string') {
          message = resObj.message;
        } else if (typeof resObj.error === 'string') {
          message = resObj.error;
        }
        // Pass through extra properties (e.g. validation steps)
        const { message: _m, statusCode: _s, error: _e, ...rest } = resObj;
        if (Object.keys(rest).length > 0) extra = rest;
      }
    } else if (exception instanceof PrismaClientKnownRequestError) {
      switch (exception.code) {
        case 'P2025': // Record not found
          status = HttpStatus.NOT_FOUND;
          message = 'Record not found';
          break;
        case 'P2002': // Unique constraint violation
          status = HttpStatus.CONFLICT;
          message = 'Duplicate entry - record already exists';
          break;
        case 'P2003': { // Foreign key constraint
          status = HttpStatus.BAD_REQUEST;
          const fkField = (exception.meta as any)?.field_name || (exception.meta as any)?.modelName || 'unknown';
          message = `Invalid reference - related record not found (field: ${fkField})`;
          break;
        }
        case 'P2014': // Relation violation
          status = HttpStatus.BAD_REQUEST;
          message = 'Relation constraint violation';
          break;
        default:
          status = HttpStatus.BAD_REQUEST;
          message = `Database operation failed (${exception.code}: ${exception.message})`;
      }
    } else if (exception instanceof Error) {
      // Log non-Prisma errors for debugging
      console.error('[HttpExceptionFilter] Unhandled error:', exception.message, exception.stack);
    }
    // Unknown errors → 500 với message generic (không lộ details)

    response.status(status).json({
      success: false,
      statusCode: status,
      message,
      ...extra,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
