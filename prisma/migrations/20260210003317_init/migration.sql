-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "role_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "permissions" JSONB NOT NULL DEFAULT '[]',

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_brands" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "group_brands_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "brands" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "group_brand_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "brands_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stores" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "region" TEXT,
    "location" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "collections" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "collections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "season_groups" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "season_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "seasons" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "season_group_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "seasons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "genders" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "genders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "gender_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sub_categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "sub_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subcategory_sizes" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "sub_category_id" TEXT NOT NULL,

    CONSTRAINT "subcategory_sizes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "id" TEXT NOT NULL,
    "sku_code" TEXT NOT NULL,
    "product_name" TEXT NOT NULL,
    "sub_category_id" TEXT NOT NULL,
    "theme" TEXT,
    "color" TEXT,
    "composition" TEXT,
    "srp" DECIMAL(18,2) NOT NULL,
    "brand_id" TEXT,
    "image_url" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budgets" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "brand_id" TEXT NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'DRAFT',
    "fiscal_year" INTEGER NOT NULL,
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "budgets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "allocate_headers" (
    "id" TEXT NOT NULL,
    "budget_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "allocate_headers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget_allocates" (
    "id" TEXT NOT NULL,
    "allocate_header_id" TEXT NOT NULL,
    "store_id" TEXT NOT NULL,
    "season_group_id" TEXT NOT NULL,
    "season_id" TEXT NOT NULL,
    "budget_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT "budget_allocates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "planning_headers" (
    "id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "planning_headers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "planning_collections" (
    "id" TEXT NOT NULL,
    "collection_id" TEXT NOT NULL,
    "store_id" TEXT NOT NULL,
    "planning_header_id" TEXT NOT NULL,
    "actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_sales_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_moc" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposed_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_proposed_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "pct_var_vs_last" DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT "planning_collections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "planning_genders" (
    "id" TEXT NOT NULL,
    "gender_id" TEXT NOT NULL,
    "store_id" TEXT NOT NULL,
    "planning_header_id" TEXT NOT NULL,
    "actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_sales_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposed_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_proposed_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "pct_var_vs_last" DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT "planning_genders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "planning_categories" (
    "id" TEXT NOT NULL,
    "subcategory_id" TEXT NOT NULL,
    "planning_header_id" TEXT NOT NULL,
    "actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_sales_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposed_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_proposed_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "var_lastyear_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_actual_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT "planning_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sku_proposal_headers" (
    "id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sku_proposal_headers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sku_proposals" (
    "id" TEXT NOT NULL,
    "sku_proposal_header_id" TEXT NOT NULL,
    "product_id" TEXT NOT NULL,
    "customer_target" TEXT NOT NULL,
    "unit_cost" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "srp" DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT "sku_proposals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sku_allocates" (
    "id" TEXT NOT NULL,
    "sku_proposal_id" TEXT NOT NULL,
    "store_id" TEXT NOT NULL,
    "quantity" DECIMAL(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT "sku_allocates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "proposal_sizings" (
    "id" TEXT NOT NULL,
    "sku_proposal_id" TEXT NOT NULL,
    "subcategory_size_id" TEXT NOT NULL,
    "actual_salesmix_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposal_quantity" INTEGER NOT NULL,

    CONSTRAINT "proposal_sizings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "approval_statuses" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "approval_statuses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tickets" (
    "id" TEXT NOT NULL,
    "budget_allocate_id" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "approval_workflows" (
    "id" TEXT NOT NULL,
    "group_brand_id" TEXT NOT NULL,
    "workflow_name" TEXT NOT NULL,

    CONSTRAINT "approval_workflows_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "approval_workflow_levels" (
    "id" TEXT NOT NULL,
    "approval_workflow_id" TEXT NOT NULL,
    "level_order" INTEGER NOT NULL,
    "level_name" TEXT NOT NULL,
    "approver_user_id" TEXT NOT NULL,
    "is_required" BOOLEAN NOT NULL,

    CONSTRAINT "approval_workflow_levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ticket_approval_logs" (
    "id" TEXT NOT NULL,
    "ticket_id" TEXT NOT NULL,
    "approval_workflow_level_id" TEXT NOT NULL,
    "approver_user_id" TEXT NOT NULL,
    "is_approved" BOOLEAN NOT NULL,
    "comment" TEXT,
    "approved_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ticket_approval_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "group_brands_code_key" ON "group_brands"("code");

-- CreateIndex
CREATE UNIQUE INDEX "brands_code_key" ON "brands"("code");

-- CreateIndex
CREATE UNIQUE INDEX "stores_code_key" ON "stores"("code");

-- CreateIndex
CREATE UNIQUE INDEX "collections_name_key" ON "collections"("name");

-- CreateIndex
CREATE UNIQUE INDEX "season_groups_name_key" ON "season_groups"("name");

-- CreateIndex
CREATE UNIQUE INDEX "seasons_name_key" ON "seasons"("name");

-- CreateIndex
CREATE UNIQUE INDEX "genders_name_key" ON "genders"("name");

-- CreateIndex
CREATE UNIQUE INDEX "products_sku_code_key" ON "products"("sku_code");

-- CreateIndex
CREATE UNIQUE INDEX "approval_statuses_name_key" ON "approval_statuses"("name");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "brands" ADD CONSTRAINT "brands_group_brand_id_fkey" FOREIGN KEY ("group_brand_id") REFERENCES "group_brands"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "seasons" ADD CONSTRAINT "seasons_season_group_id_fkey" FOREIGN KEY ("season_group_id") REFERENCES "season_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_gender_id_fkey" FOREIGN KEY ("gender_id") REFERENCES "genders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sub_categories" ADD CONSTRAINT "sub_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subcategory_sizes" ADD CONSTRAINT "subcategory_sizes_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "sub_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brands"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "sub_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budgets" ADD CONSTRAINT "budgets_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brands"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budgets" ADD CONSTRAINT "budgets_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "allocate_headers" ADD CONSTRAINT "allocate_headers_budget_id_fkey" FOREIGN KEY ("budget_id") REFERENCES "budgets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "allocate_headers" ADD CONSTRAINT "allocate_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocates" ADD CONSTRAINT "budget_allocates_allocate_header_id_fkey" FOREIGN KEY ("allocate_header_id") REFERENCES "allocate_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocates" ADD CONSTRAINT "budget_allocates_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "stores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocates" ADD CONSTRAINT "budget_allocates_season_group_id_fkey" FOREIGN KEY ("season_group_id") REFERENCES "season_groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocates" ADD CONSTRAINT "budget_allocates_season_id_fkey" FOREIGN KEY ("season_id") REFERENCES "seasons"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_headers" ADD CONSTRAINT "planning_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_collections" ADD CONSTRAINT "planning_collections_collection_id_fkey" FOREIGN KEY ("collection_id") REFERENCES "collections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_collections" ADD CONSTRAINT "planning_collections_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "stores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_collections" ADD CONSTRAINT "planning_collections_planning_header_id_fkey" FOREIGN KEY ("planning_header_id") REFERENCES "planning_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_genders" ADD CONSTRAINT "planning_genders_gender_id_fkey" FOREIGN KEY ("gender_id") REFERENCES "genders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_genders" ADD CONSTRAINT "planning_genders_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "stores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_genders" ADD CONSTRAINT "planning_genders_planning_header_id_fkey" FOREIGN KEY ("planning_header_id") REFERENCES "planning_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_categories" ADD CONSTRAINT "planning_categories_subcategory_id_fkey" FOREIGN KEY ("subcategory_id") REFERENCES "sub_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_categories" ADD CONSTRAINT "planning_categories_planning_header_id_fkey" FOREIGN KEY ("planning_header_id") REFERENCES "planning_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_proposal_headers" ADD CONSTRAINT "sku_proposal_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_proposals" ADD CONSTRAINT "sku_proposals_sku_proposal_header_id_fkey" FOREIGN KEY ("sku_proposal_header_id") REFERENCES "sku_proposal_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_proposals" ADD CONSTRAINT "sku_proposals_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_allocates" ADD CONSTRAINT "sku_allocates_sku_proposal_id_fkey" FOREIGN KEY ("sku_proposal_id") REFERENCES "sku_proposals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_allocates" ADD CONSTRAINT "sku_allocates_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "stores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proposal_sizings" ADD CONSTRAINT "proposal_sizings_sku_proposal_id_fkey" FOREIGN KEY ("sku_proposal_id") REFERENCES "sku_proposals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proposal_sizings" ADD CONSTRAINT "proposal_sizings_subcategory_size_id_fkey" FOREIGN KEY ("subcategory_size_id") REFERENCES "subcategory_sizes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_budget_allocate_id_fkey" FOREIGN KEY ("budget_allocate_id") REFERENCES "budget_allocates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_workflows" ADD CONSTRAINT "approval_workflows_group_brand_id_fkey" FOREIGN KEY ("group_brand_id") REFERENCES "group_brands"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_workflow_levels" ADD CONSTRAINT "approval_workflow_levels_approval_workflow_id_fkey" FOREIGN KEY ("approval_workflow_id") REFERENCES "approval_workflows"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_workflow_levels" ADD CONSTRAINT "approval_workflow_levels_approver_user_id_fkey" FOREIGN KEY ("approver_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_approval_logs" ADD CONSTRAINT "ticket_approval_logs_ticket_id_fkey" FOREIGN KEY ("ticket_id") REFERENCES "tickets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_approval_logs" ADD CONSTRAINT "ticket_approval_logs_approval_workflow_level_id_fkey" FOREIGN KEY ("approval_workflow_level_id") REFERENCES "approval_workflow_levels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_approval_logs" ADD CONSTRAINT "ticket_approval_logs_approver_user_id_fkey" FOREIGN KEY ("approver_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
