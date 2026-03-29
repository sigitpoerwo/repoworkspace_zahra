# Security Best Practices Guide

## 🛡️ Overview

Comprehensive security guide untuk Zahra Workspace - protecting code, data, dan credentials.

---

## 🔐 Secrets Management

### Environment Variables

**✅ DO:**
```bash
# .env file (local only, in .gitignore)
GITHUB_TOKEN=ghp_xxxxx
OPENAI_API_KEY=sk-xxxxx
DATABASE_URL=postgresql://xxxxx
```

**❌ DON'T:**
```typescript
// NEVER hardcode secrets
const apiKey = "sk-xxxxx"; // ❌ BAD
const token = "ghp_xxxxx"; // ❌ BAD
```

**✅ Correct Usage:**
```typescript
// Read from environment
const apiKey = process.env.OPENAI_API_KEY;
if (!apiKey) {
  throw new Error('OPENAI_API_KEY not set');
}
```

### GitHub Secrets (for CI/CD)

**Setup:**
1. Go to: `https://github.com/<user>/<repo>/settings/secrets/actions`
2. Click "New repository secret"
3. Name: `OPENAI_API_KEY`
4. Value: `sk-xxxxx`
5. Click "Add secret"

**Usage in GitHub Actions:**
```yaml
jobs:
  deploy:
    steps:
      - name: Deploy
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: npm run deploy
```

---

## 🔍 Automated Security Scanning

### 1. Snyk (Dependency Vulnerabilities)

**Setup:**
```bash
# Install Snyk CLI
npm install -g snyk

# Authenticate
snyk auth

# Test project
snyk test

# Monitor project
snyk monitor
```

**GitHub Integration:**
- Already configured in [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml:1)
- Runs on every push
- Requires `SNYK_TOKEN` in GitHub Secrets

### 2. npm audit (Built-in)

**Usage:**
```bash
# Check vulnerabilities
npm audit

# Fix automatically
npm audit fix

# Force fix (may break)
npm audit fix --force

# View detailed report
npm audit --json
```

**Automated in CI/CD:**
- Runs on every push
- Fails build if high/critical vulnerabilities found

### 3. Dependabot (GitHub)

**Setup:**
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
```

**What it does:**
- Auto-detects vulnerable dependencies
- Creates PRs to update them
- Keeps dependencies up-to-date

---

## 🚨 Pre-commit Security Checks

### Git Secrets Scanner

**Install:**
```bash
# macOS
brew install git-secrets

# Linux
git clone https://github.com/awslabs/git-secrets
cd git-secrets
make install
```

**Setup:**
```bash
# Initialize in repo
git secrets --install

# Add patterns to detect
git secrets --register-aws
git secrets --add 'ghp_[0-9a-zA-Z]{36}'
git secrets --add 'sk-[0-9a-zA-Z]{48}'
git secrets --add 'api[_-]?key'
```

### Custom Pre-commit Hook

**Create:** `.husky/pre-commit`
```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

echo "🔍 Checking for secrets..."

# Check for common secret patterns
if git diff --cached | grep -E "(ghp_|github_pat_|glpat-|sk-|pk_|api_key|password|secret)"; then
  echo "❌ Potential secret detected!"
  echo "Please remove secrets before committing."
  exit 1
fi

echo "✅ No secrets detected"
```

---

## 🔒 Code Security

### Input Validation

**✅ DO:**
```typescript
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  age: z.number().min(0).max(120),
});

function createUser(input: unknown) {
  const validated = userSchema.parse(input);
  // Safe to use validated data
}
```

**❌ DON'T:**
```typescript
function createUser(input: any) {
  // No validation - unsafe!
  db.insert(input);
}
```

### SQL Injection Prevention

**✅ DO (Parameterized Queries):**
```typescript
// Using Prisma (safe)
const user = await prisma.user.findUnique({
  where: { email: userEmail }
});

// Using raw SQL with parameters (safe)
const user = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [userEmail]
);
```

**❌ DON'T (String Concatenation):**
```typescript
// NEVER do this - SQL injection risk!
const query = `SELECT * FROM users WHERE email = '${userEmail}'`;
```

### XSS Prevention

**✅ DO:**
```typescript
// React auto-escapes by default
<div>{userInput}</div>

// Sanitize HTML if needed
import DOMPurify from 'dompurify';
const clean = DOMPurify.sanitize(dirtyHTML);
```

**❌ DON'T:**
```typescript
// Dangerous - XSS risk!
<div dangerouslySetInnerHTML={{__html: userInput}} />
```

---

## 🌐 API Security

### Rate Limiting

**Using Rate Limiter:**
```typescript
import { RateLimiter } from './scripts/rate-limiter';

const limiter = new RateLimiter({
  maxCallsPerHour: 100,
  stateFile: './data/rate-limit.json'
});

async function apiCall() {
  const check = limiter.checkLimit();
  if (!check.allowed) {
    throw new Error(check.reason);
  }
  
  // Make API call
  const result = await fetch(url);
  
  // Increment counter
  limiter.incrementCalls(1);
  
  return result;
}
```

### Authentication

**JWT Example:**
```typescript
import jwt from 'jsonwebtoken';

// Generate token
const token = jwt.sign(
  { userId: user.id },
  process.env.JWT_SECRET!,
  { expiresIn: '1h' }
);

// Verify token
const decoded = jwt.verify(
  token,
  process.env.JWT_SECRET!
);
```

### CORS Configuration

```typescript
// Express example
import cors from 'cors';

app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(','),
  credentials: true,
  maxAge: 86400,
}));
```

---

## 📁 File Security

### Using File Access Guard

```typescript
import { FileAccessGuard } from './scripts/file-access-guard';

const guard = new FileAccessGuard({
  mode: 'workspace_only',
  workspaceDir: './workspace',
  dataDir: './data',
});

async function readFileSafely(path: string) {
  // Check permission
  const check = await guard.isPathAllowed(path);
  if (!check.allowed) {
    throw new Error(`Access denied: ${check.reason}`);
  }
  
  // Safe to read
  return fs.readFileSync(path, 'utf-8');
}
```

### File Upload Security

```typescript
// Validate file type
const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
if (!allowedTypes.includes(file.mimetype)) {
  throw new Error('Invalid file type');
}

// Validate file size (10MB max)
const maxSize = 10 * 1024 * 1024;
if (file.size > maxSize) {
  throw new Error('File too large');
}

// Sanitize filename
const sanitized = file.originalname
  .replace(/[^a-zA-Z0-9.-]/g, '_')
  .substring(0, 255);
```

---

## 🔐 Password Security

### Hashing

```typescript
import bcrypt from 'bcrypt';

// Hash password
const saltRounds = 10;
const hashedPassword = await bcrypt.hash(password, saltRounds);

// Verify password
const isValid = await bcrypt.compare(password, hashedPassword);
```

### Password Requirements

```typescript
const passwordSchema = z.string()
  .min(8, 'Password must be at least 8 characters')
  .regex(/[A-Z]/, 'Password must contain uppercase letter')
  .regex(/[a-z]/, 'Password must contain lowercase letter')
  .regex(/[0-9]/, 'Password must contain number')
  .regex(/[^A-Za-z0-9]/, 'Password must contain special character');
```

---

## 📊 Security Monitoring

### Logging

```typescript
// Log security events
function logSecurityEvent(event: string, details: any) {
  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    event,
    details,
    severity: 'security',
  }));
}

// Example usage
logSecurityEvent('failed_login', {
  email: user.email,
  ip: req.ip,
});
```

### Error Handling

**✅ DO:**
```typescript
try {
  await sensitiveOperation();
} catch (error) {
  // Log detailed error internally
  logger.error('Operation failed', { error, userId });
  
  // Return generic message to user
  res.status(500).json({
    error: 'Operation failed. Please try again.'
  });
}
```

**❌ DON'T:**
```typescript
try {
  await sensitiveOperation();
} catch (error) {
  // Exposes internal details!
  res.status(500).json({ error: error.message });
}
```

---

## ✅ Security Checklist

### Before Deployment

- [ ] All secrets in environment variables
- [ ] `.env` in `.gitignore`
- [ ] No hardcoded credentials
- [ ] Input validation implemented
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Rate limiting active
- [ ] HTTPS enforced
- [ ] Security headers configured
- [ ] Dependencies updated
- [ ] npm audit passing
- [ ] Snyk scan passing
- [ ] Error messages sanitized
- [ ] Logging configured
- [ ] Monitoring active

### Regular Maintenance

- [ ] Weekly: npm audit
- [ ] Weekly: Dependency updates
- [ ] Monthly: Security review
- [ ] Monthly: Rotate secrets
- [ ] Quarterly: Penetration testing
- [ ] Yearly: Security audit

---

## 🚨 Incident Response

### If Secret Exposed

1. **Revoke immediately**
2. **Generate new secret**
3. **Update all usages**
4. **Check audit logs**
5. **Document incident**
6. **Review prevention measures**

### If Breach Detected

1. **Isolate affected systems**
2. **Assess damage**
3. **Notify stakeholders**
4. **Fix vulnerability**
5. **Deploy patches**
6. **Monitor for recurrence**
7. **Post-mortem analysis**

---

## 📚 Resources

- **OWASP Top 10:** https://owasp.org/www-project-top-ten/
- **Snyk:** https://snyk.io
- **npm audit:** https://docs.npmjs.com/cli/v8/commands/npm-audit
- **Git Secrets:** https://github.com/awslabs/git-secrets
- **Security Headers:** https://securityheaders.com

---

**Version:** 1.0.0
**Last Updated:** 2026-03-23
**Status:** Active
**Owner:** Zahra Maurita
