# HomeTinder Database Documentation

## 📊 Database Schema Overview

### Tables

1. **properties** - Real estate listings from TREB API
2. **media** - Property images and media URLs
3. **user_preferences** - User search preferences
4. **user_properties** - User swipe history (likes/dislikes)
5. **users** - Extended user profiles

### Entity Relationship Diagram

```
┌─────────────────┐
│   auth.users    │ (Supabase Auth)
│  (Built-in)     │
└────────┬────────┘
         │
         ├─────────────────┐
         │                 │
         ▼                 ▼
┌─────────────────┐  ┌──────────────────┐
│ user_preferences│  │  user_properties │
│                 │  │                  │
│ • user_id (FK)  │  │ • user_id (FK)   │
│ • min_price     │  │ • mls_number (FK)│
│ • max_price     │  │ • status         │
│ • location_lat  │  └────────┬─────────┘
│ • location_lng  │           │
│ • radius_m      │           │
└─────────────────┘           │
                              │
                              ▼
                     ┌─────────────────┐
                     │   properties    │
                     │                 │
                     │ • mls_number PK │
                     │ • address       │
                     │ • price         │
                     │ • bedrooms      │
                     │ • is_active     │
                     └────────┬────────┘
                              │
                              ▼
                     ┌─────────────────┐
                     │     media       │
                     │                 │
                     │ • mls_number FK │
                     │ • image_urls[]  │
                     └─────────────────┘
```

## 🚀 Quick Start

### Initial Setup (First Time Only)

**Windows (PowerShell):**

```powershell
.\setup-db.ps1
```

**macOS/Linux (Bash):**

```bash
chmod +x setup-db.sh
./setup-db.sh
```

This will:

- ✅ Install Supabase CLI (if needed)
- ✅ Start local Supabase instance
- ✅ Apply all database migrations
- ✅ Display connection information

### Daily Development

```bash
# Start Supabase
cd apps/supabase
npx supabase start

# Check status
npx supabase status

# Stop when done
npx supabase stop
```

## 📝 Working with Migrations

### Creating a New Migration

```bash
cd apps/supabase

# Method 1: Create empty migration
npx supabase migration new add_feature_name

# Method 2: Auto-generate from local changes
npx supabase db diff add_feature_name
```

### Applying Migrations

```bash
# Apply to local database
npx supabase db reset

# Or push without resetting
npx supabase db push

# Apply to production (via CI/CD)
git push origin dev  # Triggers GitHub Actions
```

### Migration Naming Convention

```
<timestamp>_<description>.sql

Examples:
20250111000000_baseline_schema.sql
20250111000001_add_foreign_keys.sql
20250111120000_add_square_feet_column.sql
```

## 🔐 Row-Level Security (RLS)

### Current Policies

| Table            | SELECT               | INSERT            | UPDATE            | DELETE        |
| ---------------- | -------------------- | ----------------- | ----------------- | ------------- |
| properties       | Public (active only) | Service role only | Service role only | ❌            |
| media            | Public               | Service role only | Service role only | ❌            |
| user_preferences | Own data only        | Own data only     | Own data only     | Own data only |
| user_properties  | Own data only        | Own data only     | Own data only     | Own data only |
| users            | Own data only        | Own data only     | Own data only     | Own data only |

### Testing RLS Policies

```sql
-- Test as authenticated user
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims TO '{"sub": "user-uuid-here"}';

-- Try to access data
SELECT * FROM user_properties;  -- Should only see your own

-- Reset
RESET ROLE;
```

## 🔧 Common Operations

### View Applied Migrations

```sql
SELECT version, name
FROM supabase_migrations.schema_migrations
ORDER BY version;
```

### Check RLS Status

```sql
SELECT
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public';
```

### View Foreign Keys

```sql
SELECT
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name,
  rc.delete_rule,
  rc.update_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
  ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public';
```

### Check Index Usage

```sql
SELECT
  schemaname,
  tablename,
  indexname,
  idx_scan as scans,
  pg_size_pretty(pg_relation_size(indexrelid)) as size
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;
```

## 🐛 Troubleshooting

### Migration Failed

```bash
# View detailed error
npx supabase db reset --debug

# Check PostgreSQL logs
docker logs supabase_db_hometinder
```

### Table Already Exists Error

Our migrations use `IF NOT EXISTS` to handle existing tables. If you get this error:

1. The migration was applied before
2. Someone manually created the table

**Solution:**

```sql
-- Mark migration as applied manually
INSERT INTO supabase_migrations.schema_migrations (version, name)
VALUES ('20250111000000', 'baseline_schema');
```

### Connection Refused

```bash
# Restart Supabase
npx supabase stop
npx supabase start

# Check Docker
docker ps | grep supabase
```

### Reset Everything (Nuclear Option)

```bash
# WARNING: Destroys all data!
npx supabase stop
npx supabase db reset
```

## 📚 Migration History

| Version        | Date       | Description                  |
| -------------- | ---------- | ---------------------------- |
| 20250111000000 | 2025-01-11 | Baseline schema - All tables |
| 20250111000001 | 2025-01-11 | Foreign key constraints      |
| 20250111000002 | 2025-01-11 | Row-level security policies  |
| 20250111000003 | 2025-01-11 | Performance indexes          |

## 🔗 Useful Links

- [Supabase Docs](https://supabase.com/docs)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Supabase Studio](http://127.0.0.1:54323) (local)

## ⚠️ Production Deployment

Migrations are automatically deployed via GitHub Actions when you push to `dev` branch:

1. Database migrations applied first
2. Edge Functions deployed second
3. Lambda functions deployed last

**Required Secrets:**

- `SUPABASE_ACCESS_TOKEN`
- `SUPABASE_PROJECT_REF`
- `SUPABASE_DB_PASSWORD`

## 🆘 Getting Help

If you encounter issues:

1. Check this documentation
2. Run `npx supabase status` to check local instance
3. Check GitHub Actions logs for production issues
4. Review PostgreSQL logs: `docker logs supabase_db_hometinder`
