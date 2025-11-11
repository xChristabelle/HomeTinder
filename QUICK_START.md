# 🚀 HomeTinder - Quick Reference

## Most Common Commands

### 🏁 Initial Setup (One Time)

```powershell
# Clone and install
git clone https://github.com/xChristabelle/HomeTinder.git
cd HomeTinder
npm install
cd frontend && npm install && cd ..

# Setup database
# Windows: .\setup-db.ps1
# macOS/Linux: chmod +x setup-db.sh && ./setup-db.sh
./setup-db.sh
```

---

## 📅 Daily Development

### Start Everything

```bash
# Terminal 1: Start Supabase (if not running)
cd apps/supabase
npx supabase start

# Terminal 2: Start frontend
cd frontend
npm run dev

# Open: http://localhost:5173
```

### Stop Everything

```bash
# Stop frontend: Ctrl+C in terminal
# Stop Supabase (optional):
cd apps/supabase
npx supabase stop
```

---

## 🗄️ Database Commands

```bash
cd apps/supabase

# View status
npx supabase status

# Reset database (reapply migrations)
npx supabase db reset

# Create new migration
npx supabase migration new my_feature

# Generate migration from changes
npx supabase db diff my_feature

# View applied migrations
npx supabase migration list
```

---

## 🌐 Important URLs

| Service         | URL                    | Purpose      |
| --------------- | ---------------------- | ------------ |
| Frontend        | http://localhost:5173  | Main app     |
| Supabase Studio | http://127.0.0.1:54323 | Database UI  |
| Email Testing   | http://127.0.0.1:54324 | View emails  |
| API             | http://127.0.0.1:54321 | Supabase API |

---

## 🐛 Quick Fixes

### "Docker not running"

```bash
# Open Docker Desktop and wait for it to start
docker ps  # Verify it's running
```

### "Port already in use"

```bash
# Find what's using the port
netstat -ano | findstr :54321
# Kill it if safe
taskkill /PID <pid> /F
```

### "Module not found"

```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### "Can't connect to Supabase"

```bash
cd apps/supabase
npx supabase status  # Check if running
npx supabase start   # Start if needed
```

### "No properties showing"

Add test data in Supabase Studio (http://127.0.0.1:54323):

```sql
INSERT INTO public.properties (mls_number, address, city, price, bedrooms, bathrooms, property_type, is_active)
VALUES ('TEST001', '123 Main St', 'Toronto', 750000, 3, 2, 'Residential', true);

INSERT INTO public.media (mls_number, image_urls)
VALUES ('TEST001', ARRAY['https://images.unsplash.com/photo-1568605114967-8130f3a36994']);
```

---

## 🔧 Environment Files

### Frontend `.env`

```env
VITE_SUPABASE_URL=http://127.0.0.1:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
VITE_SUPABASE_API_URL=http://127.0.0.1:54321/functions/v1
```

---

## 📚 Full Documentation

- **[LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md)** - Complete setup guide
- **[DATABASE.md](apps/supabase/DATABASE.md)** - Database documentation
- **[GITHUB_SECRETS.md](GITHUB_SECRETS.md)** - Deployment secrets

---

## ✅ Success Checklist

- [ ] Docker Desktop running
- [ ] `supabase status` shows all services
- [ ] Frontend at http://localhost:5173 loads
- [ ] Can sign up and sign in
- [ ] Can see test properties
- [ ] Can swipe and like properties

---

## 🆘 Need Help?

1. Check [LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md) troubleshooting section
2. Run diagnostics:
   ```bash
   node --version        # Should be 20+
   docker ps             # Should show supabase containers
   npx supabase status   # Should show all running
   ```
3. Ask in GitHub Issues

---

**Happy Coding! 🏠💙**
