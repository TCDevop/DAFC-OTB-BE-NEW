import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { Prisma } from '../../generated/prisma';
import { CreateBudgetDto, UpdateBudgetDto, CreateAllocateDto, UpdateAllocateDto } from './dto/budget.dto';

interface BudgetFilters {
  fiscalYear?: number;
  status?: string;
  page?: number;
  pageSize?: number;
}

@Injectable()
export class BudgetService {
  constructor(private prisma: PrismaService) {}

  // ─── LIST BUDGETS ──────────────────────────────────────────────────────────

  async findAll(filters: BudgetFilters) {
    const { fiscalYear, status, page = 1, pageSize = 20 } = filters;

    const where: Prisma.BudgetWhereInput = {};
    if (fiscalYear) where.fiscal_year = fiscalYear;
    if (status) where.status = status;

    const [data, total] = await Promise.all([
      this.prisma.budget.findMany({
        where,
        include: {
          creator: { select: { id: true, name: true, email: true } },
          allocate_headers: {
            include: {
              brand: { include: { group_brand: true } },
              budget_allocates: {
                include: { store: true, season_group: true, season: true },
              },
            },
            orderBy: { version: 'desc' },
            take: 1,
          },
        },
        skip: (page - 1) * pageSize,
        take: pageSize,
        orderBy: { created_at: 'desc' },
      }),
      this.prisma.budget.count({ where }),
    ]);

    return {
      data,
      meta: { page, pageSize, total, totalPages: Math.ceil(total / pageSize) },
    };
  }

  // ─── GET ONE ───────────────────────────────────────────────────────────────

  async findOne(id: string | number) {
    const budget = await this.prisma.budget.findUnique({
      where: { id: +id },
      include: {
        creator: { select: { id: true, name: true, email: true } },
        allocate_headers: {
          include: {
            brand: { include: { group_brand: true } },
            creator: { select: { id: true, name: true, email: true } },
            budget_allocates: {
              include: { store: true, season_group: true, season: true },
            },
          },
          orderBy: { version: 'desc' },
        },
      },
    });

    if (!budget) throw new NotFoundException('Budget not found');
    return budget;
  }

  // ─── CREATE ────────────────────────────────────────────────────────────────

  async create(dto: CreateBudgetDto, userId: string) {
    const budget = await this.prisma.budget.create({
      data: {
        name: dto.name,
        amount: dto.amount,
        description: dto.description,
        fiscal_year: dto.fiscalYear,
        created_by: +userId,
      },
    });

    if (dto.brandId) {
      const brand = await this.prisma.brand.findUnique({ where: { id: +dto.brandId } });
      if (!brand) throw new BadRequestException('Brand not found');

      if (dto.allocations && dto.allocations.length > 0) {
        await this.createAllocateHeader(budget.id, dto.brandId, dto.allocations, userId);
      } else {
        const lastHeader = await this.prisma.allocateHeader.findFirst({
          where: { budget_id: budget.id },
          orderBy: { version: 'desc' },
        });
        const version = (lastHeader?.version || 0) + 1;
        await this.prisma.allocateHeader.create({
          data: {
            budget_id: budget.id,
            brand_id: +dto.brandId,
            version,
            is_final_version: false,
            created_by: +userId,
          },
        });
      }
    }

    return this.findOne(budget.id);
  }

  // ─── UPDATE ────────────────────────────────────────────────────────────────

  async update(id: string, dto: UpdateBudgetDto, userId: string) {
    const budget = await this.prisma.budget.findUnique({ where: { id: +id } });
    if (!budget) throw new NotFoundException('Budget not found');

    if (budget.status !== 'DRAFT') {
      throw new ForbiddenException('Only draft budgets can be edited');
    }

    const updateData: Prisma.BudgetUpdateInput = {};
    if (dto.name !== undefined) updateData.name = dto.name;
    if (dto.amount !== undefined) updateData.amount = dto.amount;
    if (dto.description !== undefined) updateData.description = dto.description;

    return this.prisma.budget.update({
      where: { id: +id },
      data: updateData,
    });
  }

  // ─── CREATE ALLOCATE HEADER ────────────────────────────────────────────────

  async createAllocateHeader(budgetId: string | number, brandId: string | number, allocations: CreateAllocateDto['allocations'], userId: string | number, isFinalVersion = false) {
    const budget = await this.prisma.budget.findUnique({ where: { id: +budgetId } });
    if (!budget) throw new NotFoundException('Budget not found');

    const brand = await this.prisma.brand.findUnique({ where: { id: +brandId } });
    if (!brand) throw new BadRequestException('Brand not found');

    const lastHeader = await this.prisma.allocateHeader.findFirst({
      where: { budget_id: +budgetId },
      orderBy: { version: 'desc' },
    });
    const version = (lastHeader?.version || 0) + 1;

    const validAllocations = allocations.filter(a => a.budgetAmount > 0);
    if (validAllocations.length === 0) {
      throw new BadRequestException('At least one allocation must have amount > 0');
    }

    return this.prisma.allocateHeader.create({
      data: {
        budget_id: +budgetId,
        brand_id: +brandId,
        version,
        is_final_version: isFinalVersion,
        created_by: +userId,
        budget_allocates: {
          create: allocations.map(a => ({
            store_id: +a.storeId,
            season_group_id: +a.seasonGroupId,
            season_id: +a.seasonId,
            budget_amount: a.budgetAmount,
          })),
        },
      },
      include: {
        brand: { include: { group_brand: true } },
        budget_allocates: {
          include: { store: true, season_group: true, season: true },
        },
      },
    });
  }

  // ─── UPDATE ALLOCATE HEADER ────────────────────────────────────────────────

  async updateAllocateHeader(headerId: string, dto: UpdateAllocateDto, userId: string) {
    const header = await this.prisma.allocateHeader.findUnique({
      where: { id: +headerId },
      include: { budget: true },
    });
    if (!header) throw new NotFoundException('Allocate header not found');

    if (header.budget.status !== 'DRAFT') {
      throw new ForbiddenException('Only draft budget allocations can be edited');
    }

    if (dto.isFinalVersion !== undefined) {
      await this.prisma.allocateHeader.update({
        where: { id: +headerId },
        data: { is_final_version: dto.isFinalVersion },
      });
    }

    await this.prisma.budgetAllocate.deleteMany({ where: { allocate_header_id: +headerId } });

    await this.prisma.budgetAllocate.createMany({
      data: dto.allocations.map(a => ({
        allocate_header_id: +headerId,
        store_id: +a.storeId,
        season_group_id: +a.seasonGroupId,
        season_id: +a.seasonId,
        budget_amount: a.budgetAmount,
      })),
    });

    return this.prisma.allocateHeader.findUnique({
      where: { id: +headerId },
      include: {
        brand: { include: { group_brand: true } },
        budget_allocates: {
          include: { store: true, season_group: true, season: true },
        },
      },
    });
  }

  // ─── SUBMIT ────────────────────────────────────────────────────────────────

  async submit(id: string, userId: string) {
    const budget = await this.prisma.budget.findUnique({
      where: { id: +id },
      include: { allocate_headers: true },
    });
    if (!budget) throw new NotFoundException('Budget not found');

    if (budget.status !== 'DRAFT') {
      throw new BadRequestException(`Cannot submit budget with status: ${budget.status}`);
    }

    return this.prisma.budget.update({
      where: { id: +id },
      data: { status: 'SUBMITTED' },
    });
  }

  // ─── APPROVE ───────────────────────────────────────────────────────────────

  async approve(id: string, userId: string) {
    const budget = await this.prisma.budget.findUnique({ where: { id: +id } });
    if (!budget) throw new NotFoundException('Budget not found');

    if (budget.status !== 'SUBMITTED') {
      throw new BadRequestException(`Cannot approve budget with status: ${budget.status}. Must be SUBMITTED.`);
    }

    return this.prisma.budget.update({
      where: { id: +id },
      data: { status: 'APPROVED' },
    });
  }

  // ─── REJECT ────────────────────────────────────────────────────────────────

  async reject(id: string, userId: string) {
    const budget = await this.prisma.budget.findUnique({ where: { id: +id } });
    if (!budget) throw new NotFoundException('Budget not found');

    if (budget.status !== 'SUBMITTED') {
      throw new BadRequestException(`Cannot reject budget with status: ${budget.status}. Must be SUBMITTED.`);
    }

    return this.prisma.budget.update({
      where: { id: +id },
      data: { status: 'REJECTED' },
    });
  }

  // ─── DELETE ────────────────────────────────────────────────────────────────

  async remove(id: string) {
    const budget = await this.prisma.budget.findUnique({ where: { id: +id } });
    if (!budget) throw new NotFoundException('Budget not found');

    if (budget.status !== 'DRAFT') {
      throw new ForbiddenException('Only draft budgets can be deleted');
    }

    return this.prisma.budget.delete({ where: { id: +id } });
  }

  // ─── SET FINAL ALLOCATE VERSION ────────────────────────────────────────────

  async setFinalVersion(headerId: string) {
    const header = await this.prisma.allocateHeader.findUnique({
      where: { id: +headerId },
    });
    if (!header) throw new NotFoundException('Allocate header not found');

    // Unset final for all other headers of same brand + budget
    await this.prisma.allocateHeader.updateMany({
      where: {
        budget_id: header.budget_id,
        brand_id: header.brand_id,
        id: { not: +headerId },
      },
      data: { is_final_version: false },
    });

    return this.prisma.allocateHeader.update({
      where: { id: +headerId },
      data: { is_final_version: true },
      include: {
        brand: { include: { group_brand: true } },
        budget_allocates: {
          include: { store: true, season_group: true, season: true },
        },
      },
    });
  }

  // ─── STATISTICS ────────────────────────────────────────────────────────────

  async getStatistics(fiscalYear?: number) {
    const where: Prisma.BudgetWhereInput = {};
    if (fiscalYear) where.fiscal_year = fiscalYear;

    const [total, byStatus, totalAmount] = await Promise.all([
      this.prisma.budget.count({ where }),
      this.prisma.budget.groupBy({
        by: ['status'],
        where,
        _count: true,
      }),
      this.prisma.budget.aggregate({
        where,
        _sum: { amount: true },
      }),
    ]);

    const approvedBudgets = await this.prisma.budget.aggregate({
      where: { ...where, status: 'APPROVED' },
      _sum: { amount: true },
    });

    return {
      totalBudgets: total,
      totalAmount: totalAmount._sum.amount || 0,
      approvedAmount: approvedBudgets._sum.amount || 0,
      byStatus: byStatus.reduce((acc, item) => {
        acc[item.status] = item._count;
        return acc;
      }, {} as Record<string, number>),
    };
  }
}
