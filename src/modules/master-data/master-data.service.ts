import { Injectable } from '@nestjs/common';
import { Prisma } from '../../generated/prisma';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class MasterDataService {
  constructor(private prisma: PrismaService) {}

  // ─── GROUP BRANDS ────────────────────────────────────────────────────────
  async getGroupBrands() {
    return this.prisma.groupBrand.findMany({
      where: { is_active: true },
      include: {
        brands: {
          where: { is_active: true },
          orderBy: { name: 'asc' },
        },
      },
      orderBy: { name: 'asc' },
    });
  }

  // ─── BRANDS ──────────────────────────────────────────────────────────────
  async getBrands(groupBrandId?: string) {
    const where: Prisma.BrandWhereInput = { is_active: true };
    if (groupBrandId) where.group_brand_id = +groupBrandId;

    return this.prisma.brand.findMany({
      where,
      include: { group_brand: true },
      orderBy: { name: 'asc' },
    });
  }

  // ─── STORES ──────────────────────────────────────────────────────────────
  async getStores() {
    return this.prisma.store.findMany({
      where: { is_active: true },
      orderBy: { code: 'asc' },
    });
  }

  // ─── COLLECTIONS ─────────────────────────────────────────────────────────
  async getCollections() {
    return this.prisma.collection.findMany({
      where: { is_active: true },
      orderBy: { name: 'asc' },
    });
  }

  // ─── SEASON GROUPS & SEASONS ─────────────────────────────────────────────
  async getSeasonGroups() {
    return this.prisma.seasonGroup.findMany({
      where: { is_active: true },
      include: {
        seasons: {
          where: { is_active: true },
          orderBy: { name: 'asc' },
        },
      },
      orderBy: { name: 'asc' },
    });
  }

  async getSeasons(seasonGroupId?: string) {
    const where: Prisma.SeasonWhereInput = { is_active: true };
    if (seasonGroupId) where.season_group_id = +seasonGroupId;

    return this.prisma.season.findMany({
      where,
      include: { season_group: true },
      orderBy: { name: 'asc' },
    });
  }

  // ─── GENDERS ─────────────────────────────────────────────────────────────
  async getGenders() {
    return this.prisma.gender.findMany({
      where: { is_active: true },
      orderBy: { name: 'asc' },
    });
  }

  // ─── CATEGORIES (Full Hierarchy) ─────────────────────────────────────────
  async getCategories(genderId?: string) {
    const where: Prisma.GenderWhereInput = { is_active: true };
    if (genderId) where.id = +genderId;

    return this.prisma.gender.findMany({
      where,
      include: {
        categories: {
          where: { is_active: true },
          include: {
            sub_categories: {
              where: { is_active: true },
              include: {
                subcategory_sizes: {
                  orderBy: { name: 'asc' },
                },
              },
              orderBy: { name: 'asc' },
            },
          },
          orderBy: { name: 'asc' },
        },
      },
      orderBy: { name: 'asc' },
    });
  }

  // ─── SUB-CATEGORIES ──────────────────────────────────────────────────────
  async getSubCategories(categoryId?: string, genderId?: string) {
    const where: any = { is_active: true };
    if (categoryId) where.category_id = categoryId;
    else if (genderId) where.category = { gender_id: genderId };

    return this.prisma.subCategory.findMany({
      where,
      include: {
        category: { include: { gender: true } },
      },
      orderBy: { name: 'asc' },
    });
  }

  // ─── SUBCATEGORY SIZES ───────────────────────────────────────────────────
  async getSubcategorySizes(subCategoryId: string) {
    return this.prisma.subcategorySize.findMany({
      where: { sub_category_id: +subCategoryId },
      orderBy: { name: 'asc' },
    });
  }

  // ─── APPROVAL STATUSES ──────────────────────────────────────────────────
  async getApprovalStatuses() {
    return this.prisma.approvalStatus.findMany({
      where: { is_active: true },
      orderBy: { name: 'asc' },
    });
  }

  // ─── FISCAL YEARS ────────────────────────────────────────────────────────
  async getFiscalYears() {
    const rows = await this.prisma.budget.findMany({
      distinct: ['fiscal_year'],
      select: { fiscal_year: true },
      orderBy: { fiscal_year: 'desc' },
    });
    return rows.map(r => r.fiscal_year);
  }

  // ─── PLANNING FILTER OPTIONS (gộp 1 call) ────────────────────────────────
  async getPlanningFilterOptions() {
    const [groupBrands, seasonGroups, stores, fiscalYears] = await Promise.all([
      this.getGroupBrands(),
      this.getSeasonGroups(),
      this.getStores(),
      this.getFiscalYears(),
    ]);

    // Flatten brands từ groupBrands
    const brands = groupBrands.flatMap(gb =>
      (gb.brands || []).map(b => ({ ...b, group_brand: { id: gb.id, code: gb.code, name: gb.name } }))
    );

    return { groupBrands, brands, seasonGroups, stores, fiscalYears };
  }

  // ─── PROPOSAL FILTER OPTIONS ─────────────────────────────────────────────
  async getProposalFilterOptions() {
    const [genders, seasonGroups, stores] = await Promise.all([
      this.getGenders(),
      this.getSeasonGroups(),
      this.getStores(),
    ]);

    const categories = await this.prisma.category.findMany({
      where: { is_active: true },
      include: {
        gender: true,
        sub_categories: {
          where: { is_active: true },
          orderBy: { name: 'asc' },
        },
      },
      orderBy: { name: 'asc' },
    });

    return { genders, categories, seasonGroups, stores };
  }

  // ─── PRODUCTS (SKU CATALOG) ──────────────────────────────────────────────
  async getProducts(filters?: {
    brandId?: string;
    subCategoryId?: string;
    search?: string;
    page?: number;
    pageSize?: number;
  }) {
    const page = filters?.page || 1;
    const pageSize = filters?.pageSize || 50;

    const where: Prisma.ProductWhereInput = { is_active: true };
    if (filters?.brandId) where.brand_id = +filters.brandId;
    if (filters?.subCategoryId) where.sub_category_id = +filters.subCategoryId;
    if (filters?.search) {
      where.OR = [
        { sku_code: { contains: filters.search, mode: 'insensitive' } },
        { product_name: { contains: filters.search, mode: 'insensitive' } },
      ];
    }

    const [data, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        include: {
          brand: true,
          sub_category: {
            include: {
              category: {
                include: { gender: true },
              },
            },
          },
        },
        skip: (Number(page) - 1) * Number(pageSize),
        take: Number(pageSize),
        orderBy: { sku_code: 'asc' },
      }),
      this.prisma.product.count({ where }),
    ]);

    return {
      data,
      meta: {
        page: Number(page),
        pageSize: Number(pageSize),
        total,
        totalPages: Math.ceil(total / Number(pageSize)),
      },
    };
  }
}
