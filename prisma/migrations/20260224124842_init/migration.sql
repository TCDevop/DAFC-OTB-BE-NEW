/*
  Warnings:

  - The primary key for the `allocate_headers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `allocate_headers` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `approval_statuses` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `approval_statuses` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `planning_headers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `planning_headers` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `proposal_sizing_headers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `proposal_sizing_headers` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `sku_allocates` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `sku_allocates` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `sku_proposal_headers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `sku_proposal_headers` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the `approval_workflow_levels` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `approval_workflows` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `brands` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `budget_allocates` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `budgets` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `categories` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `collections` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `genders` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `group_brands` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `planning_categories` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `planning_collections` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `planning_genders` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `products` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `proposal_sizings` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `roles` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `season_groups` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `seasons` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sku_proposals` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `stores` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sub_categories` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `subcategory_sizes` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ticket_approval_logs` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tickets` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `users` table. If the table is not empty, all the data it contains will be lost.
  - Changed the type of `budget_id` on the `allocate_headers` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `created_by` on the `allocate_headers` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `brand_id` on the `allocate_headers` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `updated_at` to the `approval_statuses` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `created_by` on the `planning_headers` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `sku_proposal_id` on the `proposal_sizing_headers` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `created_by` on the `proposal_sizing_headers` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `updated_at` to the `sku_allocates` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `sku_proposal_id` on the `sku_allocates` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `store_id` on the `sku_allocates` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `created_by` on the `sku_proposal_headers` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "allocate_headers" DROP CONSTRAINT "allocate_headers_brand_id_fkey";

-- DropForeignKey
ALTER TABLE "allocate_headers" DROP CONSTRAINT "allocate_headers_budget_id_fkey";

-- DropForeignKey
ALTER TABLE "allocate_headers" DROP CONSTRAINT "allocate_headers_created_by_fkey";

-- DropForeignKey
ALTER TABLE "approval_workflow_levels" DROP CONSTRAINT "approval_workflow_levels_approval_workflow_id_fkey";

-- DropForeignKey
ALTER TABLE "approval_workflow_levels" DROP CONSTRAINT "approval_workflow_levels_approver_user_id_fkey";

-- DropForeignKey
ALTER TABLE "approval_workflows" DROP CONSTRAINT "approval_workflows_group_brand_id_fkey";

-- DropForeignKey
ALTER TABLE "brands" DROP CONSTRAINT "brands_group_brand_id_fkey";

-- DropForeignKey
ALTER TABLE "budget_allocates" DROP CONSTRAINT "budget_allocates_allocate_header_id_fkey";

-- DropForeignKey
ALTER TABLE "budget_allocates" DROP CONSTRAINT "budget_allocates_season_group_id_fkey";

-- DropForeignKey
ALTER TABLE "budget_allocates" DROP CONSTRAINT "budget_allocates_season_id_fkey";

-- DropForeignKey
ALTER TABLE "budget_allocates" DROP CONSTRAINT "budget_allocates_store_id_fkey";

-- DropForeignKey
ALTER TABLE "budgets" DROP CONSTRAINT "budgets_created_by_fkey";

-- DropForeignKey
ALTER TABLE "categories" DROP CONSTRAINT "categories_gender_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_categories" DROP CONSTRAINT "planning_categories_planning_header_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_categories" DROP CONSTRAINT "planning_categories_subcategory_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_collections" DROP CONSTRAINT "planning_collections_collection_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_collections" DROP CONSTRAINT "planning_collections_planning_header_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_collections" DROP CONSTRAINT "planning_collections_store_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_genders" DROP CONSTRAINT "planning_genders_gender_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_genders" DROP CONSTRAINT "planning_genders_planning_header_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_genders" DROP CONSTRAINT "planning_genders_store_id_fkey";

-- DropForeignKey
ALTER TABLE "planning_headers" DROP CONSTRAINT "planning_headers_created_by_fkey";

-- DropForeignKey
ALTER TABLE "products" DROP CONSTRAINT "products_brand_id_fkey";

-- DropForeignKey
ALTER TABLE "products" DROP CONSTRAINT "products_sub_category_id_fkey";

-- DropForeignKey
ALTER TABLE "proposal_sizing_headers" DROP CONSTRAINT "proposal_sizing_headers_created_by_fkey";

-- DropForeignKey
ALTER TABLE "proposal_sizing_headers" DROP CONSTRAINT "proposal_sizing_headers_sku_proposal_id_fkey";

-- DropForeignKey
ALTER TABLE "proposal_sizings" DROP CONSTRAINT "proposal_sizings_proposal_sizing_header_id_fkey";

-- DropForeignKey
ALTER TABLE "proposal_sizings" DROP CONSTRAINT "proposal_sizings_subcategory_size_id_fkey";

-- DropForeignKey
ALTER TABLE "seasons" DROP CONSTRAINT "seasons_season_group_id_fkey";

-- DropForeignKey
ALTER TABLE "sku_allocates" DROP CONSTRAINT "sku_allocates_sku_proposal_id_fkey";

-- DropForeignKey
ALTER TABLE "sku_allocates" DROP CONSTRAINT "sku_allocates_store_id_fkey";

-- DropForeignKey
ALTER TABLE "sku_proposal_headers" DROP CONSTRAINT "sku_proposal_headers_created_by_fkey";

-- DropForeignKey
ALTER TABLE "sku_proposals" DROP CONSTRAINT "sku_proposals_product_id_fkey";

-- DropForeignKey
ALTER TABLE "sku_proposals" DROP CONSTRAINT "sku_proposals_sku_proposal_header_id_fkey";

-- DropForeignKey
ALTER TABLE "sub_categories" DROP CONSTRAINT "sub_categories_category_id_fkey";

-- DropForeignKey
ALTER TABLE "subcategory_sizes" DROP CONSTRAINT "subcategory_sizes_sub_category_id_fkey";

-- DropForeignKey
ALTER TABLE "ticket_approval_logs" DROP CONSTRAINT "ticket_approval_logs_approval_workflow_level_id_fkey";

-- DropForeignKey
ALTER TABLE "ticket_approval_logs" DROP CONSTRAINT "ticket_approval_logs_approver_user_id_fkey";

-- DropForeignKey
ALTER TABLE "ticket_approval_logs" DROP CONSTRAINT "ticket_approval_logs_ticket_id_fkey";

-- DropForeignKey
ALTER TABLE "tickets" DROP CONSTRAINT "tickets_budget_allocate_id_fkey";

-- DropForeignKey
ALTER TABLE "tickets" DROP CONSTRAINT "tickets_created_by_fkey";

-- DropForeignKey
ALTER TABLE "users" DROP CONSTRAINT "users_role_id_fkey";

-- AlterTable
ALTER TABLE "allocate_headers" DROP CONSTRAINT "allocate_headers_pkey",
ADD COLUMN     "updated_by" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "budget_id",
ADD COLUMN     "budget_id" INTEGER NOT NULL,
DROP COLUMN "created_by",
ADD COLUMN     "created_by" INTEGER NOT NULL,
DROP COLUMN "brand_id",
ADD COLUMN     "brand_id" INTEGER NOT NULL,
ADD CONSTRAINT "allocate_headers_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "approval_statuses" DROP CONSTRAINT "approval_statuses_pkey",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "created_by" INTEGER,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "updated_by" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "approval_statuses_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "planning_headers" DROP CONSTRAINT "planning_headers_pkey",
ADD COLUMN     "updated_by" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "created_by",
ADD COLUMN     "created_by" INTEGER NOT NULL,
ADD CONSTRAINT "planning_headers_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "proposal_sizing_headers" DROP CONSTRAINT "proposal_sizing_headers_pkey",
ADD COLUMN     "updated_by" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "sku_proposal_id",
ADD COLUMN     "sku_proposal_id" INTEGER NOT NULL,
DROP COLUMN "created_by",
ADD COLUMN     "created_by" INTEGER NOT NULL,
ADD CONSTRAINT "proposal_sizing_headers_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "sku_allocates" DROP CONSTRAINT "sku_allocates_pkey",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "created_by" INTEGER,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "updated_by" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "sku_proposal_id",
ADD COLUMN     "sku_proposal_id" INTEGER NOT NULL,
DROP COLUMN "store_id",
ADD COLUMN     "store_id" INTEGER NOT NULL,
ADD CONSTRAINT "sku_allocates_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "sku_proposal_headers" DROP CONSTRAINT "sku_proposal_headers_pkey",
ADD COLUMN     "updated_by" INTEGER,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "created_by",
ADD COLUMN     "created_by" INTEGER NOT NULL,
ADD CONSTRAINT "sku_proposal_headers_pkey" PRIMARY KEY ("id");

-- DropTable
DROP TABLE "approval_workflow_levels";

-- DropTable
DROP TABLE "approval_workflows";

-- DropTable
DROP TABLE "brands";

-- DropTable
DROP TABLE "budget_allocates";

-- DropTable
DROP TABLE "budgets";

-- DropTable
DROP TABLE "categories";

-- DropTable
DROP TABLE "collections";

-- DropTable
DROP TABLE "genders";

-- DropTable
DROP TABLE "group_brands";

-- DropTable
DROP TABLE "planning_categories";

-- DropTable
DROP TABLE "planning_collections";

-- DropTable
DROP TABLE "planning_genders";

-- DropTable
DROP TABLE "products";

-- DropTable
DROP TABLE "proposal_sizings";

-- DropTable
DROP TABLE "roles";

-- DropTable
DROP TABLE "season_groups";

-- DropTable
DROP TABLE "seasons";

-- DropTable
DROP TABLE "sku_proposals";

-- DropTable
DROP TABLE "stores";

-- DropTable
DROP TABLE "sub_categories";

-- DropTable
DROP TABLE "subcategory_sizes";

-- DropTable
DROP TABLE "ticket_approval_logs";

-- DropTable
DROP TABLE "tickets";

-- DropTable
DROP TABLE "users";

-- CreateTable
CREATE TABLE "user" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "role_id" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "permissions" TEXT NOT NULL DEFAULT '[]',
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_brand" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "group_brand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "brand" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "group_brand_id" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "brand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "store" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "region" TEXT,
    "location" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "store_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "collection" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "collection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "season_group" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "season_group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "season" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "season_group_id" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "season_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gender" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "gender_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "gender_id" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sub_category" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "category_id" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "sub_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subcategory_size" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "sub_category_id" INTEGER NOT NULL,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "subcategory_size_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" SERIAL NOT NULL,
    "sku_code" TEXT NOT NULL,
    "product_name" TEXT NOT NULL,
    "sub_category_id" INTEGER NOT NULL,
    "brand_id" INTEGER,
    "family" TEXT,
    "theme" TEXT,
    "color" TEXT,
    "composition" TEXT,
    "srp" DECIMAL(18,2) NOT NULL,
    "image_url" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'DRAFT',
    "fiscal_year" INTEGER NOT NULL,
    "created_by" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "budget_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget_allocate" (
    "id" SERIAL NOT NULL,
    "allocate_header_id" INTEGER NOT NULL,
    "store_id" INTEGER NOT NULL,
    "season_group_id" INTEGER NOT NULL,
    "season_id" INTEGER NOT NULL,
    "budget_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "budget_allocate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "collection_proposal" (
    "id" SERIAL NOT NULL,
    "collection_id" INTEGER NOT NULL,
    "store_id" INTEGER NOT NULL,
    "planning_header_id" INTEGER NOT NULL,
    "actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_sales_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_moc" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposed_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_proposed_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "pct_var_vs_last" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "collection_proposal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gender_proposal" (
    "id" SERIAL NOT NULL,
    "gender_id" INTEGER NOT NULL,
    "store_id" INTEGER NOT NULL,
    "planning_header_id" INTEGER NOT NULL,
    "actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_sales_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposed_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_proposed_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "pct_var_vs_last" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "gender_proposal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category_proposal" (
    "id" SERIAL NOT NULL,
    "subcategory_id" INTEGER NOT NULL,
    "planning_header_id" INTEGER NOT NULL,
    "actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_sales_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposed_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_proposed_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "var_lastyear_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_actual_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "otb_actual_buy_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "category_proposal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sku_proposal" (
    "id" SERIAL NOT NULL,
    "sku_proposal_header_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "customer_target" TEXT NOT NULL,
    "unit_cost" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "srp" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "sku_proposal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sizing_proposal" (
    "id" SERIAL NOT NULL,
    "proposal_sizing_header_id" INTEGER NOT NULL,
    "subcategory_size_id" INTEGER NOT NULL,
    "actual_salesmix_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "actual_st_pct" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "proposal_quantity" INTEGER NOT NULL,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "sizing_proposal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ticket" (
    "id" SERIAL NOT NULL,
    "budget_allocate_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "created_by" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "ticket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "approval_workflow" (
    "id" SERIAL NOT NULL,
    "group_brand_id" INTEGER NOT NULL,
    "workflow_name" TEXT NOT NULL,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "approval_workflow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "approval_workflow_level" (
    "id" SERIAL NOT NULL,
    "approval_workflow_id" INTEGER NOT NULL,
    "level_order" INTEGER NOT NULL,
    "level_name" TEXT NOT NULL,
    "approver_user_id" INTEGER NOT NULL,
    "is_required" BOOLEAN NOT NULL,
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "approval_workflow_level_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "approval_request_log" (
    "id" SERIAL NOT NULL,
    "ticket_id" INTEGER NOT NULL,
    "approval_workflow_level_id" INTEGER NOT NULL,
    "approver_user_id" INTEGER NOT NULL,
    "is_approved" BOOLEAN NOT NULL,
    "comment" TEXT,
    "approved_at" TIMESTAMP(3),
    "created_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by" INTEGER,

    CONSTRAINT "approval_request_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "role_name_key" ON "role"("name");

-- CreateIndex
CREATE UNIQUE INDEX "group_brand_code_key" ON "group_brand"("code");

-- CreateIndex
CREATE UNIQUE INDEX "brand_code_key" ON "brand"("code");

-- CreateIndex
CREATE UNIQUE INDEX "store_code_key" ON "store"("code");

-- CreateIndex
CREATE UNIQUE INDEX "collection_name_key" ON "collection"("name");

-- CreateIndex
CREATE UNIQUE INDEX "season_group_name_key" ON "season_group"("name");

-- CreateIndex
CREATE UNIQUE INDEX "season_name_key" ON "season"("name");

-- CreateIndex
CREATE UNIQUE INDEX "gender_name_key" ON "gender"("name");

-- CreateIndex
CREATE UNIQUE INDEX "product_sku_code_key" ON "product"("sku_code");

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "brand" ADD CONSTRAINT "brand_group_brand_id_fkey" FOREIGN KEY ("group_brand_id") REFERENCES "group_brand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "season" ADD CONSTRAINT "season_season_group_id_fkey" FOREIGN KEY ("season_group_id") REFERENCES "season_group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category" ADD CONSTRAINT "category_gender_id_fkey" FOREIGN KEY ("gender_id") REFERENCES "gender"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sub_category" ADD CONSTRAINT "sub_category_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subcategory_size" ADD CONSTRAINT "subcategory_size_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "sub_category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brand"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "sub_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget" ADD CONSTRAINT "budget_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "allocate_headers" ADD CONSTRAINT "allocate_headers_budget_id_fkey" FOREIGN KEY ("budget_id") REFERENCES "budget"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "allocate_headers" ADD CONSTRAINT "allocate_headers_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "allocate_headers" ADD CONSTRAINT "allocate_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocate" ADD CONSTRAINT "budget_allocate_allocate_header_id_fkey" FOREIGN KEY ("allocate_header_id") REFERENCES "allocate_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocate" ADD CONSTRAINT "budget_allocate_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocate" ADD CONSTRAINT "budget_allocate_season_group_id_fkey" FOREIGN KEY ("season_group_id") REFERENCES "season_group"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocate" ADD CONSTRAINT "budget_allocate_season_id_fkey" FOREIGN KEY ("season_id") REFERENCES "season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "planning_headers" ADD CONSTRAINT "planning_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "collection_proposal" ADD CONSTRAINT "collection_proposal_collection_id_fkey" FOREIGN KEY ("collection_id") REFERENCES "collection"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "collection_proposal" ADD CONSTRAINT "collection_proposal_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "collection_proposal" ADD CONSTRAINT "collection_proposal_planning_header_id_fkey" FOREIGN KEY ("planning_header_id") REFERENCES "planning_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gender_proposal" ADD CONSTRAINT "gender_proposal_gender_id_fkey" FOREIGN KEY ("gender_id") REFERENCES "gender"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gender_proposal" ADD CONSTRAINT "gender_proposal_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gender_proposal" ADD CONSTRAINT "gender_proposal_planning_header_id_fkey" FOREIGN KEY ("planning_header_id") REFERENCES "planning_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category_proposal" ADD CONSTRAINT "category_proposal_subcategory_id_fkey" FOREIGN KEY ("subcategory_id") REFERENCES "sub_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category_proposal" ADD CONSTRAINT "category_proposal_planning_header_id_fkey" FOREIGN KEY ("planning_header_id") REFERENCES "planning_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_proposal_headers" ADD CONSTRAINT "sku_proposal_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_proposal" ADD CONSTRAINT "sku_proposal_sku_proposal_header_id_fkey" FOREIGN KEY ("sku_proposal_header_id") REFERENCES "sku_proposal_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_proposal" ADD CONSTRAINT "sku_proposal_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_allocates" ADD CONSTRAINT "sku_allocates_sku_proposal_id_fkey" FOREIGN KEY ("sku_proposal_id") REFERENCES "sku_proposal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sku_allocates" ADD CONSTRAINT "sku_allocates_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proposal_sizing_headers" ADD CONSTRAINT "proposal_sizing_headers_sku_proposal_id_fkey" FOREIGN KEY ("sku_proposal_id") REFERENCES "sku_proposal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proposal_sizing_headers" ADD CONSTRAINT "proposal_sizing_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sizing_proposal" ADD CONSTRAINT "sizing_proposal_proposal_sizing_header_id_fkey" FOREIGN KEY ("proposal_sizing_header_id") REFERENCES "proposal_sizing_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sizing_proposal" ADD CONSTRAINT "sizing_proposal_subcategory_size_id_fkey" FOREIGN KEY ("subcategory_size_id") REFERENCES "subcategory_size"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket" ADD CONSTRAINT "ticket_budget_allocate_id_fkey" FOREIGN KEY ("budget_allocate_id") REFERENCES "budget_allocate"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket" ADD CONSTRAINT "ticket_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_workflow" ADD CONSTRAINT "approval_workflow_group_brand_id_fkey" FOREIGN KEY ("group_brand_id") REFERENCES "group_brand"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_workflow_level" ADD CONSTRAINT "approval_workflow_level_approval_workflow_id_fkey" FOREIGN KEY ("approval_workflow_id") REFERENCES "approval_workflow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_workflow_level" ADD CONSTRAINT "approval_workflow_level_approver_user_id_fkey" FOREIGN KEY ("approver_user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_request_log" ADD CONSTRAINT "approval_request_log_ticket_id_fkey" FOREIGN KEY ("ticket_id") REFERENCES "ticket"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_request_log" ADD CONSTRAINT "approval_request_log_approval_workflow_level_id_fkey" FOREIGN KEY ("approval_workflow_level_id") REFERENCES "approval_workflow_level"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_request_log" ADD CONSTRAINT "approval_request_log_approver_user_id_fkey" FOREIGN KEY ("approver_user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
