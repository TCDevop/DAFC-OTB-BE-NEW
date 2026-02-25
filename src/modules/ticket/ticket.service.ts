import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { Prisma } from '../../generated/prisma';

interface TicketFilters {
  status?: string;
  budgetAllocateId?: string;
  createdBy?: string;
  page?: number;
  pageSize?: number;
}

@Injectable()
export class TicketService {
  constructor(private prisma: PrismaService) {}

  // ─── LIST TICKETS ──────────────────────────────────────────────────────────

  async findAll(filters: TicketFilters) {
    const page = Number(filters.page) || 1;
    const pageSize = Number(filters.pageSize) || 20;

    const where: Prisma.TicketWhereInput = {};
    if (filters.status) where.status = filters.status;
    if (filters.budgetAllocateId) where.budget_allocate_id = +filters.budgetAllocateId;
    if (filters.createdBy) where.created_by = +filters.createdBy;

    const [data, total] = await Promise.all([
      this.prisma.ticket.findMany({
        where,
        include: {
          budget_allocate: {
            include: {
              store: true,
              season_group: true,
              season: true,
              allocate_header: {
                include: {
                  budget: true,
                  brand: true,
                },
              },
            },
          },
          creator: { select: { id: true, name: true, email: true } },
          ticket_approval_logs: {
            include: {
              approver_user: { select: { id: true, name: true } },
              approval_workflow_level: true,
            },
            orderBy: { created_at: 'desc' },
          },
        },
        skip: (page - 1) * pageSize,
        take: pageSize,
        orderBy: { created_at: 'desc' },
      }),
      this.prisma.ticket.count({ where }),
    ]);

    return {
      data,
      meta: { page, pageSize, total, totalPages: Math.ceil(total / pageSize) },
    };
  }

  // ─── GET ONE ───────────────────────────────────────────────────────────────

  async findOne(id: string | number) {
    const ticket = await this.prisma.ticket.findUnique({
      where: { id: +id },
      include: {
        budget_allocate: {
          include: {
            store: true,
            season_group: true,
            season: true,
            allocate_header: {
              include: {
                budget: true,
                brand: { include: { group_brand: true } },
              },
            },
          },
        },
        creator: { select: { id: true, name: true, email: true } },
        ticket_approval_logs: {
          include: {
            approver_user: { select: { id: true, name: true, email: true } },
            approval_workflow_level: true,
          },
          orderBy: { created_at: 'asc' },
        },
      },
    });

    if (!ticket) throw new NotFoundException('Ticket not found');
    return ticket;
  }

  // ─── CREATE ────────────────────────────────────────────────────────────────

  async create(data: { budgetAllocateId: string }, userId: string) {
    const budgetAllocate = await this.prisma.budgetAllocate.findUnique({
      where: { id: +data.budgetAllocateId },
    });
    if (!budgetAllocate) throw new BadRequestException('Budget allocate not found');

    return this.prisma.ticket.create({
      data: {
        budget_allocate_id: +data.budgetAllocateId,
        created_by: +userId,
      },
      include: {
        budget_allocate: {
          include: { store: true, season_group: true, season: true },
        },
        creator: { select: { id: true, name: true } },
      },
    });
  }

  // ─── APPROVE / REJECT (via ApprovalWorkflowLevel) ─────────────────────────

  async processApproval(
    ticketId: string,
    data: {
      approvalWorkflowLevelId: string;
      isApproved: boolean;
      comment?: string;
    },
    userId: string,
  ) {
    const ticket = await this.prisma.ticket.findUnique({ where: { id: +ticketId } });
    if (!ticket) throw new NotFoundException('Ticket not found');

    if (ticket.status !== 'PENDING' && ticket.status !== 'IN_REVIEW') {
      throw new BadRequestException(`Cannot process ticket with status: ${ticket.status}`);
    }

    // Validate workflow level exists
    const level = await this.prisma.approvalWorkflowLevel.findUnique({
      where: { id: +data.approvalWorkflowLevelId },
    });
    if (!level) throw new BadRequestException('Approval workflow level not found');

    // Verify the user is the designated approver
    if (level.approver_user_id !== +userId) {
      throw new BadRequestException('You are not the designated approver for this level');
    }

    // Create approval log
    const log = await this.prisma.ticketApprovalLog.create({
      data: {
        ticket_id: +ticketId,
        approval_workflow_level_id: +data.approvalWorkflowLevelId,
        approver_user_id: +userId,
        is_approved: data.isApproved,
        comment: data.comment,
        approved_at: new Date(),
      },
      include: {
        approver_user: { select: { id: true, name: true } },
        approval_workflow_level: true,
      },
    });

    // Update ticket status
    let newStatus = ticket.status;
    if (!data.isApproved) {
      newStatus = 'REJECTED';
    } else {
      // Check if all required levels are approved
      const workflow = await this.prisma.approvalWorkflow.findFirst({
        where: {
          approval_workflow_levels: {
            some: { id: +data.approvalWorkflowLevelId },
          },
        },
        include: {
          approval_workflow_levels: {
            where: { is_required: true },
            orderBy: { level_order: 'asc' },
          },
        },
      });

      if (workflow) {
        const allLogs = await this.prisma.ticketApprovalLog.findMany({
          where: { ticket_id: +ticketId, is_approved: true },
        });

        const approvedLevelIds = new Set(allLogs.map(l => l.approval_workflow_level_id));
        const allRequiredApproved = workflow.approval_workflow_levels.every(
          lvl => approvedLevelIds.has(lvl.id),
        );

        newStatus = allRequiredApproved ? 'APPROVED' : 'IN_REVIEW';
      } else {
        newStatus = 'APPROVED';
      }
    }

    await this.prisma.ticket.update({
      where: { id: +ticketId },
      data: { status: newStatus },
    });

    return { log, newStatus };
  }

  // ─── GET APPROVAL HISTORY ─────────────────────────────────────────────────

  async getApprovalHistory(ticketId: string) {
    return this.prisma.ticketApprovalLog.findMany({
      where: { ticket_id: +ticketId },
      include: {
        approver_user: { select: { id: true, name: true, email: true } },
        approval_workflow_level: true,
      },
      orderBy: { created_at: 'asc' },
    });
  }

  // ─── STATISTICS ────────────────────────────────────────────────────────────

  async getStatistics() {
    const [total, byStatus] = await Promise.all([
      this.prisma.ticket.count(),
      this.prisma.ticket.groupBy({
        by: ['status'],
        _count: true,
      }),
    ]);

    return {
      total,
      byStatus: byStatus.reduce((acc, s) => {
        acc[s.status] = s._count;
        return acc;
      }, {} as Record<string, number>),
    };
  }
}
