# Setup Guide

> Panduan setup untuk development di JONI-WORKSPACE

---

## Prerequisites

### Required Software
- **Node.js** 20+ ([Download](https://nodejs.org/))
- **Git** ([Download](https://git-scm.com/))
- **pnpm** (recommended) atau npm
  ```bash
  npm install -g pnpm
  ```

### Optional but Recommended
- **VS Code** dengan extensions:
  - ESLint
  - Prettier
  - Tailwind CSS IntelliSense
  - Prisma
- **Docker** (untuk database lokal)
- **PostgreSQL** (atau gunakan Supabase/Railway)

---

## Initial Setup

### 1. Clone Repository
```bash
git clone <repository-url>
cd JONI-WORKSPACE
```

### 2. Install Dependencies
```bash
# Jika ada project yang sudah ada
cd projects/web/project-name
pnpm install
```

### 3. Environment Variables
```bash
# Copy .env.example ke .env
cp .env.example .env

# Edit .env dengan values yang sesuai
nano .env
```

**Required Environment Variables:**
```bash
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/dbname"

# Authentication (pilih salah satu)
NEXTAUTH_SECRET="your-secret-here"
NEXTAUTH_URL="http://localhost:3000"

# atau Clerk
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY="pk_test_..."
CLERK_SECRET_KEY="sk_test_..."

# API Keys (sesuai kebutuhan)
OPENAI_API_KEY="sk-..."
STRIPE_SECRET_KEY="sk_test_..."
```

### 4. Database Setup

#### Option A: Local PostgreSQL
```bash
# Install PostgreSQL
# Windows: Download from postgresql.org
# Mac: brew install postgresql
# Linux: sudo apt install postgresql

# Create database
createdb your_database_name

# Run migrations
npx prisma migrate dev
```

#### Option B: Docker
```bash
# Create docker-compose.yml
docker-compose up -d

# Run migrations
npx prisma migrate dev
```

#### Option C: Cloud (Supabase/Railway)
```bash
# Get connection string from provider
# Add to .env as DATABASE_URL

# Run migrations
npx prisma migrate dev
```

### 5. Seed Database (Optional)
```bash
npx prisma db seed
```

---

## Development

### Start Development Server
```bash
# Web project (Next.js)
cd projects/web/project-name
pnpm dev

# Bot project
cd projects/bots/bot-name
pnpm dev

# Agent project
cd projects/agents/agent-name
python src/agent.py
```

### Access Application
- **Web:** http://localhost:3000
- **API:** http://localhost:3000/api
- **Database Studio:** `npx prisma studio` → http://localhost:5555

---

## Project Structure

```
project-name/
├── src/
│   ├── app/              # Next.js app router
│   │   ├── (auth)/      # Auth routes
│   │   ├── (dashboard)/ # Dashboard routes
│   │   ├── api/         # API routes
│   │   └── layout.tsx   # Root layout
│   ├── components/
│   │   ├── ui/          # Base components (shadcn)
│   │   └── features/    # Feature components
│   ├── lib/
│   │   ├── db.ts        # Database client
│   │   ├── auth.ts      # Auth config
│   │   └── utils.ts     # Utilities
│   ├── hooks/           # Custom hooks
│   └── types/           # TypeScript types
├── prisma/
│   ├── schema.prisma    # Database schema
│   └── seed.ts          # Seed data
├── public/              # Static files
├── tests/               # Tests
├── .env.example         # Environment template
├── .env                 # Your environment (gitignored)
├── package.json
└── tsconfig.json
```

---

## Common Tasks

### Add New Dependency
```bash
pnpm add package-name
pnpm add -D package-name  # Dev dependency
```

### Database Operations
```bash
# Create migration
npx prisma migrate dev --name migration_name

# Reset database
npx prisma migrate reset

# Generate Prisma Client
npx prisma generate

# Open Prisma Studio
npx prisma studio
```

### Code Quality
```bash
# Lint
pnpm lint

# Format
pnpm format

# Type check
pnpm type-check

# Run tests
pnpm test
```

### Build for Production
```bash
pnpm build

# Test production build locally
pnpm start
```

---

## Troubleshooting

### Port Already in Use
```bash
# Kill process on port 3000
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:3000 | xargs kill -9
```

### Database Connection Error
```bash
# Check DATABASE_URL format
postgresql://USER:PASSWORD@HOST:PORT/DATABASE

# Test connection
npx prisma db pull
```

### Prisma Client Not Generated
```bash
# Regenerate client
npx prisma generate

# If still fails, delete and regenerate
rm -rf node_modules/.prisma
npx prisma generate
```

### Module Not Found
```bash
# Clear cache and reinstall
rm -rf node_modules
rm pnpm-lock.yaml
pnpm install
```

### TypeScript Errors
```bash
# Restart TypeScript server in VS Code
Cmd/Ctrl + Shift + P → "TypeScript: Restart TS Server"

# Check tsconfig.json
# Ensure paths are correct
```

---

## AI Agent Setup

### Python Projects
```bash
# Create virtual environment
python -m venv venv

# Activate
# Windows
venv\Scripts\activate
# Mac/Linux
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Create .env
cp .env.example .env

# Run agent
python src/agent.py
```

### Required Environment Variables
```bash
OPENAI_API_KEY="sk-..."
# or
ANTHROPIC_API_KEY="sk-ant-..."
# or
GOOGLE_API_KEY="..."

# Vector DB (if using RAG)
PINECONE_API_KEY="..."
PINECONE_ENVIRONMENT="..."
```

---

## Bot Setup

### Telegram Bot
```bash
# Get bot token from @BotFather
# Add to .env
TELEGRAM_BOT_TOKEN="123456:ABC-DEF..."

# Run bot
pnpm dev
```

### Discord Bot
```bash
# Create app at discord.com/developers
# Add to .env
DISCORD_BOT_TOKEN="..."
DISCORD_CLIENT_ID="..."

# Run bot
pnpm dev
```

---

## Deployment

### Vercel (Web Apps)
```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel

# Production
vercel --prod
```

### Railway (Full-stack Apps)
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link project
railway link

# Deploy
railway up
```

### Environment Variables in Production
- Add all .env variables to hosting platform
- Never commit .env to git
- Use platform's secret management

---

## Getting Help

### Documentation
- Check `.ai/` folder for conventions & workflows
- Read `docs/architecture.md` for system overview
- Check project-specific README

### Common Issues
- Check `.ai/memory/learnings.md` for known gotchas
- Search GitHub issues
- Ask in team chat

### AI Assistance
- Use Claude Code / Cursor with workspace context
- AI agents have access to `.ai/` folder
- Update memory files after solving issues

---

**Last Updated:** 2026-03-19
