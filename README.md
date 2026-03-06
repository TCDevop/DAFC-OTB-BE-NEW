# DAFC OTB Backend API

> NestJS + SQL Server + Prisma backend for the OTB Planning Management System

## Quick Start

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Setup Environment

```bash
cp .env.example .env
# Edit .env with your DB connection and server settings
```

### 3. Run Migrations & Seed

```bash
npx prisma generate
npx prisma migrate dev --name init
npm run prisma:seed
```

### 4. Start Dev Server

```bash
npm run start:dev
```

API runs at `http://<HOST>:<PORT>/api/v1`
Swagger docs at `http://<HOST>:<PORT>/api/docs`

## Default Users

| Email | Password | Role |
|-------|----------|------|
| admin@dafc.com | dafc@2026 | System Admin |
| buyer@dafc.com | dafc@2026 | Buyer |
| merch@dafc.com | dafc@2026 | Merchandiser |
| manager@dafc.com | dafc@2026 | Merch Manager (L1 Approver) |
| finance@dafc.com | dafc@2026 | Finance Director (L2 Approver) |

## Project Structure

```
src/
├── main.ts                          # App bootstrap + Swagger
├── app.module.ts                    # Root module
├── prisma/
│   ├── prisma.service.ts            # Database connection
│   └── prisma.module.ts             # Global DB module
├── common/
│   ├── guards/
│   │   ├── jwt-auth.guard.ts        # JWT authentication
│   │   └── permissions.guard.ts     # RBAC permission check
│   ├── filters/
│   │   └── http-exception.filter.ts # Standardized error responses
│   ├── interceptors/
│   │   └── response.interceptor.ts  # Standardized success responses
│   └── middleware/
│       └── correlation-id.middleware.ts
├── modules/
│   ├── auth/                        # Login, JWT, refresh token
│   ├── master-data/                 # Brands, stores, categories, SKU catalog
│   ├── budget/                      # Budget CRUD + 2-level approval
│   ├── planning/                    # OTB Planning + versions + dimensions
│   ├── proposal/                    # SKU Proposals + products
│   ├── approval-workflow/           # Workflow config per brand
│   ├── ai/                          # Size curve, alerts, allocation, risk, SKU recommend
│   ├── ticket/                      # Ticket management
│   └── health/                      # Health check
prisma/
├── schema.prisma                    # Database schema (35 tables, SQL Server)
├── seed.ts                          # Master data + default users
```

## Environment Variables (backend/.env)

```
DATABASE_URL="sqlserver://host:1433;database=dbname;user=...;password=...;encrypt=true;trustServerCertificate=true"
JWT_SECRET="your-secret-key"
HOST="<your-host-ip>"
PORT=4001
CORS_ORIGINS="http://localhost:3000,http://<your-host-ip>:3000,http://<your-host-ip>:4001"
```

## API Modules (port 4001)

| Module | Base Path | Endpoints |
|--------|-----------|-----------|
| Auth | `/auth` | login, refresh, me |
| Budget | `/budgets` | CRUD + submit + approve L1/L2 |
| Planning | `/planning` | CRUD + copy + submit + approve + finalize |
| Proposal | `/proposals` | CRUD + products + bulk + submit + approve |
| Master Data | `/master` | brands, stores, collections, categories, SKU catalog |
| AI | `/ai` | size-curve, alerts, allocation, risk, sku-recommend |
| Approval Workflow | `/approval-workflow` | CRUD + reorder per brand |
| Ticket | `/tickets` | Ticket management |
| Health | `/health` | Health check |
