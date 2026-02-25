import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import {
  CreateSKUProposalHeaderDto,
  AddProductDto,
  BulkAddProductsDto,
  UpdateSKUProposalDto,
  BulkSKUAllocateDto,
  BulkProposalSizingDto,
  CreateProposalSizingHeaderDto,
} from './dto/proposal.dto';

interface ProposalFilters {
  page?: number;
  pageSize?: number;
  status?: string;
}

@Injectable()
export class ProposalService {
  constructor(private prisma: PrismaService) {}

  // ─── LIST SKU PROPOSAL HEADERS ─────────────────────────────────────────────

  async findAll(filters: ProposalFilters) {
    const page = Number(filters.page) || 1;
    const pageSize = Number(filters.pageSize) || 20;

    const where: any = {};
    if (filters.status) where.status = filters.status;

    const [data, total] = await Promise.all([
      this.prisma.sKUProposalHeader.findMany({
        where,
        include: {
          creator: { select: { id: true, name: true, email: true } },
          _count: { select: { sku_proposals: true } },
        },
        skip: (page - 1) * pageSize,
        take: pageSize,
        orderBy: { created_at: 'desc' },
      }),
      this.prisma.sKUProposalHeader.count({ where }),
    ]);

    return {
      data,
      meta: { page, pageSize, total, totalPages: Math.ceil(total / pageSize) },
    };
  }

  // ─── GET ONE ───────────────────────────────────────────────────────────────

  async findOne(id: string | number) {
    const header = await this.prisma.sKUProposalHeader.findUnique({
      where: { id: +id },
      include: {
        creator: { select: { id: true, name: true, email: true } },
        sku_proposals: {
          include: {
            product: {
              include: {
                brand: true,
                sub_category: {
                  include: {
                    category: { include: { gender: true } },
                  },
                },
              },
            },
            sku_allocates: {
              include: { store: true },
            },
            proposal_sizing_headers: {
              include: {
                creator: { select: { id: true, name: true } },
                proposal_sizings: {
                  include: { subcategory_size: true },
                },
              },
              orderBy: { version: 'desc' },
            },
          },
        },
      },
    });

    if (!header) throw new NotFoundException('SKU Proposal Header not found');
    return header;
  }

  // ─── CREATE ────────────────────────────────────────────────────────────────

  async create(dto: CreateSKUProposalHeaderDto, userId: string) {
    const lastHeader = await this.prisma.sKUProposalHeader.findFirst({
      orderBy: { version: 'desc' },
    });
    const version = (lastHeader?.version || 0) + 1;

    for (const item of dto.proposals) {
      const product = await this.prisma.product.findUnique({ where: { id: +item.productId } });
      if (!product) throw new BadRequestException(`Product not found: ${item.productId}`);
    }

    return this.prisma.sKUProposalHeader.create({
      data: {
        version,
        created_by: +userId,
        sku_proposals: {
          create: dto.proposals.map(item => ({
            product_id: +item.productId,
            customer_target: item.customerTarget,
            unit_cost: item.unitCost,
            srp: item.srp,
          })),
        },
      },
      include: {
        creator: { select: { id: true, name: true } },
        sku_proposals: {
          include: { product: true },
        },
      },
    });
  }

  // ─── ADD PRODUCT ───────────────────────────────────────────────────────────

  async addProduct(headerId: string, dto: AddProductDto, userId: string) {
    const header = await this.prisma.sKUProposalHeader.findUnique({ where: { id: +headerId } });
    if (!header) throw new NotFoundException('SKU Proposal Header not found');

    const product = await this.prisma.product.findUnique({ where: { id: +dto.productId } });
    if (!product) throw new BadRequestException('Product not found');

    const existing = await this.prisma.sKUProposal.findFirst({
      where: { sku_proposal_header_id: +headerId, product_id: +dto.productId },
    });
    if (existing) {
      throw new BadRequestException('Product already exists in this proposal');
    }

    return this.prisma.sKUProposal.create({
      data: {
        sku_proposal_header_id: +headerId,
        product_id: +dto.productId,
        customer_target: dto.customerTarget,
        unit_cost: dto.unitCost,
        srp: dto.srp,
      },
      include: { product: true },
    });
  }

  // ─── BULK ADD PRODUCTS ─────────────────────────────────────────────────────

  async bulkAddProducts(headerId: string, dto: BulkAddProductsDto, userId: string) {
    const results: Array<{ success: boolean; productId: string; data?: any; error?: string }> = [];

    for (const productDto of dto.products) {
      try {
        const data = await this.addProduct(headerId, productDto, userId);
        results.push({ success: true, productId: productDto.productId, data });
      } catch (error: any) {
        results.push({ success: false, productId: productDto.productId, error: error.message });
      }
    }

    return results;
  }

  // ─── UPDATE SKU PROPOSAL ───────────────────────────────────────────────────

  async updateProposal(proposalId: string, dto: UpdateSKUProposalDto) {
    const proposal = await this.prisma.sKUProposal.findUnique({ where: { id: +proposalId } });
    if (!proposal) throw new NotFoundException('SKU Proposal not found');

    const updateData: any = {};
    if (dto.customerTarget !== undefined) updateData.customer_target = dto.customerTarget;
    if (dto.unitCost !== undefined) updateData.unit_cost = dto.unitCost;
    if (dto.srp !== undefined) updateData.srp = dto.srp;

    return this.prisma.sKUProposal.update({
      where: { id: +proposalId },
      data: updateData,
      include: { product: true },
    });
  }

  // ─── REMOVE SKU PROPOSAL ──────────────────────────────────────────────────

  async removeProposal(proposalId: string) {
    const proposal = await this.prisma.sKUProposal.findUnique({ where: { id: +proposalId } });
    if (!proposal) throw new NotFoundException('SKU Proposal not found');

    await this.prisma.sKUProposal.delete({ where: { id: +proposalId } });
    return { message: 'SKU Proposal removed' };
  }

  // ─── SKU ALLOCATE (per store) ──────────────────────────────────────────────

  async createAllocations(dto: BulkSKUAllocateDto) {
    for (const alloc of dto.allocations) {
      const proposal = await this.prisma.sKUProposal.findUnique({ where: { id: +alloc.skuProposalId } });
      if (!proposal) throw new BadRequestException(`SKU Proposal not found: ${alloc.skuProposalId}`);

      const store = await this.prisma.store.findUnique({ where: { id: +alloc.storeId } });
      if (!store) throw new BadRequestException(`Store not found: ${alloc.storeId}`);
    }

    return this.prisma.$transaction(
      dto.allocations.map(alloc =>
        this.prisma.sKUAllocate.create({
          data: {
            sku_proposal_id: +alloc.skuProposalId,
            store_id: +alloc.storeId,
            quantity: alloc.quantity,
          },
          include: { store: true },
        }),
      ),
    );
  }

  async getStoreAllocations(skuProposalId: string) {
    return this.prisma.sKUAllocate.findMany({
      where: { sku_proposal_id: +skuProposalId },
      include: { store: true },
    });
  }

  async updateAllocation(allocationId: string, quantity: number) {
    const alloc = await this.prisma.sKUAllocate.findUnique({ where: { id: +allocationId } });
    if (!alloc) throw new NotFoundException('Allocation not found');

    return this.prisma.sKUAllocate.update({
      where: { id: +allocationId },
      data: { quantity },
      include: { store: true },
    });
  }

  async deleteAllocation(allocationId: string) {
    const alloc = await this.prisma.sKUAllocate.findUnique({ where: { id: +allocationId } });
    if (!alloc) throw new NotFoundException('Allocation not found');

    await this.prisma.sKUAllocate.delete({ where: { id: +allocationId } });
    return { message: 'Allocation deleted' };
  }

  // ─── PROPOSAL SIZING HEADER ──────────────────────────────────────────────

  async createSizingHeader(dto: CreateProposalSizingHeaderDto, userId: string) {
    const skuProposal = await this.prisma.sKUProposal.findUnique({ where: { id: +dto.skuProposalId } });
    if (!skuProposal) throw new BadRequestException(`SKU Proposal not found: ${dto.skuProposalId}`);

    const lastHeader = await this.prisma.proposalSizingHeader.findFirst({
      where: { sku_proposal_id: +dto.skuProposalId },
      orderBy: { version: 'desc' },
    });
    const version = (lastHeader?.version || 0) + 1;

    return this.prisma.proposalSizingHeader.create({
      data: {
        sku_proposal_id: +dto.skuProposalId,
        version,
        created_by: +userId,
        proposal_sizings: {
          create: dto.sizings.map(s => ({
            subcategory_size_id: +s.subcategorySizeId,
            actual_salesmix_pct: s.actualSalesmixPct || 0,
            actual_st_pct: s.actualStPct || 0,
            proposal_quantity: s.proposalQuantity,
          })),
        },
      },
      include: {
        creator: { select: { id: true, name: true } },
        proposal_sizings: { include: { subcategory_size: true } },
      },
    });
  }

  async getSizingHeadersByProposal(skuProposalId: string) {
    const skuProposal = await this.prisma.sKUProposal.findUnique({ where: { id: +skuProposalId } });
    if (!skuProposal) throw new NotFoundException('SKU Proposal not found');

    return this.prisma.proposalSizingHeader.findMany({
      where: { sku_proposal_id: +skuProposalId },
      include: {
        creator: { select: { id: true, name: true } },
        proposal_sizings: { include: { subcategory_size: true } },
      },
      orderBy: { version: 'desc' },
    });
  }

  async getSizingHeader(headerId: string) {
    const header = await this.prisma.proposalSizingHeader.findUnique({
      where: { id: +headerId },
      include: {
        creator: { select: { id: true, name: true } },
        proposal_sizings: { include: { subcategory_size: true } },
      },
    });
    if (!header) throw new NotFoundException('Proposal Sizing Header not found');
    return header;
  }

  async deleteSizingHeader(headerId: string) {
    const header = await this.prisma.proposalSizingHeader.findUnique({ where: { id: +headerId } });
    if (!header) throw new NotFoundException('Proposal Sizing Header not found');

    await this.prisma.proposalSizingHeader.delete({ where: { id: +headerId } });
    return { message: 'Proposal Sizing Header deleted' };
  }

  // ─── PROPOSAL SIZING (individual rows) ───────────────────────────────────

  async createSizings(dto: BulkProposalSizingDto) {
    for (const s of dto.sizings) {
      const header = await this.prisma.proposalSizingHeader.findUnique({ where: { id: +s.proposalSizingHeaderId } });
      if (!header) throw new BadRequestException(`Proposal Sizing Header not found: ${s.proposalSizingHeaderId}`);
    }

    return this.prisma.$transaction(
      dto.sizings.map(s =>
        this.prisma.proposalSizing.create({
          data: {
            proposal_sizing_header_id: +s.proposalSizingHeaderId,
            subcategory_size_id: +s.subcategorySizeId,
            actual_salesmix_pct: s.actualSalesmixPct || 0,
            actual_st_pct: s.actualStPct || 0,
            proposal_quantity: s.proposalQuantity,
          },
          include: { subcategory_size: true },
        }),
      ),
    );
  }

  async getSizings(proposalSizingHeaderId: string) {
    return this.prisma.proposalSizing.findMany({
      where: { proposal_sizing_header_id: +proposalSizingHeaderId },
      include: { subcategory_size: true },
    });
  }

  async updateSizing(sizingId: string, quantity: number) {
    const sizing = await this.prisma.proposalSizing.findUnique({ where: { id: +sizingId } });
    if (!sizing) throw new NotFoundException('Sizing not found');

    return this.prisma.proposalSizing.update({
      where: { id: +sizingId },
      data: { proposal_quantity: quantity },
      include: { subcategory_size: true },
    });
  }

  async deleteSizing(sizingId: string) {
    const sizing = await this.prisma.proposalSizing.findUnique({ where: { id: +sizingId } });
    if (!sizing) throw new NotFoundException('Sizing not found');

    await this.prisma.proposalSizing.delete({ where: { id: +sizingId } });
    return { message: 'Sizing deleted' };
  }

  // ─── DELETE HEADER ─────────────────────────────────────────────────────────

  async remove(id: string) {
    const header = await this.prisma.sKUProposalHeader.findUnique({ where: { id: +id } });
    if (!header) throw new NotFoundException('SKU Proposal Header not found');

    return this.prisma.sKUProposalHeader.delete({ where: { id: +id } });
  }
}
