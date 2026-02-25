/*
  Warnings:

  - You are about to drop the column `brand_id` on the `budgets` table. All the data in the column will be lost.
  - You are about to drop the column `sku_proposal_id` on the `proposal_sizings` table. All the data in the column will be lost.
  - Added the required column `brand_id` to the `allocate_headers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `proposal_sizing_header_id` to the `proposal_sizings` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "budgets" DROP CONSTRAINT "budgets_brand_id_fkey";

-- DropForeignKey
ALTER TABLE "proposal_sizings" DROP CONSTRAINT "proposal_sizings_sku_proposal_id_fkey";

-- AlterTable
ALTER TABLE "allocate_headers" ADD COLUMN     "brand_id" TEXT NOT NULL,
ADD COLUMN     "is_final_version" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "budgets" DROP COLUMN "brand_id";

-- AlterTable
ALTER TABLE "planning_headers" ADD COLUMN     "is_final_version" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "proposal_sizings" DROP COLUMN "sku_proposal_id",
ADD COLUMN     "proposal_sizing_header_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "sku_proposal_headers" ADD COLUMN     "is_final_version" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "proposal_sizing_headers" (
    "id" TEXT NOT NULL,
    "sku_proposal_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "is_final_version" BOOLEAN NOT NULL DEFAULT false,
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "proposal_sizing_headers_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "allocate_headers" ADD CONSTRAINT "allocate_headers_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "brands"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proposal_sizing_headers" ADD CONSTRAINT "proposal_sizing_headers_sku_proposal_id_fkey" FOREIGN KEY ("sku_proposal_id") REFERENCES "sku_proposals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proposal_sizing_headers" ADD CONSTRAINT "proposal_sizing_headers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proposal_sizings" ADD CONSTRAINT "proposal_sizings_proposal_sizing_header_id_fkey" FOREIGN KEY ("proposal_sizing_header_id") REFERENCES "proposal_sizing_headers"("id") ON DELETE CASCADE ON UPDATE CASCADE;
