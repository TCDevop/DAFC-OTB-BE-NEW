import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreatePlanningDto, UpdatePlanningDto } from './dto/planning.dto';

interface PlanningFilters {
  page?: number;
  pageSize?: number;
  status?: string;
  budgetId?: string;
}

@Injectable()
export class PlanningService {
  constructor(private prisma: PrismaService) {}

  // ─── LIST ──────────────────────────────────────────────────────────────────

  async findAll(filters: PlanningFilters) {
    const page = Number(filters.page) || 1;
    const pageSize = Number(filters.pageSize) || 20;

    const where: any = {};
    if (filters.status) where.status = filters.status;

    const [data, total] = await Promise.all([
      this.prisma.planningHeader.findMany({
        where,
        include: {
          creator: { select: { id: true, name: true, email: true } },
          _count: {
            select: {
              planning_collections: true,
              planning_genders: true,
              planning_categories: true,
            },
          },
        },
        skip: (page - 1) * pageSize,
        take: pageSize,
        orderBy: { created_at: 'desc' },
      }),
      this.prisma.planningHeader.count({ where }),
    ]);

    return {
      data,
      meta: { page, pageSize, total, totalPages: Math.ceil(total / pageSize) },
    };
  }

  // ─── GET ONE ───────────────────────────────────────────────────────────────

  async findOne(id: string | number) {
    const planning = await this.prisma.planningHeader.findUnique({
      where: { id: +id },
      include: {
        creator: { select: { id: true, name: true, email: true } },
        planning_collections: {
          include: {
            collection: true,
            store: true,
          },
        },
        planning_genders: {
          include: {
            gender: true,
            store: true,
          },
        },
        planning_categories: {
          include: {
            subcategory: {
              include: {
                category: { include: { gender: true } },
              },
            },
          },
        },
      },
    });

    if (!planning) throw new NotFoundException('Planning header not found');
    return planning;
  }

  // ─── CREATE ────────────────────────────────────────────────────────────────

  async create(dto: CreatePlanningDto, userId: string) {
    const lastHeader = await this.prisma.planningHeader.findFirst({
      orderBy: { version: 'desc' },
    });
    const version = (lastHeader?.version || 0) + 1;

    const planning = await this.prisma.planningHeader.create({
      data: {
        version,
        created_by: +userId,
        planning_collections: dto.collections ? {
          create: dto.collections.map(c => ({
            collection_id: +c.collectionId,
            store_id: +c.storeId,
            actual_buy_pct: c.actualBuyPct || 0,
            actual_sales_pct: c.actualSalesPct || 0,
            actual_st_pct: c.actualStPct || 0,
            actual_moc: c.actualMoc || 0,
            proposed_buy_pct: c.proposedBuyPct,
            otb_proposed_amount: c.otbProposedAmount,
            pct_var_vs_last: c.pctVarVsLast || 0,
          })),
        } : undefined,
        planning_genders: dto.genders ? {
          create: dto.genders.map(g => ({
            gender_id: +g.genderId,
            store_id: +g.storeId,
            actual_buy_pct: g.actualBuyPct || 0,
            actual_sales_pct: g.actualSalesPct || 0,
            actual_st_pct: g.actualStPct || 0,
            proposed_buy_pct: g.proposedBuyPct,
            otb_proposed_amount: g.otbProposedAmount,
            pct_var_vs_last: g.pctVarVsLast || 0,
          })),
        } : undefined,
        planning_categories: dto.categories ? {
          create: dto.categories.map(cat => ({
            subcategory_id: +cat.subcategoryId,
            actual_buy_pct: cat.actualBuyPct || 0,
            actual_sales_pct: cat.actualSalesPct || 0,
            actual_st_pct: cat.actualStPct || 0,
            proposed_buy_pct: cat.proposedBuyPct,
            otb_proposed_amount: cat.otbProposedAmount,
            var_lastyear_pct: cat.varLastyearPct || 0,
            otb_actual_amount: cat.otbActualAmount || 0,
            otb_actual_buy_pct: cat.otbActualBuyPct || 0,
          })),
        } : undefined,
      },
      include: {
        creator: { select: { id: true, name: true } },
        planning_collections: { include: { collection: true, store: true } },
        planning_genders: { include: { gender: true, store: true } },
        planning_categories: { include: { subcategory: true } },
      },
    });

    return planning;
  }

  // ─── UPDATE ────────────────────────────────────────────────────────────────

  async update(id: string, dto: UpdatePlanningDto, userId: string) {
    const planning = await this.prisma.planningHeader.findUnique({ where: { id: +id } });
    if (!planning) throw new NotFoundException('Planning header not found');

    if (dto.collections) {
      await this.prisma.planningCollection.deleteMany({ where: { planning_header_id: +id } });
      await this.prisma.planningCollection.createMany({
        data: dto.collections.map(c => ({
          collection_id: +c.collectionId,
          store_id: +c.storeId,
          planning_header_id: +id,
          actual_buy_pct: c.actualBuyPct || 0,
          actual_sales_pct: c.actualSalesPct || 0,
          actual_st_pct: c.actualStPct || 0,
          actual_moc: c.actualMoc || 0,
          proposed_buy_pct: c.proposedBuyPct,
          otb_proposed_amount: c.otbProposedAmount,
          pct_var_vs_last: c.pctVarVsLast || 0,
        })),
      });
    }

    if (dto.genders) {
      await this.prisma.planningGender.deleteMany({ where: { planning_header_id: +id } });
      await this.prisma.planningGender.createMany({
        data: dto.genders.map(g => ({
          gender_id: +g.genderId,
          store_id: +g.storeId,
          planning_header_id: +id,
          actual_buy_pct: g.actualBuyPct || 0,
          actual_sales_pct: g.actualSalesPct || 0,
          actual_st_pct: g.actualStPct || 0,
          proposed_buy_pct: g.proposedBuyPct,
          otb_proposed_amount: g.otbProposedAmount,
          pct_var_vs_last: g.pctVarVsLast || 0,
        })),
      });
    }

    if (dto.categories) {
      await this.prisma.planningCategory.deleteMany({ where: { planning_header_id: +id } });
      await this.prisma.planningCategory.createMany({
        data: dto.categories.map(cat => ({
          subcategory_id: +cat.subcategoryId,
          planning_header_id: +id,
          actual_buy_pct: cat.actualBuyPct || 0,
          actual_sales_pct: cat.actualSalesPct || 0,
          actual_st_pct: cat.actualStPct || 0,
          proposed_buy_pct: cat.proposedBuyPct,
          otb_proposed_amount: cat.otbProposedAmount,
          var_lastyear_pct: cat.varLastyearPct || 0,
          otb_actual_amount: cat.otbActualAmount || 0,
          otb_actual_buy_pct: cat.otbActualBuyPct || 0,
        })),
      });
    }

    return this.findOne(id);
  }

  // ─── COPY FROM EXISTING ────────────────────────────────────────────────────

  async createFromVersion(sourceId: string, userId: string) {
    const source = await this.prisma.planningHeader.findUnique({
      where: { id: +sourceId },
      include: {
        planning_collections: true,
        planning_genders: true,
        planning_categories: true,
      },
    });

    if (!source) throw new NotFoundException('Source planning header not found');

    const lastHeader = await this.prisma.planningHeader.findFirst({
      orderBy: { version: 'desc' },
    });
    const version = (lastHeader?.version || 0) + 1;

    return this.prisma.planningHeader.create({
      data: {
        version,
        created_by: +userId,
        planning_collections: {
          create: source.planning_collections.map(c => ({
            collection_id: c.collection_id,
            store_id: c.store_id,
            actual_buy_pct: c.actual_buy_pct,
            actual_sales_pct: c.actual_sales_pct,
            actual_st_pct: c.actual_st_pct,
            actual_moc: c.actual_moc,
            proposed_buy_pct: c.proposed_buy_pct,
            otb_proposed_amount: c.otb_proposed_amount,
            pct_var_vs_last: c.pct_var_vs_last,
          })),
        },
        planning_genders: {
          create: source.planning_genders.map(g => ({
            gender_id: g.gender_id,
            store_id: g.store_id,
            actual_buy_pct: g.actual_buy_pct,
            actual_sales_pct: g.actual_sales_pct,
            actual_st_pct: g.actual_st_pct,
            proposed_buy_pct: g.proposed_buy_pct,
            otb_proposed_amount: g.otb_proposed_amount,
            pct_var_vs_last: g.pct_var_vs_last,
          })),
        },
        planning_categories: {
          create: source.planning_categories.map(cat => ({
            subcategory_id: cat.subcategory_id,
            actual_buy_pct: cat.actual_buy_pct,
            actual_sales_pct: cat.actual_sales_pct,
            actual_st_pct: cat.actual_st_pct,
            proposed_buy_pct: cat.proposed_buy_pct,
            otb_proposed_amount: cat.otb_proposed_amount,
            var_lastyear_pct: cat.var_lastyear_pct,
            otb_actual_amount: cat.otb_actual_amount,
            otb_actual_buy_pct: cat.otb_actual_buy_pct,
          })),
        },
      },
      include: {
        creator: { select: { id: true, name: true } },
        planning_collections: { include: { collection: true, store: true } },
        planning_genders: { include: { gender: true, store: true } },
        planning_categories: { include: { subcategory: true } },
      },
    });
  }

  // ─── CATEGORY FILTER OPTIONS ────────────────────────────────────────────────

  async getCategoryFilterOptions(genderId?: string, categoryId?: string) {
    const genders = await this.prisma.gender.findMany({
      where: { is_active: true },
      select: { id: true, name: true },
      orderBy: { name: 'asc' },
    });

    const categoryWhere: any = { is_active: true };
    if (genderId) categoryWhere.gender_id = +genderId;

    const categories = await this.prisma.category.findMany({
      where: categoryWhere,
      select: { id: true, name: true, gender_id: true },
      orderBy: { name: 'asc' },
    });

    const subCategoryWhere: any = { is_active: true };
    if (categoryId) {
      subCategoryWhere.category_id = +categoryId;
    } else if (genderId) {
      subCategoryWhere.category = { gender_id: +genderId };
    }

    const subCategories = await this.prisma.subCategory.findMany({
      where: subCategoryWhere,
      select: { id: true, name: true, category_id: true },
      orderBy: { name: 'asc' },
    });

    return { genders, categories, subCategories };
  }

  // ─── DELETE ────────────────────────────────────────────────────────────────

  async remove(id: string) {
    const planning = await this.prisma.planningHeader.findUnique({ where: { id: +id } });
    if (!planning) throw new NotFoundException('Planning header not found');

    return this.prisma.planningHeader.delete({ where: { id: +id } });
  }
}
