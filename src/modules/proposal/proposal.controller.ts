import { Controller, Get, Post, Put, Patch, Delete, Param, Query, Body, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery, ApiBody } from '@nestjs/swagger';
import { ProposalService } from './proposal.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PermissionsGuard, RequirePermissions } from '../../common/guards/permissions.guard';
import {
  CreateSKUProposalHeaderDto,
  AddProductDto,
  BulkAddProductsDto,
  UpdateSKUProposalDto,
  BulkSKUAllocateDto,
  BulkProposalSizingDto,
  CreateProposalSizingHeaderDto,
} from './dto/proposal.dto';

@ApiTags('proposals')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('proposals')
export class ProposalController {
  constructor(private proposalService: ProposalService) {}

  // ─── LIST HEADERS ──────────────────────────────────────────────────────────

  @Get()
  @RequirePermissions('proposal:read')
  @ApiOperation({ summary: 'List SKU proposal headers with pagination' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'pageSize', required: false, type: Number })
  @ApiQuery({ name: 'status', required: false, description: 'Filter by status (DRAFT, SUBMITTED, APPROVED, REJECTED)' })
  async findAll(
    @Query('page') page?: number,
    @Query('pageSize') pageSize?: number,
    @Query('status') status?: string,
  ) {
    const result = await this.proposalService.findAll({ page, pageSize, status });
    return { success: true, ...result };
  }

  // ─── GET ONE ───────────────────────────────────────────────────────────────

  @Get(':id')
  @RequirePermissions('proposal:read')
  @ApiOperation({ summary: 'Get SKU proposal header with all proposals, allocations, and sizings' })
  async findOne(@Param('id') id: string) {
    return { success: true, data: await this.proposalService.findOne(id) };
  }

  // ─── CREATE ────────────────────────────────────────────────────────────────

  @Post()
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Create new SKU proposal header with proposals' })
  @ApiBody({ type: CreateSKUProposalHeaderDto })
  async create(@Body() dto: CreateSKUProposalHeaderDto, @Request() req: any) {
    return { success: true, data: await this.proposalService.create(dto, req.user.sub) };
  }

  // ─── ADD PRODUCT ───────────────────────────────────────────────────────────

  @Post(':id/products')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Add a product to the SKU proposal header' })
  @ApiBody({ type: AddProductDto })
  async addProduct(@Param('id') id: string, @Body() dto: AddProductDto, @Request() req: any) {
    return { success: true, data: await this.proposalService.addProduct(id, dto, req.user.sub) };
  }

  // ─── BULK ADD PRODUCTS ─────────────────────────────────────────────────────

  @Post(':id/products/bulk')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Bulk add products to the SKU proposal header' })
  @ApiBody({ type: BulkAddProductsDto })
  async bulkAddProducts(@Param('id') id: string, @Body() dto: BulkAddProductsDto, @Request() req: any) {
    return { success: true, data: await this.proposalService.bulkAddProducts(id, dto, req.user.sub) };
  }

  // ─── UPDATE SKU PROPOSAL ───────────────────────────────────────────────────

  @Patch('items/:proposalId')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Update a SKU proposal item' })
  @ApiBody({ type: UpdateSKUProposalDto })
  async updateProposal(@Param('proposalId') proposalId: string, @Body() dto: UpdateSKUProposalDto) {
    return { success: true, data: await this.proposalService.updateProposal(proposalId, dto) };
  }

  // ─── REMOVE SKU PROPOSAL ──────────────────────────────────────────────────

  @Delete('items/:proposalId')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Remove a SKU proposal item' })
  async removeProposal(@Param('proposalId') proposalId: string) {
    return { success: true, ...(await this.proposalService.removeProposal(proposalId)) };
  }

  // ─── SKU ALLOCATIONS (per store) ───────────────────────────────────────────

  @Post('allocations')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Create store allocations for SKU proposals' })
  @ApiBody({ type: BulkSKUAllocateDto })
  async createAllocations(@Body() dto: BulkSKUAllocateDto) {
    return { success: true, data: await this.proposalService.createAllocations(dto) };
  }

  @Get('items/:skuProposalId/allocations')
  @RequirePermissions('proposal:read')
  @ApiOperation({ summary: 'Get store allocations for a SKU proposal' })
  async getStoreAllocations(@Param('skuProposalId') skuProposalId: string) {
    return { success: true, data: await this.proposalService.getStoreAllocations(skuProposalId) };
  }

  @Patch('allocations/:allocationId')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Update allocation quantity' })
  async updateAllocation(@Param('allocationId') allocationId: string, @Body('quantity') quantity: number) {
    return { success: true, data: await this.proposalService.updateAllocation(allocationId, quantity) };
  }

  @Delete('allocations/:allocationId')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Delete an allocation' })
  async deleteAllocation(@Param('allocationId') allocationId: string) {
    return { success: true, ...(await this.proposalService.deleteAllocation(allocationId)) };
  }

  // ─── PROPOSAL SIZING HEADER ───────────────────────────────────────────────

  @Post('sizing-headers')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Tạo Proposal Sizing Header (với các sizing theo size)' })
  @ApiBody({ type: CreateProposalSizingHeaderDto })
  async createSizingHeader(@Body() dto: CreateProposalSizingHeaderDto, @Request() req: any) {
    return { success: true, data: await this.proposalService.createSizingHeader(dto, req.user.sub) };
  }

  @Get('items/:skuProposalId/sizing-headers')
  @RequirePermissions('proposal:read')
  @ApiOperation({ summary: 'Lấy danh sách Proposal Sizing Headers của một SKU Proposal' })
  async getSizingHeadersByProposal(@Param('skuProposalId') skuProposalId: string) {
    return { success: true, data: await this.proposalService.getSizingHeadersByProposal(skuProposalId) };
  }

  @Get('sizing-headers/:headerId')
  @RequirePermissions('proposal:read')
  @ApiOperation({ summary: 'Lấy chi tiết Proposal Sizing Header (kèm sizings)' })
  async getSizingHeader(@Param('headerId') headerId: string) {
    return { success: true, data: await this.proposalService.getSizingHeader(headerId) };
  }

  @Delete('sizing-headers/:headerId')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Xoá Proposal Sizing Header và tất cả sizings liên quan' })
  async deleteSizingHeader(@Param('headerId') headerId: string) {
    return { success: true, ...(await this.proposalService.deleteSizingHeader(headerId)) };
  }

  // ─── PROPOSAL SIZING (individual rows) ────────────────────────────────────

  @Post('sizings')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Thêm sizings vào một Proposal Sizing Header' })
  @ApiBody({ type: BulkProposalSizingDto })
  async createSizings(@Body() dto: BulkProposalSizingDto) {
    return { success: true, data: await this.proposalService.createSizings(dto) };
  }

  @Get('sizing-headers/:headerId/sizings')
  @RequirePermissions('proposal:read')
  @ApiOperation({ summary: 'Lấy danh sách sizings của một Proposal Sizing Header' })
  async getSizings(@Param('headerId') headerId: string) {
    return { success: true, data: await this.proposalService.getSizings(headerId) };
  }

  @Patch('sizings/:sizingId')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Cập nhật số lượng sizing' })
  async updateSizing(@Param('sizingId') sizingId: string, @Body('proposalQuantity') quantity: number) {
    return { success: true, data: await this.proposalService.updateSizing(sizingId, quantity) };
  }

  @Delete('sizings/:sizingId')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Xoá một sizing' })
  async deleteSizing(@Param('sizingId') sizingId: string) {
    return { success: true, ...(await this.proposalService.deleteSizing(sizingId)) };
  }

  // ─── DELETE HEADER ─────────────────────────────────────────────────────────

  @Delete(':id')
  @RequirePermissions('proposal:write')
  @ApiOperation({ summary: 'Delete SKU proposal header and all related data' })
  async remove(@Param('id') id: string) {
    await this.proposalService.remove(id);
    return { success: true, message: 'SKU Proposal Header deleted' };
  }
}
