import { Controller, Get, Post, Put, Delete, Param, Query, Body, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery, ApiBody } from '@nestjs/swagger';
import { PlanningService } from './planning.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PermissionsGuard, RequirePermissions } from '../../common/guards/permissions.guard';
import { CreatePlanningDto, UpdatePlanningDto } from './dto/planning.dto';

@ApiTags('planning')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('planning')
export class PlanningController {
  constructor(private planningService: PlanningService) {}

  // ─── LIST ──────────────────────────────────────────────────────────────────

  @Get()
  @RequirePermissions('planning:read')
  @ApiOperation({ summary: 'List planning headers with filters and pagination' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'pageSize', required: false, type: Number })
  @ApiQuery({ name: 'status', required: false, description: 'Filter by status (DRAFT, SUBMITTED, APPROVED, REJECTED)' })
  @ApiQuery({ name: 'budgetId', required: false, description: 'Filter by budget ID (reserved for future FK)' })
  async findAll(
    @Query('page') page?: number,
    @Query('pageSize') pageSize?: number,
    @Query('status') status?: string,
    @Query('budgetId') budgetId?: string,
  ) {
    const result = await this.planningService.findAll({ page, pageSize, status, budgetId });
    return { success: true, ...result };
  }

  // ─── FILTER OPTIONS FOR PLANNING DETAIL (Category tab) ───────────────────

  @Get('filter-options/categories')
  @RequirePermissions('planning:read')
  @ApiOperation({ summary: 'Get Gender → Category → SubCategory hierarchy for Planning Detail filter dropdowns' })
  @ApiQuery({ name: 'genderId', required: false, description: 'Filter by gender ID (cascading)' })
  @ApiQuery({ name: 'categoryId', required: false, description: 'Filter by category ID (cascading to sub-categories)' })
  async getCategoryFilterOptions(
    @Query('genderId') genderId?: string,
    @Query('categoryId') categoryId?: string,
  ) {
    return { success: true, data: await this.planningService.getCategoryFilterOptions(genderId, categoryId) };
  }

  // ─── GET ONE ───────────────────────────────────────────────────────────────

  @Get(':id')
  @RequirePermissions('planning:read')
  @ApiOperation({ summary: 'Get planning header with all details (collections, genders, categories)' })
  async findOne(@Param('id') id: string) {
    return { success: true, data: await this.planningService.findOne(id) };
  }

  // ─── CREATE ────────────────────────────────────────────────────────────────

  @Post()
  @RequirePermissions('planning:write')
  @ApiOperation({ summary: 'Create new planning header with details' })
  @ApiBody({ type: CreatePlanningDto })
  async create(@Body() dto: CreatePlanningDto, @Request() req: any) {
    return { success: true, data: await this.planningService.create(dto, req.user.sub) };
  }

  // ─── COPY FROM EXISTING ────────────────────────────────────────────────────

  @Post(':id/copy')
  @RequirePermissions('planning:write')
  @ApiOperation({ summary: 'Create new version by copying an existing one' })
  async createFromVersion(@Param('id') id: string, @Request() req: any) {
    return { success: true, data: await this.planningService.createFromVersion(id, req.user.sub) };
  }

  // ─── UPDATE ────────────────────────────────────────────────────────────────

  @Put(':id')
  @RequirePermissions('planning:write')
  @ApiOperation({ summary: 'Update planning header details' })
  @ApiBody({ type: UpdatePlanningDto })
  async update(@Param('id') id: string, @Body() dto: UpdatePlanningDto, @Request() req: any) {
    return { success: true, data: await this.planningService.update(id, dto, req.user.sub) };
  }

  // ─── DELETE ────────────────────────────────────────────────────────────────

  @Delete(':id')
  @RequirePermissions('planning:write')
  @ApiOperation({ summary: 'Delete planning header' })
  async remove(@Param('id') id: string) {
    await this.planningService.remove(id);
    return { success: true, message: 'Planning header deleted' };
  }
}
