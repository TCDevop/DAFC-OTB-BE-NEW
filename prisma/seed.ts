// ============================================================================
// Database Seed — Users only for DAFC OTB Planning System
// Run: npx prisma db seed   or   npm run prisma:seed
// ⚠️  Chỉ tạo roles + users — KHÔNG tạo data khác (master data, budgets, etc.)
// ============================================================================

import { PrismaClient } from '../src/generated/prisma';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function findOrCreate<T>(
  findFn: () => Promise<T | null>,
  createFn: () => Promise<T>,
): Promise<T> {
  const existing = await findFn();
  if (existing) return existing;
  return createFn();
}

async function main() {
  console.log('Seeding database (users only)...');

  // ─── ROLES ────────────────────────────────────────────────────────────
  const roleDefs = [
    {
      name: 'admin',
      description: 'System Administrator',
      permissions: JSON.stringify(['*']),
    },
    {
      name: 'buyer',
      description: 'Buyer — creates proposals, manages SKU selection',
      permissions: JSON.stringify([
        'budget:read', 'planning:read',
        'proposal:read', 'proposal:write', 'proposal:submit', 'master:read',
      ]),
    },
    {
      name: 'merchandiser',
      description: 'Merchandiser — creates budgets and planning',
      permissions: JSON.stringify([
        'budget:read', 'budget:write', 'budget:submit',
        'planning:read', 'planning:write', 'planning:submit',
        'proposal:read', 'master:read',
      ]),
    },
    {
      name: 'merch_manager',
      description: 'Merchandising Manager — Level 1 Approver',
      permissions: JSON.stringify([
        'budget:read', 'budget:write', 'budget:submit', 'budget:approve_l1',
        'planning:read', 'planning:write', 'planning:approve_l1',
        'proposal:read', 'proposal:approve_l1', 'master:read',
      ]),
    },
    {
      name: 'finance_director',
      description: 'Finance Director — Level 2 Approver',
      permissions: JSON.stringify([
        'budget:read', 'budget:approve_l2',
        'planning:read', 'planning:approve_l2',
        'proposal:read', 'proposal:approve_l2', 'master:read',
      ]),
    },
  ];

  const roles = await Promise.all(
    roleDefs.map(def =>
      findOrCreate(
        () => prisma.role.findFirst({ where: { name: def.name } }),
        () => prisma.role.create({ data: def }),
      ),
    ),
  );

  const [adminRole, buyerRole, merchRole, merchMgrRole, finDirRole] = roles;
  console.log(`  ${roles.length} roles created`);

  // ─── DEFAULT USERS ────────────────────────────────────────────────────
  const password = await bcrypt.hash('dafc@2026', 12);

  const userDefs = [
    { email: 'admin@dafc.com',   name: 'System Admin',      role_id: adminRole.id },
    { email: 'buyer@dafc.com',   name: 'Nguyen Van Buyer',  role_id: buyerRole.id },
    { email: 'merch@dafc.com',   name: 'Tran Thi Merch',    role_id: merchRole.id },
    { email: 'manager@dafc.com', name: 'Le Van Manager',    role_id: merchMgrRole.id },
    { email: 'finance@dafc.com', name: 'Pham Director',     role_id: finDirRole.id },
  ];

  const users = await Promise.all(
    userDefs.map(def =>
      findOrCreate(
        () => prisma.user.findFirst({ where: { email: def.email } }),
        () => prisma.user.create({ data: { ...def, password_hash: password } }),
      ),
    ),
  );
  console.log(`  ${users.length} users created (password: dafc@2026)`);

  console.log('\nSeed completed successfully!');
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
