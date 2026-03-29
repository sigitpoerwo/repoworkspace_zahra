# 🔒 OWASP Top 10 (2021) - Complete Implementation Guide

**Created:** 2026-03-25
**Status:** Active Security Framework
**Scope:** All Zahra Workspace Projects

---

## 📋 Quick Reference

| # | Vulnerability | Severity | Status |
|---|---------------|----------|--------|
| A01 | Broken Access Control | 🔴 CRITICAL | ⏳ In Progress |
| A02 | Cryptographic Failures | 🔴 CRITICAL | ⏳ In Progress |
| A03 | Injection | 🔴 CRITICAL | ⏳ In Progress |
| A04 | Insecure Design | 🟡 HIGH | ⏳ In Progress |
| A05 | Security Misconfiguration | 🟡 HIGH | ⏳ In Progress |
| A06 | Vulnerable Components | 🟡 HIGH | ⏳ In Progress |
| A07 | Auth Failures | 🔴 CRITICAL | ⏳ In Progress |
| A08 | Data Integrity Failures | 🟢 MEDIUM | ⏳ In Progress |
| A09 | Logging Failures | 🟢 MEDIUM | ⏳ In Progress |
| A10 | SSRF | 🟢 MEDIUM | ⏳ In Progress |

---

## 🎯 A01:2021 – Broken Access Control

### What is it?
Users dapat mengakses data/fungsi yang tidak seharusnya mereka akses.

### Common Attacks
- URL manipulation: `/api/users/123` → `/api/users/456`
- Privilege escalation: User biasa jadi admin
- IDOR (Insecure Direct Object Reference)
- CORS misconfiguration

### ❌ Vulnerable Code

```typescript
// No access control - ANYONE can access ANY user data
app.get('/api/users/:id', async (req, res) => {
  const user = await db.user.findUnique({
    where: { id: req.params.id }
  })
  res.json(user)
})

// No role check - ANY logged in user can delete
app.delete('/api/users/:id', authenticateUser, async (req, res) => {
  await db.user.delete({ where: { id: req.params.id } })
  res.json({ success: true })
})
```

### ✅ Secure Code

```typescript
// Middleware untuk authentication
function authenticateUser(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1]

  if (!token) {
    return res.status(401).json({ error: 'Authentication required' })
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET!)
    req.user = decoded
    next()
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' })
  }
}

// Middleware untuk authorization
function requireRole(role: string) {
  return (req, res, next) => {
    if (req.user.role !== role) {
      return res.status(403).json({ error: 'Insufficient permissions' })
    }
    next()
  }
}

// Protected endpoint - users can only access their own data
app.get('/api/users/:id', authenticateUser, async (req, res) => {
  const requestedUserId = req.params.id
  const currentUserId = req.user.id

  // Check ownership or admin
  if (requestedUserId !== currentUserId && req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Access denied' })
  }

  const user = await db.user.findUnique({
    where: { id: requestedUserId },
    select: { id: true, email: true, name: true } // Don't expose password
  })

  if (!user) {
    return res.status(404).json({ error: 'User not found' })
  }

  res.json(user)
})

// Admin-only endpoint
app.delete('/api/users/:id', authenticateUser, requireRole('admin'), async (req, res) => {
  await db.user.delete({ where: { id: req.params.id } })
  res.json({ success: true })
})
```

### 🛡️ Protection Checklist

- [ ] Implement authentication on all protected routes
- [ ] Implement authorization (role-based access control)
- [ ] Validate user ownership before data access
- [ ] Use middleware for consistent access control
- [ ] Deny by default (whitelist approach)
- [ ] Log access control failures
- [ ] Test with different user roles

---

## 🔐 A02:2021 – Cryptographic Failures

### What is it?
Data sensitif terekspos karena enkripsi lemah atau tidak ada.

### Common Issues
- HTTP instead of HTTPS
- Weak hashing (MD5, SHA1)
- Hardcoded secrets
- Plain text passwords
- Weak encryption algorithms

### ❌ Vulnerable Code

```typescript
// Plain text password - NEVER DO THIS
const user = await db.user.create({
  data: {
    email: req.body.email,
    password: req.body.password // ❌ Plain text!
  }
})

// Hardcoded secret - NEVER DO THIS
const JWT_SECRET = 'my-secret-key-123' // ❌ Exposed in code!

// Weak hashing - NEVER DO THIS
import crypto from 'crypto'
const hash = crypto.createHash('md5').update(password).digest('hex') // ❌ MD5 is broken!
```

### ✅ Secure Code

```typescript
import bcrypt from 'bcrypt'

// Hash password with bcrypt (cost factor 10)
const SALT_ROUNDS = 10
const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS)

const user = await db.user.create({
  data: {
    email: req.body.email,
    password: hashedPassword // ✅ Hashed!
  }
})

// Verify password
const isValid = await bcrypt.compare(inputPassword, user.password)

// Use environment variables for secrets
const JWT_SECRET = process.env.JWT_SECRET
if (!JWT_SECRET) {
  throw new Error('JWT_SECRET environment variable not set')
}

// Generate secure random tokens
import crypto from 'crypto'
const resetToken = crypto.randomBytes(32).toString('hex')

// Encrypt sensitive data at rest (AES-256)
import { createCipheriv, createDecipheriv, randomBytes } from 'crypto'

function encrypt(text: string, key: Buffer): string {
  const iv = randomBytes(16)
  const cipher = createCipheriv('aes-256-cbc', key, iv)
  let encrypted = cipher.update(text, 'utf8', 'hex')
  encrypted += cipher.final('hex')
  return iv.toString('hex') + ':' + encrypted
}

function decrypt(text: string, key: Buffer): string {
  const parts = text.split(':')
  const iv = Buffer.from(parts[0], 'hex')
  const encrypted = parts[1]
  const decipher = createDecipheriv('aes-256-cbc', key, iv)
  let decrypted = decipher.update(encrypted, 'hex', 'utf8')
  decrypted += decipher.final('utf8')
  return decrypted
}
```

### 🛡️ Protection Checklist

- [ ] Use HTTPS everywhere (enforce with HSTS header)
- [ ] Hash passwords with bcrypt (cost factor 10+)
- [ ] Store secrets in environment variables
- [ ] Use strong encryption (AES-256)
- [ ] Use secure random generators (crypto.randomBytes)
- [ ] Encrypt sensitive data at rest
- [ ] Implement proper key management
- [ ] Never commit secrets to git

---

## 💉 A03:2021 – Injection

### What is it?
Attacker dapat inject malicious code (SQL, NoSQL, OS commands).

### Common Types
- SQL Injection
- NoSQL Injection
- Command Injection
- LDAP Injection
- XPath Injection

### ❌ Vulnerable Code

```typescript
// SQL Injection - NEVER DO THIS
const email = req.body.email
const query = `SELECT * FROM users WHERE email = '${email}'`
const user = await db.$queryRaw(query) // ❌ Vulnerable!

// Command Injection - NEVER DO THIS
const filename = req.body.filename
exec(`cat ${filename}`, (error, stdout) => { // ❌ Vulnerable!
  res.send(stdout)
})

// NoSQL Injection - NEVER DO THIS
const user = await db.user.findOne({
  email: req.body.email, // ❌ If email is an object, can bypass
  password: req.body.password
})
```

### ✅ Secure Code

```typescript
// Use ORM with parameterized queries
const email = req.body.email
const user = await db.user.findUnique({
  where: { email } // ✅ Safe - Prisma handles escaping
})

// If you must use raw SQL, use parameters
const user = await db.$queryRaw`
  SELECT * FROM users WHERE email = ${email}
` // ✅ Safe - parameterized

// Validate input with whitelist
const filename = req.body.filename
const allowedFiles = ['file1.txt', 'file2.txt', 'file3.txt']

if (!allowedFiles.includes(filename)) {
  return res.status(400).json({ error: 'Invalid filename' })
}

// Use safe file reading (no shell execution)
import { readFile } from 'fs/promises'
import path from 'path'

const SAFE_DIR = '/app/data'
const safePath = path.join(SAFE_DIR, filename)

// Prevent path traversal
if (!safePath.startsWith(SAFE_DIR)) {
  return res.status(400).json({ error: 'Invalid path' })
}

const content = await readFile(safePath, 'utf-8')
res.send(content)

// Validate input types
import { z } from 'zod'

const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

const validated = userSchema.parse(req.body) // ✅ Type-safe
```

### 🛡️ Protection Checklist

- [ ] Use ORM/ODM (Prisma, Mongoose)
- [ ] Use parameterized queries
- [ ] Validate all user input
- [ ] Use whitelist validation
- [ ] Escape special characters
- [ ] Never execute shell commands with user input
- [ ] Use prepared statements
- [ ] Limit database privileges

---

## 🏗️ A04:2021 – Insecure Design

### What is it?
Fundamental design flaws yang tidak bisa diperbaiki dengan implementation.

### Common Issues
- No threat modeling
- Missing security requirements
- No rate limiting
- No input validation at design level
- Insecure design patterns

### ✅ Secure Design Patterns

```typescript
// Rate limiting (prevent brute force)
import rateLimit from 'express-rate-limit'

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts per window
  message: 'Too many login attempts, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
})

app.post('/api/login', loginLimiter, async (req, res) => {
  // Login logic
})

// Account lockout after failed attempts
const MAX_ATTEMPTS = 5
const LOCKOUT_TIME = 15 * 60 * 1000 // 15 minutes

async function checkLoginAttempts(email: string) {
  const key = `login_attempts:${email}`
  const attempts = await redis.get(key)

  if (attempts && parseInt(attempts) >= MAX_ATTEMPTS) {
    const ttl = await redis.ttl(key)
    throw new Error(`Account locked. Try again in ${Math.ceil(ttl / 60)} minutes`)
  }
}

async function recordFailedLogin(email: string) {
  const key = `login_attempts:${email}`
  await redis.incr(key)
  await redis.expire(key, LOCKOUT_TIME / 1000)
}

async function clearLoginAttempts(email: string) {
  await redis.del(`login_attempts:${email}`)
}

// Generic error messages (don't reveal if email exists)
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body

  try {
    await checkLoginAttempts(email)

    const user = await db.user.findUnique({ where: { email } })

    if (!user || !await bcrypt.compare(password, user.password)) {
      await recordFailedLogin(email)
      // Generic message - don't reveal if email exists
      return res.status(401).json({ error: 'Invalid credentials' })
    }

    await clearLoginAttempts(email)
    const token = generateToken(user)
    res.json({ token })

  } catch (error) {
    res.status(429).json({ error: error.message })
  }
})
```

### 🛡️ Protection Checklist

- [ ] Perform threat modeling
- [ ] Define security requirements early
- [ ] Implement rate limiting
- [ ] Implement account lockout
- [ ] Use generic error messages
- [ ] Implement defense in depth
- [ ] Fail securely (deny by default)
- [ ] Separate sensitive operations

---

## ⚙️ A05:2021 – Security Misconfiguration

### What is it?
Default configurations, incomplete setups, exposed error messages.

### Common Issues
- Default credentials
- Unnecessary features enabled
- Detailed error messages
- Missing security headers
- Outdated software

### ✅ Secure Configuration

```typescript
import helmet from 'helmet'
import express from 'express'

const app = express()

// Security headers
app.use(helmet())

// Additional security headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff')
  res.setHeader('X-Frame-Options', 'DENY')
  res.setHeader('X-XSS-Protection', '1; mode=block')
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains')
  res.setHeader('Content-Security-Policy', "default-src 'self'")
  next()
})

// Hide server information
app.disable('x-powered-by')

// Generic error handler
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
  // Log detailed error internally
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    timestamp: new Date().toISOString()
  })

  // Send generic message to user
  res.status(500).json({
    error: 'Internal server error',
    requestId: req.id // For support reference
  })
})

// Secure CORS configuration
import cors from 'cors'

app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [],
  credentials: true,
  maxAge: 86400,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}))

// Environment-specific configuration
const config = {
  development: {
    logLevel: 'debug',
    corsOrigin: '*'
  },
  production: {
    logLevel: 'error',
    corsOrigin: process.env.ALLOWED_ORIGINS
  }
}

const env = process.env.NODE_ENV || 'development'
const appConfig = config[env]
```

### 🛡️ Protection Checklist

- [ ] Remove default credentials
- [ ] Disable unnecessary features
- [ ] Use security headers (helmet.js)
- [ ] Hide server version
- [ ] Generic error messages to users
- [ ] Keep dependencies updated
- [ ] Secure CORS configuration
- [ ] Environment-specific configs

---

## 📦 A06:2021 – Vulnerable Components

### What is it?
Using libraries dengan known vulnerabilities.

### ✅ Dependency Management

```bash
# Regular security audits
npm audit
npm audit fix

# Automated scanning
npm install -g snyk
snyk test
snyk monitor

# Keep dependencies updated
npm outdated
npm update

# Check for specific vulnerabilities
npm audit --json | jq '.vulnerabilities'
```

### GitHub Actions CI/CD

```yaml
# .github/workflows/security.yml
name: Security Scan

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run npm audit
        run: npm audit --audit-level=high

      - name: Run Snyk
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

### 🛡️ Protection Checklist

- [ ] Run `npm audit` regularly
- [ ] Use Dependabot/Renovate
- [ ] Monitor CVE databases
- [ ] Remove unused dependencies
- [ ] Use lock files (package-lock.json)
- [ ] Scan containers for vulnerabilities
- [ ] Subscribe to security advisories

---

## 🔑 A07:2021 – Authentication Failures

### What is it?
Weak authentication memungkinkan attacker mengambil alih akun.

### ✅ Strong Authentication

```typescript
import bcrypt from 'bcrypt'
import validator from 'validator'

// Strong password validation
const passwordRequirements = {
  minLength: 12,
  minLowercase: 1,
  minUppercase: 1,
  minNumbers: 1,
  minSymbols: 1
}

function validatePassword(password: string): boolean {
  return validator.isStrongPassword(password, passwordRequirements)
}

// Secure session management
import session from 'express-session'
import RedisStore from 'connect-redis'
import { createClient } from 'redis'

const redisClient = createClient()

app.use(session({
  store: new RedisStore({ client: redisClient }),
  secret: process.env.SESSION_SECRET!,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: true, // HTTPS only
    httpOnly: true, // No JavaScript access
    maxAge: 1000 * 60 * 60 * 24, // 24 hours
    sameSite: 'strict' // CSRF protection
  }
}))

// Multi-factor authentication (TOTP)
import speakeasy from 'speakeasy'

// Generate MFA secret
const secret = speakeasy.generateSecret({ name: 'MyApp' })

// Verify TOTP token
const verified = speakeasy.totp.verify({
  secret: user.mfaSecret,
  encoding: 'base32',
  token: req.body.token,
  window: 2 // Allow 2 time steps
})
```

### 🛡️ Protection Checklist

- [ ] Strong password requirements (12+ chars)
- [ ] Implement account lockout
- [ ] Use MFA (2FA/TOTP)
- [ ] Secure session management
- [ ] Implement CAPTCHA
- [ ] Secure password reset flow
- [ ] Log authentication events
- [ ] Use secure password hashing (bcrypt)

---

## 📝 A08:2021 – Data Integrity Failures

### What is it?
Code/data integrity tidak terverifikasi.

### ✅ Integrity Verification

```typescript
// Verify webhook signatures
import crypto from 'crypto'

function verifyWebhookSignature(
  payload: string,
  signature: string,
  secret: string
): boolean {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex')

  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expectedSignature)
  )
}

// Subresource Integrity for CDN
const script = `
<script
  src="https://cdn.example.com/library.js"
  integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"
  crossorigin="anonymous"
></script>
`

// Use package lock files
// npm ci (instead of npm install) verifies integrity
```

### 🛡️ Protection Checklist

- [ ] Use package lock files
- [ ] Verify package signatures
- [ ] Implement code review
- [ ] Secure CI/CD pipeline
- [ ] Use SRI for CDN resources
- [ ] Verify webhook signatures
- [ ] Implement digital signatures

---

## 📊 A09:2021 – Logging Failures

### What is it?
Tidak bisa detect, escalate, atau respond terhadap breaches.

### ✅ Security Logging

```typescript
import winston from 'winston'

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'security.log', level: 'warn' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
})

// Log security events
function logSecurityEvent(event: string, details: any) {
  logger.warn('Security Event', {
    event,
    timestamp: new Date().toISOString(),
    ip: details.ip,
    userId: details.userId,
    userAgent: details.userAgent,
    ...details
  })
}

// Events to log
const SECURITY_EVENTS = {
  LOGIN_SUCCESS: 'LOGIN_SUCCESS',
  LOGIN_FAILED: 'LOGIN_FAILED',
  ACCESS_DENIED: 'ACCESS_DENIED',
  PRIVILEGE_ESCALATION: 'PRIVILEGE_ESCALATION',
  PASSWORD_RESET: 'PASSWORD_RESET',
  ACCOUNT_LOCKED: 'ACCOUNT_LOCKED',
  SUSPICIOUS_ACTIVITY: 'SUSPICIOUS_ACTIVITY'
}

// Usage
app.post('/api/login', async (req, res) => {
  try {
    const user = await authenticateUser(req.body.email, req.body.password)

    logSecurityEvent(SECURITY_EVENTS.LOGIN_SUCCESS, {
      ip: req.ip,
      userId: user.id,
      userAgent: req.get('user-agent')
    })

    res.json({ token: generateToken(user) })
  } catch (error) {
    logSecurityEvent(SECURITY_EVENTS.LOGIN_FAILED, {
      ip: req.ip,
      email: req.body.email,
      userAgent: req.get('user-agent'),
      reason: error.message
    })

    res.status(401).json({ error: 'Invalid credentials' })
  }
})
```

### 🛡️ Protection Checklist

- [ ] Log all security events
- [ ] Use structured logging (JSON)
- [ ] Centralized log management
- [ ] Real-time monitoring
- [ ] Automated alerting
- [ ] Log retention policy
- [ ] Protect logs from tampering

---

## 🌐 A10:2021 – SSRF

### What is it?
Attacker dapat memaksa server untuk request ke internal/external resources.

### ✅ SSRF Protection

```typescript
import { URL } from 'url'
import dns from 'dns/promises'

const ALLOWED_DOMAINS = ['api.example.com', 'cdn.example.com']
const BLOCKED_IPS = [
  '127.0.0.1',
  '0.0.0.0',
  '169.254.169.254', // AWS metadata
  '::1',
  'localhost'
]

async function isUrlSafe(urlString: string): Promise<boolean> {
  try {
    const url = new URL(urlString)

    // Only allow HTTPS
    if (url.protocol !== 'https:') {
      return false
    }

    // Whitelist domains
    if (!ALLOWED_DOMAINS.includes(url.hostname)) {
      return false
    }

    // Resolve and check IP
    const ips = await dns.resolve4(url.hostname)

    for (const ip of ips) {
      if (BLOCKED_IPS.includes(ip) || isPrivateIP(ip)) {
        return false
      }
    }

    return true
  } catch (error) {
    return false
  }
}

function isPrivateIP(ip: string): boolean {
  const parts = ip.split('.').map(Number)

  // 10.0.0.0/8
  if (parts[0] === 10) return true

  // 172.16.0.0/12
  if (parts[0] === 172 && parts[1] >= 16 && parts[1] <= 31) return true

  // 192.168.0.0/16
  if (parts[0] === 192 && parts[1] === 168) return true

  return false
}

app.post('/api/fetch', async (req, res) => {
  const { url } = req.body

  if (!await isUrlSafe(url)) {
    return res.status(400).json({ error: 'Invalid URL' })
  }

  const response = await fetch(url, {
    timeout: 5000,
    redirect: 'manual' // Don't follow redirects
  })

  const data = await response.text()
  res.send(data)
})
```

### 🛡️ Protection Checklist

- [ ] Whitelist allowed domains
- [ ] Block private IP ranges
- [ ] Disable redirects
- [ ] Use network segmentation
- [ ] Validate URL scheme (HTTPS only)
- [ ] Implement timeouts
- [ ] Block cloud metadata endpoints

---

## ✅ Security Audit Checklist

### Pre-Deployment

- [ ] All OWASP Top 10 vulnerabilities addressed
- [ ] Security headers configured
- [ ] HTTPS enforced
- [ ] Secrets in environment variables
- [ ] Input validation implemented
- [ ] Authentication & authorization working
- [ ] Rate limiting active
- [ ] Logging configured
- [ ] Dependencies updated
- [ ] npm audit passing

### Regular Maintenance

- [ ] Weekly: npm audit
- [ ] Weekly: Dependency updates
- [ ] Monthly: Security review
- [ ] Monthly: Rotate secrets
- [ ] Quarterly: Penetration testing
- [ ] Yearly: Full security audit

---

**Last Updated:** 2026-03-25
**Next Review:** 2026-04-25
**Status:** Active Implementation ✅
