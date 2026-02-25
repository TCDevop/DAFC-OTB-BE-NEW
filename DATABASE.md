# DATABASE SCHEMA — DAFC OTB Planning System

> **Cập nhật:** 2026-02-23
> **Nguồn:** `prisma/schema.prisma`
> **Database:** PostgreSQL
> **ORM:** Prisma

---

## Danh sách bảng

| STT | Tên bảng (@@map) | Prisma Model | Nhóm |
|---|---|---|---|
| 1 | `user` | `User` | Auth & Authorization |
| 2 | `role` | `Role` | Auth & Authorization |
| 3 | `group_brand` | `GroupBrand` | Brand Hierarchy |
| 4 | `brand` | `Brand` | Brand Hierarchy |
| 5 | `store` | `Store` | Store & Location |
| 6 | `collection` | `Collection` | Product Taxonomy |
| 7 | `season_group` | `SeasonGroup` | Product Taxonomy |
| 8 | `season` | `Season` | Product Taxonomy |
| 9 | `gender` | `Gender` | Product Taxonomy |
| 10 | `category` | `Category` | Product Taxonomy |
| 11 | `sub_category` | `SubCategory` | Product Taxonomy |
| 12 | `subcategory_size` | `SubcategorySize` | Product Taxonomy |
| 13 | `product` | `Product` | Product Catalog |
| 14 | `budget` | `Budget` | Budget Management |
| 15 | `allocate_headers` | `AllocateHeader` | Budget Management |
| 16 | `budget_allocate` | `BudgetAllocate` | Budget Management |
| 17 | `planning_headers` | `PlanningHeader` | Planning & Forecasting |
| 18 | `collection_proposal` | `PlanningCollection` | Planning & Forecasting |
| 19 | `gender_proposal` | `PlanningGender` | Planning & Forecasting |
| 20 | `category_proposal` | `PlanningCategory` | Planning & Forecasting |
| 21 | `sku_proposal_headers` | `SKUProposalHeader` | SKU Proposal |
| 22 | `sku_proposal` | `SKUProposal` | SKU Proposal |
| 23 | `sku_allocates` | `SKUAllocate` | SKU Proposal |
| 24 | `proposal_sizing_headers` | `ProposalSizingHeader` | SKU Proposal |
| 25 | `sizing_proposal` | `ProposalSizing` | SKU Proposal |
| 26 | `approval_statuses` | `ApprovalStatus` | Approval & Tickets |
| 27 | `ticket` | `Ticket` | Approval & Tickets |
| 28 | `approval_workflow` | `ApprovalWorkflow` | Approval & Tickets |
| 29 | `approval_workflow_level` | `ApprovalWorkflowLevel` | Approval & Tickets |
| 30 | `approval_request_log` | `TicketApprovalLog` | Approval & Tickets |

---

## Quy ước chung

| Ký hiệu | Ý nghĩa |
|---|---|
| `PK` | Primary Key |
| `FK` | Foreign Key |
| `NN` | NOT NULL |
| `?` | Nullable |
| `AI` | Auto Increment |
| `UQ` | Unique |

**Kiểu dữ liệu:**
- `Int` → `bigint` (PostgreSQL), auto increment
- `String` → `varchar/text`
- `Boolean` → `boolean`
- `DateTime` → `timestamp`
- `Decimal(18,2)` → `numeric(18,2)`
- `Json` / `String` → `text`

---

## 1. AUTH & AUTHORIZATION

### 1.1 `user`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID người dùng |
| `email` | `String` | UQ, NN | — | Email đăng nhập |
| `name` | `String` | NN | — | Họ tên |
| `password_hash` | `String` | NN | — | Mật khẩu đã hash |
| `role_id` | `Int` | FK → role.id, NN | — | ID vai trò |
| `is_active` | `Boolean` | NN | `true` | Trạng thái hoạt động |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |

**Relations:**
- `role` ← `Role` (many-to-one)
- `created_budgets` → `Budget[]`
- `created_allocate_headers` → `AllocateHeader[]`
- `created_planning_headers` → `PlanningHeader[]`
- `created_sku_proposal_headers` → `SKUProposalHeader[]`
- `created_proposal_sizing_headers` → `ProposalSizingHeader[]`
- `created_tickets` → `Ticket[]`
- `approval_workflow_levels` → `ApprovalWorkflowLevel[]`
- `ticket_approval_logs` → `TicketApprovalLog[]`

---

### 1.2 `role`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID vai trò |
| `name` | `String` | UQ, NN | — | Tên vai trò (buyer, merchandiser, merch_manager, finance_director, admin) |
| `description` | `String` | ? | — | Mô tả |
| `permissions` | `String` | NN | `[]` | Danh sách quyền |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `users` → `User[]`

---

## 2. BRAND HIERARCHY

### 2.1 `group_brand`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID nhóm brand |
| `code` | `String` | UQ, NN | — | Mã nhóm (LUXURY, PREMIUM) |
| `name` | `String` | NN | — | Tên nhóm |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `brands` → `Brand[]`
- `approval_workflows` → `ApprovalWorkflow[]`

---

### 2.2 `brand`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID brand |
| `code` | `String` | UQ, NN | — | Mã brand (FER, BUR, GUC, PRA) |
| `name` | `String` | NN | — | Tên brand |
| `group_brand_id` | `Int` | FK → group_brand.id, NN | — | ID nhóm brand |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `group_brand` ← `GroupBrand` (many-to-one, onDelete: Restrict)
- `products` → `Product[]`
- `allocate_headers` → `AllocateHeader[]`

---

## 3. STORE & LOCATION

### 3.1 `store`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID cửa hàng |
| `code` | `String` | UQ, NN | — | Mã cửa hàng (REX, TTP) |
| `name` | `String` | NN | — | Tên cửa hàng |
| `region` | `String` | ? | — | Khu vực |
| `location` | `String` | ? | — | Địa điểm |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `budget_allocates` → `BudgetAllocate[]`
- `planning_collections` → `PlanningCollection[]`
- `planning_genders` → `PlanningGender[]`
- `sku_allocates` → `SKUAllocate[]`

---

## 4. PRODUCT TAXONOMY & ATTRIBUTES

### 4.1 `collection`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID collection |
| `name` | `String` | UQ, NN | — | Tên (SS Collection, FW Collection) |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `planning_collections` → `PlanningCollection[]`

---

### 4.2 `season_group`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID nhóm mùa |
| `name` | `String` | UQ, NN | — | Tên nhóm (SS, FW) |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `seasons` → `Season[]`
- `budget_allocates` → `BudgetAllocate[]`

---

### 4.3 `season`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID mùa |
| `name` | `String` | UQ, NN | — | Tên mùa (SS24, FW24, SS25) |
| `season_group_id` | `Int` | FK → season_group.id, NN | — | ID nhóm mùa |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `season_group` ← `SeasonGroup` (many-to-one, onDelete: Cascade)
- `budget_allocates` → `BudgetAllocate[]`

---

### 4.4 `gender`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID giới tính |
| `name` | `String` | UQ, NN | — | Tên (Male, Female, Unisex) |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `categories` → `Category[]`
- `planning_genders` → `PlanningGender[]`

---

### 4.5 `category`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID danh mục |
| `name` | `String` | NN | — | Tên (RTW, HARD ACCESSORIES, SOFT ACCESSORIES) |
| `gender_id` | `Int` | FK → gender.id, NN | — | ID giới tính |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `gender` ← `Gender` (many-to-one, onDelete: Cascade)
- `sub_categories` → `SubCategory[]`

---

### 4.6 `sub_category`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID danh mục con |
| `name` | `String` | NN | — | Tên (W Outerwear, M Bags, M Shoes) |
| `category_id` | `Int` | FK → category.id, NN | — | ID danh mục |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `category` ← `Category` (many-to-one, onDelete: Cascade)
- `products` → `Product[]`
- `subcategory_sizes` → `SubcategorySize[]`
- `planning_categories` → `PlanningCategory[]`

---

### 4.7 `subcategory_size`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID size |
| `name` | `String` | NN | — | Tên size (XS, S, M, L, XL, 36, 38, 40) |
| `sub_category_id` | `Int` | FK → sub_category.id, NN | — | ID danh mục con |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `sub_category` ← `SubCategory` (many-to-one, onDelete: Cascade)
- `proposal_sizings` → `ProposalSizing[]`

---

## 5. PRODUCT CATALOG

### 5.1 `product`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID sản phẩm |
| `sku_code` | `String` | UQ, NN | — | Mã SKU (FER-RTW-001) |
| `product_name` | `String` | NN | — | Tên sản phẩm |
| `sub_category_id` | `Int` | FK → sub_category.id, NN | — | ID danh mục con |
| `brand_id` | `Int` | FK → brand.id, ? | — | ID brand |
| `family` | `String` | ? | — | Family sản phẩm |
| `theme` | `String` | ? | — | Chủ đề (AUGUST, SEPTEMBER, HOLIDAY) |
| `color` | `String` | ? | — | Màu sắc |
| `composition` | `String` | ? | — | Chất liệu (100% Cotton) |
| `srp` | `Decimal(18,2)` | NN | — | Giá bán lẻ đề xuất (VND) |
| `image_url` | `String` | ? | — | URL hình ảnh |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `brand` ← `Brand` (many-to-one, onDelete: SetNull)
- `sub_category` ← `SubCategory` (many-to-one, onDelete: Restrict)
- `sku_proposals` → `SKUProposal[]`

---

## 6. BUDGET MANAGEMENT

### 6.1 `budget`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID ngân sách |
| `name` | `String` | NN | — | Tên ngân sách |
| `amount` | `Decimal(18,2)` | NN | — | Tổng ngân sách |
| `description` | `String` | ? | — | Mô tả |
| `status` | `String` | NN | `DRAFT` | Trạng thái (DRAFT, SUBMITTED, APPROVED, REJECTED) |
| `fiscal_year` | `Int` | NN | — | Năm tài chính |
| `created_by` | `Int` | FK → user.id, NN | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `creator` ← `User` (many-to-one, onDelete: Restrict)
- `allocate_headers` → `AllocateHeader[]`

---

### 6.2 `allocate_headers`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID header phân bổ |
| `budget_id` | `Int` | FK → budget.id, NN | — | ID ngân sách |
| `brand_id` | `Int` | FK → brand.id, NN | — | ID brand |
| `version` | `Int` | NN | — | Phiên bản |
| `is_final_version` | `Boolean` | NN | `false` | Phiên bản cuối |
| `created_by` | `Int` | FK → user.id, NN | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `budget` ← `Budget` (many-to-one, onDelete: Cascade)
- `brand` ← `Brand` (many-to-one, onDelete: Restrict)
- `creator` ← `User` (many-to-one, onDelete: Restrict)
- `budget_allocates` → `BudgetAllocate[]`

---

### 6.3 `budget_allocate`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID phân bổ ngân sách |
| `allocate_header_id` | `Int` | FK → allocate_headers.id, NN | — | ID header phân bổ |
| `store_id` | `Int` | FK → store.id, NN | — | ID cửa hàng |
| `season_group_id` | `Int` | FK → season_group.id, NN | — | ID nhóm mùa |
| `season_id` | `Int` | FK → season.id, NN | — | ID mùa |
| `budget_amount` | `Decimal(18,2)` | NN | `0` | Số tiền ngân sách |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `allocate_header` ← `AllocateHeader` (many-to-one, onDelete: Cascade)
- `store` ← `Store` (many-to-one, onDelete: Restrict)
- `season_group` ← `SeasonGroup` (many-to-one, onDelete: Restrict)
- `season` ← `Season` (many-to-one, onDelete: Restrict)
- `tickets` → `Ticket[]`

---

## 7. PLANNING & FORECASTING

### 7.1 `planning_headers`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID header planning |
| `version` | `Int` | NN | — | Phiên bản |
| `is_final_version` | `Boolean` | NN | `false` | Phiên bản cuối |
| `created_by` | `Int` | FK → user.id, NN | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `creator` ← `User` (many-to-one, onDelete: Restrict)
- `planning_collections` → `PlanningCollection[]`
- `planning_genders` → `PlanningGender[]`
- `planning_categories` → `PlanningCategory[]`

---

### 7.2 `collection_proposal`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID |
| `collection_id` | `Int` | FK → collection.id, NN | — | ID collection |
| `store_id` | `Int` | FK → store.id, NN | — | ID cửa hàng |
| `planning_header_id` | `Int` | FK → planning_headers.id, NN | — | ID header planning |
| `actual_buy_pct` | `Decimal(18,2)` | NN | `0` | % mua thực tế |
| `actual_sales_pct` | `Decimal(18,2)` | NN | `0` | % doanh thu thực tế |
| `actual_st_pct` | `Decimal(18,2)` | NN | `0` | % sell-through thực tế |
| `actual_moc` | `Decimal(18,2)` | NN | `0` | Margin thực tế |
| `proposed_buy_pct` | `Decimal(18,2)` | NN | `0` | % mua đề xuất |
| `otb_proposed_amount` | `Decimal(18,2)` | NN | `0` | Số tiền OTB đề xuất |
| `pct_var_vs_last` | `Decimal(18,2)` | NN | `0` | % chênh lệch so năm trước |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `collection` ← `Collection` (many-to-one, onDelete: Restrict)
- `store` ← `Store` (many-to-one, onDelete: Restrict)
- `planning_header` ← `PlanningHeader` (many-to-one, onDelete: Cascade)

---

### 7.3 `gender_proposal`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID |
| `gender_id` | `Int` | FK → gender.id, NN | — | ID giới tính |
| `store_id` | `Int` | FK → store.id, NN | — | ID cửa hàng |
| `planning_header_id` | `Int` | FK → planning_headers.id, NN | — | ID header planning |
| `actual_buy_pct` | `Decimal(18,2)` | NN | `0` | % mua thực tế |
| `actual_sales_pct` | `Decimal(18,2)` | NN | `0` | % doanh thu thực tế |
| `actual_st_pct` | `Decimal(18,2)` | NN | `0` | % sell-through thực tế |
| `proposed_buy_pct` | `Decimal(18,2)` | NN | `0` | % mua đề xuất |
| `otb_proposed_amount` | `Decimal(18,2)` | NN | `0` | Số tiền OTB đề xuất |
| `pct_var_vs_last` | `Decimal(18,2)` | NN | `0` | % chênh lệch so năm trước |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `gender` ← `Gender` (many-to-one, onDelete: Restrict)
- `store` ← `Store` (many-to-one, onDelete: Restrict)
- `planning_header` ← `PlanningHeader` (many-to-one, onDelete: Cascade)

---

### 7.4 `category_proposal`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID |
| `subcategory_id` | `Int` | FK → sub_category.id, NN | — | ID danh mục con |
| `planning_header_id` | `Int` | FK → planning_headers.id, NN | — | ID header planning |
| `actual_buy_pct` | `Decimal(18,2)` | NN | `0` | % mua thực tế |
| `actual_sales_pct` | `Decimal(18,2)` | NN | `0` | % doanh thu thực tế |
| `actual_st_pct` | `Decimal(18,2)` | NN | `0` | % sell-through thực tế |
| `proposed_buy_pct` | `Decimal(18,2)` | NN | `0` | % mua đề xuất |
| `otb_proposed_amount` | `Decimal(18,2)` | NN | `0` | Số tiền OTB đề xuất |
| `var_lastyear_pct` | `Decimal(18,2)` | NN | `0` | % chênh lệch so năm trước |
| `otb_actual_amount` | `Decimal(18,2)` | NN | `0` | Số tiền OTB thực tế |
| `otb_actual_buy_pct` | `Decimal(18,2)` | NN | `0` | % mua OTB thực tế |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `subcategory` ← `SubCategory` (many-to-one, onDelete: Restrict)
- `planning_header` ← `PlanningHeader` (many-to-one, onDelete: Cascade)

---

## 8. SKU PROPOSAL & ALLOCATION

### 8.1 `sku_proposal_headers`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID header SKU proposal |
| `version` | `Int` | NN | — | Phiên bản |
| `is_final_version` | `Boolean` | NN | `false` | Phiên bản cuối |
| `created_by` | `Int` | FK → user.id, NN | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `creator` ← `User` (many-to-one, onDelete: Restrict)
- `sku_proposals` → `SKUProposal[]`

---

### 8.2 `sku_proposal`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID SKU proposal |
| `sku_proposal_header_id` | `Int` | FK → sku_proposal_headers.id, NN | — | ID header |
| `product_id` | `Int` | FK → product.id, NN | — | ID sản phẩm |
| `customer_target` | `String` | NN | — | Đối tượng khách (VIP, Regular, Outlet) |
| `unit_cost` | `Decimal(18,2)` | NN | `0` | Giá vốn |
| `srp` | `Decimal(18,2)` | NN | `0` | Giá bán lẻ đề xuất |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `sku_proposal_header` ← `SKUProposalHeader` (many-to-one, onDelete: Cascade)
- `product` ← `Product` (many-to-one, onDelete: Restrict)
- `sku_allocates` → `SKUAllocate[]`
- `proposal_sizing_headers` → `ProposalSizingHeader[]`

---

### 8.3 `sku_allocates`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID phân bổ SKU |
| `sku_proposal_id` | `Int` | FK → sku_proposal.id, NN | — | ID SKU proposal |
| `store_id` | `Int` | FK → store.id, NN | — | ID cửa hàng |
| `quantity` | `Decimal(18,2)` | NN | `0` | Số lượng |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `sku_proposal` ← `SKUProposal` (many-to-one, onDelete: Cascade)
- `store` ← `Store` (many-to-one, onDelete: Restrict)

---

### 8.4 `proposal_sizing_headers`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID header sizing |
| `sku_proposal_id` | `Int` | FK → sku_proposal.id, NN | — | ID SKU proposal |
| `version` | `Int` | NN | — | Phiên bản |
| `is_final_version` | `Boolean` | NN | `false` | Phiên bản cuối |
| `created_by` | `Int` | FK → user.id, NN | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `sku_proposal` ← `SKUProposal` (many-to-one, onDelete: Cascade)
- `creator` ← `User` (many-to-one, onDelete: Restrict)
- `proposal_sizings` → `ProposalSizing[]`

---

### 8.5 `sizing_proposal`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID sizing proposal |
| `proposal_sizing_header_id` | `Int` | FK → proposal_sizing_headers.id, NN | — | ID header sizing |
| `subcategory_size_id` | `Int` | FK → subcategory_size.id, NN | — | ID size |
| `actual_salesmix_pct` | `Decimal(18,2)` | NN | `0` | % sales mix thực tế |
| `actual_st_pct` | `Decimal(18,2)` | NN | `0` | % sell-through thực tế |
| `proposal_quantity` | `Int` | NN | — | Số lượng đề xuất |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `proposal_sizing_header` ← `ProposalSizingHeader` (many-to-one, onDelete: Cascade)
- `subcategory_size` ← `SubcategorySize` (many-to-one, onDelete: Restrict)

---

## 9. APPROVAL WORKFLOW & TICKETS

### 9.1 `approval_statuses`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID trạng thái |
| `name` | `String` | UQ, NN | — | Tên (PENDING, APPROVED, REJECTED, IN_REVIEW) |
| `is_active` | `Boolean` | NN | `true` | Trạng thái |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

---

### 9.2 `ticket`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID ticket |
| `budget_allocate_id` | `Int` | FK → budget_allocate.id, NN | — | ID phân bổ ngân sách |
| `status` | `String` | NN | `PENDING` | Trạng thái (PENDING, APPROVED, REJECTED, IN_REVIEW) |
| `created_by` | `Int` | FK → user.id, NN | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `budget_allocate` ← `BudgetAllocate` (many-to-one, onDelete: Cascade)
- `creator` ← `User` (many-to-one, onDelete: Restrict)
- `ticket_approval_logs` → `TicketApprovalLog[]`

---

### 9.3 `approval_workflow`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID workflow |
| `group_brand_id` | `Int` | FK → group_brand.id, NN | — | ID nhóm brand |
| `workflow_name` | `String` | NN | — | Tên workflow |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `group_brand` ← `GroupBrand` (many-to-one, onDelete: Cascade)
- `approval_workflow_levels` → `ApprovalWorkflowLevel[]`

---

### 9.4 `approval_workflow_level`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID level |
| `approval_workflow_id` | `Int` | FK → approval_workflow.id, NN | — | ID workflow |
| `level_order` | `Int` | NN | — | Thứ tự level (1, 2, 3) |
| `level_name` | `String` | NN | — | Tên level |
| `approver_user_id` | `Int` | FK → user.id, NN | — | ID người phê duyệt |
| `is_required` | `Boolean` | NN | — | Bắt buộc hay không |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `approval_workflow` ← `ApprovalWorkflow` (many-to-one, onDelete: Cascade)
- `approver_user` ← `User` (many-to-one, onDelete: Restrict)
- `ticket_approval_logs` → `TicketApprovalLog[]`

---

### 9.5 `approval_request_log`

| Cột | Kiểu | Ràng buộc | Mặc định | Mô tả |
|---|---|---|---|---|
| `id` | `Int` | PK, AI, NN | autoincrement | ID log |
| `ticket_id` | `Int` | FK → ticket.id, NN | — | ID ticket |
| `approval_workflow_level_id` | `Int` | FK → approval_workflow_level.id, NN | — | ID level workflow |
| `approver_user_id` | `Int` | FK → user.id, NN | — | ID người phê duyệt |
| `is_approved` | `Boolean` | NN | — | Đã duyệt (`true`) hay từ chối (`false`) |
| `comment` | `String` | ? | — | Ghi chú |
| `approved_at` | `DateTime` | ? | — | Thời gian phê duyệt |
| `created_by` | `Int` | ? | — | Người tạo |
| `created_at` | `DateTime` | NN | `now()` | Thời gian tạo |
| `updated_at` | `DateTime` | NN | auto | Thời gian cập nhật |
| `updated_by` | `Int` | ? | — | Người cập nhật |

**Relations:**
- `ticket` ← `Ticket` (many-to-one, onDelete: Cascade)
- `approval_workflow_level` ← `ApprovalWorkflowLevel` (many-to-one, onDelete: Restrict)
- `approver_user` ← `User` (many-to-one, onDelete: Restrict)

---

## 10. Sơ đồ quan hệ (ERD tóm tắt)

```
user ──────────────────────────────────────────────────────────────┐
 │                                                                  │
 ├── role (role_id → role.id)                                       │
 │                                                                  │
budget (created_by → user.id)                                       │
 └── allocate_headers (budget_id, brand_id, created_by → user.id) │
      └── budget_allocate (store_id, season_id, season_group_id)  │
           └── ticket (created_by → user.id) ─────────────────────┤
                └── approval_request_log                           │
                     ├── ticket_id → ticket.id                    │
                     ├── approval_workflow_level_id                │
                     └── approver_user_id → user.id ──────────────┘

group_brand
 ├── brand (group_brand_id → group_brand.id)
 │    └── product (brand_id → brand.id, sub_category_id)
 └── approval_workflow (group_brand_id → group_brand.id)
      └── approval_workflow_level (approver_user_id → user.id)

gender → category → sub_category → subcategory_size
                              └── product (sub_category_id)

season_group → season

planning_headers (created_by → user.id)
 ├── collection_proposal (collection_id, store_id, planning_header_id)
 ├── gender_proposal     (gender_id, store_id, planning_header_id)
 └── category_proposal   (subcategory_id, planning_header_id)

sku_proposal_headers (created_by → user.id)
 └── sku_proposal (sku_proposal_header_id, product_id)
      ├── sku_allocates (sku_proposal_id, store_id)
      └── proposal_sizing_headers (sku_proposal_id, created_by → user.id)
           └── sizing_proposal (proposal_sizing_header_id, subcategory_size_id)
```
