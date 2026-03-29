# CI/CD & Automation Guide

## 📋 Overview

Comprehensive guide untuk CI/CD pipelines, automated testing, dan monitoring di Zahra Workspace.

---

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow

**Location:** [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml:1)

**Pipeline Stages:**
1. **Lint & Format** - Code quality checks
2. **Type Check** - TypeScript validation
3. **Unit Tests** - Automated testing with coverage
4. **Build** - Production build
5. **Security Scan** - Vulnerability detection
6. **Deploy** - Automated deployment (main branch only)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`

---

## 🧪 Testing Framework

### Setup

**Framework:** Vitest (fast, modern, Vite-native)

**Configuration:** [`vitest.config.ts`](vitest.config.ts:1)

**Features:**
- Fast execution
- Coverage reporting
- UI mode for debugging
- Watch mode for development

### Running Tests

```bash
# Run all tests
npm test

# Run with UI
npm run test:ui

# Run with coverage
npm run test:coverage

# Watch mode
npm test -- --watch
```

### Writing Tests

**Example:** [`tests/rate-limiter.test.ts`](tests/rate-limiter.test.ts:1)

```typescript
import { describe, it, expect, beforeEach } from 'vitest';

describe('MyFeature', () => {
  beforeEach(() => {
    // Setup before each test
  });

  it('should do something', () => {
    // Arrange
    const input = 'test';
    
    // Act
    const result = myFunction(input);
    
    // Assert
    expect(result).toBe('expected');
  });
});
```

### Test Coverage Goals

- **Unit Tests:** 80%+ coverage
- **Integration Tests:** Key workflows covered
- **E2E Tests:** Critical user paths

---

## 🔍 Code Quality

### Linting

**Tool:** ESLint with TypeScript support

```bash
# Run linter
npm run lint

# Fix auto-fixable issues
npm run lint:fix
```

**Configuration:** `.eslintrc.json` (auto-generated)

### Formatting

**Tool:** Prettier

```bash
# Format all files
npm run format

# Check formatting
npm run format:check
```

**Configuration:** `.prettierrc` (auto-generated)

### Type Checking

```bash
# Check types
npm run typecheck
```

---

## 🔐 Security Scanning

### Automated Scans

**Tools:**
1. **Snyk** - Dependency vulnerability scanning
2. **npm audit** - Built-in security audit
3. **GitHub Dependabot** - Automated dependency updates

### Setup Snyk

1. Sign up at https://snyk.io
2. Get API token
3. Add to GitHub Secrets: `SNYK_TOKEN`
4. Pipeline will auto-scan on every push

### Manual Security Check

```bash
# Run npm audit
npm audit

# Fix vulnerabilities
npm audit fix

# Force fix (may break things)
npm audit fix --force
```

---

## 📊 Monitoring & Observability

### Application Monitoring

**Recommended Tools:**
- **Sentry** - Error tracking
- **LogRocket** - Session replay
- **DataDog** - APM & logs
- **New Relic** - Performance monitoring

### Setup Sentry (Example)

```typescript
import * as Sentry from "@sentry/node";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
});
```

### Health Checks

```typescript
// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});
```

---

## 🔄 Pre-commit Hooks

### Setup Husky

```bash
# Install husky
npm install --save-dev husky

# Initialize
npx husky install

# Add pre-commit hook
npx husky add .husky/pre-commit "npm run lint-staged"
```

### Lint-Staged

**Configuration in package.json:**
```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md}": [
      "prettier --write"
    ]
  }
}
```

**What it does:**
- Runs linter on staged files
- Formats code automatically
- Prevents bad code from being committed

---

## 📦 Build & Deploy

### Build Process

```bash
# Development build
npm run dev

# Production build
npm run build

# Preview production build
npm run preview
```

### Deployment Options

#### 1. Vercel (Recommended for Next.js)
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Production deploy
vercel --prod
```

#### 2. Railway
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Deploy
railway up
```

#### 3. Docker
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
CMD ["npm", "start"]
```

---

## 🎯 Automation Scripts

### Custom Scripts

**Location:** `scripts/automation/`

#### 1. Auto-update Dependencies
```bash
#!/bin/bash
# scripts/automation/update-deps.sh

npm update
npm audit fix
git add package*.json
git commit -m "chore: update dependencies"
```

#### 2. Generate Changelog
```bash
#!/bin/bash
# scripts/automation/changelog.sh

git log --oneline --decorate > CHANGELOG.txt
```

#### 3. Backup Workspace
```bash
#!/bin/bash
# scripts/automation/backup.sh

DATE=$(date +%Y-%m-%d)
tar -czf "backup-$DATE.tar.gz" \
  .ai/ docs/ scripts/ skills/ \
  --exclude=node_modules
```

---

## 📈 Performance Monitoring

### Metrics to Track

1. **Build Time** - Should be < 5 minutes
2. **Test Time** - Should be < 2 minutes
3. **Deploy Time** - Should be < 3 minutes
4. **Code Coverage** - Should be > 80%

### Monitoring Dashboard

```bash
# View GitHub Actions metrics
# Go to: https://github.com/<user>/<repo>/actions

# View test coverage
# After running: npm run test:coverage
# Open: coverage/index.html
```

---

## 🔧 Troubleshooting

### CI/CD Fails

**1. Lint Errors**
```bash
# Fix locally
npm run lint:fix
git add .
git commit -m "fix: lint errors"
git push
```

**2. Test Failures**
```bash
# Run tests locally
npm test

# Debug specific test
npm test -- tests/specific.test.ts
```

**3. Build Errors**
```bash
# Clean and rebuild
rm -rf node_modules dist
npm install
npm run build
```

### Common Issues

**Issue:** "Module not found"
**Fix:** `npm install` or check imports

**Issue:** "Type error"
**Fix:** `npm run typecheck` and fix types

**Issue:** "Tests timeout"
**Fix:** Increase timeout in vitest.config.ts

---

## ✅ Checklist: Setup CI/CD

- [x] Create `.github/workflows/ci-cd.yml`
- [x] Add `package.json` with scripts
- [x] Configure Vitest
- [x] Write initial tests
- [ ] Setup Snyk (requires account)
- [ ] Setup Husky pre-commit hooks
- [ ] Configure deployment target
- [ ] Add monitoring (Sentry, etc.)
- [ ] Document deployment process

---

## 📚 Resources

- **GitHub Actions:** https://docs.github.com/actions
- **Vitest:** https://vitest.dev
- **ESLint:** https://eslint.org
- **Prettier:** https://prettier.io
- **Snyk:** https://snyk.io
- **Husky:** https://typicode.github.io/husky

---

**Version:** 1.0.0
**Last Updated:** 2026-03-23
**Status:** Active
**Owner:** Zahra Maurita
