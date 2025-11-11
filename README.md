# 🏠 HomeTinder

> Tinder for Real Estate - Swipe to find your dream home!

**Live Demo:** [hometinder.vercel.app](https://hometinder.vercel.app/)

---

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/xChristabelle/HomeTinder.git
cd HomeTinder

# 2. Install dependencies
npm install
cd frontend && npm install && cd ..

# 3. Start database (Windows: .\setup-db.ps1 | macOS/Linux: ./setup-db.sh)
./setup-db.sh

# 4. Start frontend
cd frontend
cp env.example .env
npm run dev

# 5. Open http://localhost:5173
```

**Full setup guide:** [LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md)

---

## 📚 Documentation

- **[Local Development Guide](LOCAL_DEVELOPMENT.md)** - Complete setup instructions
- **[Database Schema](apps/supabase/DATABASE.md)** - Database structure and migrations
- **[GitHub Secrets Setup](GITHUB_SECRETS.md)** - CI/CD configuration

---

## 🏗️ Tech Stack

### Frontend

- **React 19** - UI framework
- **TypeScript** - Type safety
- **Vite** - Build tool
- **TailwindCSS** - Styling
- **Framer Motion** - Animations
- **React Leaflet** - Maps
- **React Router** - Routing
- **Tanstack Query** - Data fetching

### Backend

- **Supabase** - Database & Auth
- **PostgreSQL** - Database
- **Deno Edge Functions** - API endpoints
- **AWS Lambda** - TREB data sync

### Infrastructure

- **Docker** - Local development
- **GitHub Actions** - CI/CD
- **Vercel** - Frontend hosting
- **AWS** - Lambda functions

---

## 🗂️ Project Structure

```
HomeTinder/
├── frontend/              # React frontend application
│   ├── src/
│   │   ├── components/   # Reusable UI components
│   │   ├── pages/        # Page components
│   │   ├── hooks/        # Custom React hooks
│   │   ├── lib/          # Utilities & Supabase client
│   │   └── types/        # TypeScript definitions
│   └── package.json
│
├── apps/
│   ├── supabase/         # Database & backend
│   │   ├── migrations/   # Database schema migrations
│   │   └── functions/    # Edge Functions (API)
│   │
│   └── lambda/           # AWS Lambda functions
│       ├── replicator/   # TREB property data sync
│       └── activeSync/   # Active listing status sync
│
├── .github/workflows/    # CI/CD pipelines
├── setup-db.ps1          # Database setup (Windows)
└── setup-db.sh           # Database setup (macOS/Linux)
```

---

## ✨ Features

### Current

- ✅ User authentication (email/password & Google OAuth)
- ✅ Tinder-style property swiping
- ✅ Property filtering & preferences
- ✅ Likes/dislikes management
- ✅ Interactive map-based location selection
- ✅ TREB API integration for Toronto real estate listings
- ✅ Automatic property sync

### Coming Soon

- 🚧 Property detail view
- 🚧 Saved searches
- 🚧 Property alerts
- 🚧 Advanced filters
- 🚧 Agent contact integration
- 🚧 Property comparison

---

## 🛠️ Development

### Prerequisites

- Node.js 20+
- Docker Desktop
- Git

### Environment Setup

1. **Database:** Run `.\setup-db.ps1` (Windows) or `./setup-db.sh` (macOS/Linux) to start local Supabase
2. **Frontend:** Copy `frontend/env.example` to `frontend/.env`
3. **Start:** Run `npm run dev` in frontend directory

See [LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md) for detailed instructions.

### Available Scripts

```bash
# Frontend
cd frontend
npm run dev       # Start dev server
npm run build     # Build for production
npm run lint      # Run ESLint

# Database
cd apps/supabase
npx supabase start    # Start local database
npx supabase stop     # Stop local database
npx supabase status   # Check status
npx supabase db reset # Reset & apply migrations
```

---

## 🚀 Deployment

Deployments are automated via GitHub Actions:

1. **Push to `dev` branch** triggers deployment
2. **Database migrations** apply first
3. **Edge Functions** deploy second
4. **Lambda functions** deploy last

Required secrets: See [GITHUB_SECRETS.md](GITHUB_SECRETS.md)

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is in initial development phase.

---

## 📧 Contact

- **GitHub:** [@xChristabelle](https://github.com/xChristabelle)
- **Live Site:** [hometinder.vercel.app](https://hometinder.vercel.app/)

---

## 🙏 Acknowledgments

- TREB (Toronto Real Estate Board) for property data API
- Supabase for backend infrastructure
- Vercel for hosting

---

**Status:** 🚧 Early Development - Better things coming soon!
