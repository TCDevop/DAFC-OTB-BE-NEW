/*
  Warnings:

  - You are about to drop the column `brand_id` on the `budgets` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "budgets" DROP CONSTRAINT "budgets_brand_id_fkey";

-- AlterTable
ALTER TABLE "budgets" DROP COLUMN "brand_id";
