import { Controller, Get, Post, Param, Query, Body, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PermissionsGuard, RequirePermissions } from '../../common/guards/permissions.guard';
import { TicketService } from './ticket.service';

@ApiTags('tickets')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('tickets')
export class TicketController {
  constructor(private ticketService: TicketService) {}

  @Get()
  @RequirePermissions('ticket:read')
  @ApiOperation({ summary: 'List tickets with filters and pagination' })
  @ApiQuery({ name: 'status', required: false, enum: ['PENDING', 'IN_REVIEW', 'APPROVED', 'REJECTED'] })
  @ApiQuery({ name: 'budgetAllocateId', required: false })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'pageSize', required: false, type: Number })
  async findAll(
    @Query('status') status?: string,
    @Query('budgetAllocateId') budgetAllocateId?: string,
    @Query('page') page?: number,
    @Query('pageSize') pageSize?: number,
  ) {
    const result = await this.ticketService.findAll({ status, budgetAllocateId, page, pageSize });
    return { success: true, ...result };
  }

  @Get('statistics')
  @RequirePermissions('ticket:read')
  @ApiOperation({ summary: 'Get ticket statistics' })
  async getStatistics() {
    return { success: true, data: await this.ticketService.getStatistics() };
  }

  @Get(':id')
  @RequirePermissions('ticket:read')
  @ApiOperation({ summary: 'Get ticket details with approval history' })
  async findOne(@Param('id') id: string) {
    return { success: true, data: await this.ticketService.findOne(id) };
  }

  @Post()
  @RequirePermissions('ticket:write')
  @ApiOperation({ summary: 'Create a new ticket for a budget allocation' })
  async create(@Body() body: { budgetAllocateId: string }, @Request() req: any) {
    return { success: true, data: await this.ticketService.create(body, req.user.sub) };
  }

  @Post(':id/approve')
  @RequirePermissions('ticket:approve')
  @ApiOperation({ summary: 'Process approval decision on a ticket' })
  async processApproval(
    @Param('id') id: string,
    @Body() body: {
      approvalWorkflowLevelId: string;
      isApproved: boolean;
      comment?: string;
    },
    @Request() req: any,
  ) {
    return { success: true, data: await this.ticketService.processApproval(id, body, req.user.sub) };
  }

  @Get(':id/history')
  @RequirePermissions('ticket:read')
  @ApiOperation({ summary: 'Get approval history for a ticket' })
  async getApprovalHistory(@Param('id') id: string) {
    return { success: true, data: await this.ticketService.getApprovalHistory(id) };
  }
}
