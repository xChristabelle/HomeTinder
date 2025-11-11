# 🏠 HomeTinder - Local Development Guide

Complete guide to running HomeTinder on your local machine for development.

---

## 📋 Prerequisites

Before you begin, ensure you have these installed:

### Required Software

1. **Node.js** (v20 or higher)

   ```bash
   node --version  # Should be v20+
   ```

   Download: https://nodejs.org/

2. **Docker Desktop**

   - Required for running Supabase locally
   - Download: https://www.docker.com/products/docker-desktop/

3. **Git**

   ```bash
   git --version
   ```

4. **PowerShell** (Windows - already installed)
   - Or use Git Bash / WSL

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Clone the Repository

```bash
git clone https://github.com/xChristabelle/HomeTinder.git
cd HomeTinder
```

### Step 2: Install Dependencies

```bash
# Install root dependencies (if any)
npm install

# Install frontend dependencies
cd frontend
npm install
cd ..
```

### Step 3: Start Database

**Windows (PowerShell):**

```powershell
.\setup-db.ps1
```

**macOS/Linux (Bash):**

```bash
chmod +x setup-db.sh
./setup-db.sh
```

**What this does:**

- ✅ Installs Supabase CLI (if not installed)
- ✅ Starts local Supabase (pulls Docker images first time)
- ✅ Applies all database migrations
- ✅ Displays connection info

**Expected output:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏠 HomeTinder - Database Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Supabase CLI found
🚀 Starting Supabase services...

         API URL: http://127.0.0.1:54321
     GraphQL URL: http://127.0.0.1:54321/graphql/v1
  S3 Storage URL: http://127.0.0.1:54321/storage/v1
          DB URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
      Studio URL: http://127.0.0.1:54323
    Inbucket URL: http://127.0.0.1:54324
      JWT secret: super-secret-jwt-token-with-at-least-32-characters-long
        anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Step 4: Configure Frontend

```bash
cd frontend

# Copy environment template
cp env.example .env

# The default values should work out of the box!
# No changes needed for local development
```

Your `.env` file should contain:

```env
VITE_SUPABASE_URL=http://127.0.0.1:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
VITE_SUPABASE_API_URL=http://127.0.0.1:54321/functions/v1
```

### Step 5: Start Frontend

```bash
# Make sure you're in the frontend directory
npm run dev
```

**Expected output:**

```
  VITE v7.1.7  ready in 543 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```

### Step 6: Open in Browser

```
http://localhost:5173
```

**You should see:**

- 🏠 HomeTinder landing page
- Sign in / Sign up forms
- Beautiful gradient UI

---

## 🎯 What's Running Locally?

After setup, you'll have these services:

| Service             | URL                          | Purpose                     |
| ------------------- | ---------------------------- | --------------------------- |
| **Frontend**        | http://localhost:5173        | React app (Vite dev server) |
| **Supabase API**    | http://127.0.0.1:54321       | Database API                |
| **Supabase Studio** | http://127.0.0.1:54323       | Database admin UI           |
| **PostgreSQL**      | postgresql://localhost:54322 | Direct database access      |
| **Email Testing**   | http://127.0.0.1:54324       | View signup emails          |

---

## 🔧 Detailed Setup (Step by Step)

### Option A: Manual Setup (If script doesn't work)

#### 1. Install Supabase CLI

```powershell
# Using npm (recommended)
npm install -g supabase

# Or using Scoop (alternative)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Verify installation
supabase --version
```

#### 2. Start Docker Desktop

- Open Docker Desktop application
- Wait for it to fully start (Docker icon in system tray)
- Verify Docker is running:
  ```bash
  docker ps
  ```

#### 3. Initialize and Start Supabase

```bash
cd c:\dev\projects\remote\HomeTinder\apps\supabase

# Start Supabase (first time will pull Docker images - ~5 minutes)
npx supabase start
```

**First time startup downloads:**

- PostgreSQL image (~100 MB)
- PostgREST API image
- Supabase Studio image
- Storage API image
- Auth service image

#### 4. Apply Database Migrations

```bash
# This creates all tables, indexes, and policies
npx supabase db reset
```

#### 5. Install Frontend Dependencies

```bash
cd ../../frontend
npm install
```

#### 6. Create Environment File

```bash
# Copy the example
cp env.example .env

# File will contain correct local values
```

#### 7. Start Frontend Development Server

```bash
npm run dev
```

---

## 🧪 Testing the Application

### 1. Create a Test Account

1. Open http://localhost:5173
2. Click **Sign up**
3. Fill in:
   - First Name: Test
   - Last Name: User
   - Phone: +1 (555) 123-4567
   - Email: test@example.com
   - Password: Test123!
4. Click **Create account**

**Important:** In local development, email verification is disabled. You'll be logged in immediately.

### 2. View Email in Inbucket

```
http://127.0.0.1:54324
```

- See the confirmation email that "would" be sent
- Useful for testing email templates

### 3. Set Preferences

1. Click **👤 My Profile** in navigation
2. Set your search criteria:
   - Price range: $500,000 - $1,000,000
   - Property type: House
   - Transaction: Sale
   - Location: Click on map (Toronto area)
   - Radius: 5 km
3. Click **Save Preferences**

### 4. Browse Properties (With Test Data)

**Note:** Without running the Lambda functions, you won't have real property data.

To add test data manually:

```sql
-- Go to Supabase Studio: http://127.0.0.1:54323
-- Navigate to: SQL Editor
-- Run this query:

INSERT INTO public.properties (mls_number, address, city, price, bedrooms, bathrooms, property_type, is_active)
VALUES
  ('TEST001', '123 Main St', 'Toronto', 750000, 3, 2, 'Residential', true),
  ('TEST002', '456 Oak Ave', 'Toronto', 850000, 4, 3, 'Residential', true),
  ('TEST003', '789 Pine Rd', 'Mississauga', 650000, 2, 2, 'Condo Apt', true);

INSERT INTO public.media (mls_number, image_urls)
VALUES
  ('TEST001', ARRAY['https://images.unsplash.com/photo-1568605114967-8130f3a36994']),
  ('TEST002', ARRAY['https://images.unsplash.com/photo-1570129477492-45c003edd2be']),
  ('TEST003', ARRAY['https://images.unsplash.com/photo-1582407947304-fd86f028f716']);
```

Now refresh the app - you should see 3 test properties!

### 5. Test Swipe Functionality

- Swipe **right** to like a property ❤️
- Swipe **left** to dislike ❌
- Or use the buttons below the card

### 6. View Liked Properties

- Click **❤️ My Likes** in navigation
- See your liked and disliked properties
- Test the "Remove" button

---

## 🗄️ Database Management

### Access Supabase Studio (Visual Interface)

```
http://127.0.0.1:54323
```

**What you can do:**

- ✅ View/edit table data
- ✅ Run SQL queries
- ✅ Test RLS policies
- ✅ View database logs
- ✅ Manage authentication

### Direct Database Access (SQL Client)

```bash
# Connection string
postgresql://postgres:postgres@127.0.0.1:54322/postgres

# Using psql
psql postgresql://postgres:postgres@127.0.0.1:54322/postgres
```

### Common Database Commands

```bash
# View database status
cd apps/supabase
supabase status

# Reset database (reapply all migrations)
supabase db reset

# Create a new migration
supabase migration new add_feature_name

# Generate migration from changes
npx supabase db diff add_feature_name

# Stop Supabase (keeps data)
npx supabase stop

# Start Supabase
npx supabase start
```

---

## 🐛 Troubleshooting

### Problem: "Docker is not running"

**Solution:**

1. Open Docker Desktop
2. Wait for it to start completely
3. Look for Docker icon in system tray
4. Try `docker ps` to verify
5. Run `npx supabase start` again

---

### Problem: "Port 54321 already in use"

**Solution:**

```bash
# Check what's using the port
netstat -ano | findstr :54321

# Kill the process (if safe)
taskkill /PID <process_id> /F

# Or change Supabase port in config.toml
```

---

### Problem: "Module not found" errors in frontend

**Solution:**

```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
```

---

### Problem: "Cannot connect to Supabase"

**Solution:**

```bash
# Check Supabase is running
cd apps/supabase
npx supabase status

# If not running
npx supabase start

# Verify URL in frontend/.env matches output
```

---

### Problem: "No properties showing"

**Solution:**
You need test data! See "Testing the Application" → "Browse Properties (With Test Data)"

Or run the Lambda functions locally (advanced):

```bash
cd apps/lambda/replicator
# You'll need TREB API credentials
```

---

### Problem: "RLS policy prevents this action"

**Solution:**

```sql
-- Temporarily disable RLS for testing
-- Go to: http://127.0.0.1:54323 → SQL Editor

ALTER TABLE public.properties DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.media DISABLE ROW LEVEL SECURITY;

-- Remember to re-enable later!
```

---

### Problem: Migrations fail to apply

**Solution:**

```bash
# Check migration status
cd apps/supabase
supabase migration list

# View detailed error
supabase db reset --debug

# Nuclear option (wipes everything)
supabase db reset --no-confirm
```

---

## 🔄 Daily Development Workflow

### Starting Your Day

```bash
# 1. Start Supabase (if not already running)
cd apps/supabase
npx supabase start

# 2. Start frontend
cd ../../frontend
npm run dev

# 3. Open browser to http://localhost:5173
```

### Ending Your Day

```bash
# Stop frontend (Ctrl+C in terminal)

# Stop Supabase (optional - keeps data)
cd apps/supabase
npx supabase stop

# Docker will keep running - that's fine
```

---

## 📁 Project Structure

```
HomeTinder/
├── frontend/                    ← React frontend
│   ├── src/
│   │   ├── components/         ← UI components
│   │   ├── pages/              ← Page components
│   │   ├── hooks/              ← Custom React hooks
│   │   └── lib/                ← Supabase client
│   ├── .env                    ← Environment variables (create this!)
│   └── package.json
│
├── apps/
│   ├── supabase/               ← Database & backend
│   │   ├── migrations/         ← Database migrations
│   │   ├── functions/          ← Edge Functions
│   │   └── config.toml         ← Supabase config
│   │
│   └── lambda/                 ← AWS Lambda functions
│       ├── replicator/         ← TREB data sync
│       └── activeSync/         ← Active listing sync
│
├── setup-db.ps1                ← Database setup (Windows)
├── setup-db.sh                 ← Database setup (macOS/Linux)
└── LOCAL_DEVELOPMENT.md        ← This file!
```

---

## 🎓 Learning Resources

### Supabase

- [Supabase Docs](https://supabase.com/docs)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)
- [PostgreSQL Tutorial](https://www.postgresql.org/docs/current/tutorial.html)

### Frontend

- [React Docs](https://react.dev/)
- [Vite Guide](https://vitejs.dev/guide/)
- [TailwindCSS Docs](https://tailwindcss.com/docs)
- [React Router](https://reactrouter.com/)

### HomeTinder Specific

- [Database Schema Docs](apps/supabase/DATABASE.md)
- [GitHub Actions Workflow](.github/workflows/main.yml)

---

## 🚀 Advanced: Running Lambda Functions Locally

**Note:** This requires TREB API credentials (not included in repo).

### Setup Environment

```bash
# Create .env file at root
cp env.template .env

# Add your TREB API key
TREB_ACCESS_TOKEN=your_actual_key_here
```

### Run Replicator

```bash
cd apps/lambda/replicator
npm install

# Run locally
node -r dotenv/config replicator.js
```

This will:

- Fetch properties from TREB API
- Insert into local Supabase
- Populate your database with real data

---

## 🆘 Getting Help

### Quick Diagnostics

Run this to check your setup:

```bash
# Check Node.js
node --version

# Check npm
npm --version

# Check Docker
docker --version
docker ps

# Check Supabase
cd apps/supabase
supabase status

# Check frontend dependencies
cd ../frontend
npm list --depth=0
```

### Common Issues Checklist

- [ ] Docker Desktop is running
- [ ] Supabase is started (`supabase status` shows services)
- [ ] Frontend `.env` file exists
- [ ] Frontend dependencies installed (`node_modules` folder exists)
- [ ] No port conflicts (54321, 54322, 54323, 5173)
- [ ] No firewall blocking localhost connections

---

## ✅ Success Checklist

You've successfully set up HomeTinder locally when:

- [ ] ✅ Supabase Studio opens at http://127.0.0.1:54323
- [ ] ✅ Frontend loads at http://localhost:5173
- [ ] ✅ Can create an account and sign in
- [ ] ✅ Can see test properties (after adding test data)
- [ ] ✅ Can swipe on properties
- [ ] ✅ Can view liked properties
- [ ] ✅ Can update preferences in profile

---

## 🎉 You're Ready to Develop!

Your local development environment is now complete. Happy coding! 🚀

**Next Steps:**

- Check out open issues on GitHub
- Read the [Database Documentation](apps/supabase/DATABASE.md)
- Join the development discussion
- Start building features!
