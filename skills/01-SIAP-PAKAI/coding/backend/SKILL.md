---
name: Backend
description: Build reliable backend services with proper error handling, security, and observability.
metadata: {"clawdbot":{"emoji":"⚙️","os":["linux","darwin","win32"]}}
---

## Error Handling

- Never expose stack traces to clients—log internally, return generic message
- Structured error responses: code, message, request ID—enables debugging without leaking
- Fail fast on bad input—validate at entry point, not deep in business logic
- Unexpected errors: 500 + alert—expected errors: appropriate 4xx

### Examples

**Node.js/Express:**
```javascript
// Error handler middleware
app.use((err, req, res, next) => {
  const requestId = req.id || uuid();
  
  // Log full error internally
  logger.error({
    requestId,
    error: err.message,
    stack: err.stack,
    path: req.path
  });
  
  // Return safe error to client
  res.status(err.statusCode || 500).json({
    error: {
      code: err.code || 'INTERNAL_ERROR',
      message: err.statusCode < 500 ? err.message : 'Internal server error',
      requestId
    }
  });
});
```

**Python/FastAPI:**
```python
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import logging

app = FastAPI()

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
    
    # Log full error
    logging.error(f"Request {request_id} failed: {exc}", exc_info=True)
    
    # Return safe error
    return JSONResponse(
        status_code=500,
        content={
            "error": {
                "code": "INTERNAL_ERROR",
                "message": "Internal server error",
                "requestId": request_id
            }
        }
    )
```

---

## Input Validation

- Validate everything from outside—query params, headers, body, path params
- Whitelist valid input, don't blacklist bad—reject unknown fields
- Validate early, before any processing—save resources, clearer errors
- Size limits on all inputs—prevent memory exhaustion attacks

### Examples

**Zod (TypeScript):**
```typescript
import { z } from 'zod';

const createUserSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(8).max(100),
  age: z.number().int().min(18).max(120),
  role: z.enum(['user', 'admin']).default('user')
}).strict(); // Reject unknown fields

app.post('/users', async (req, res) => {
  try {
    const data = createUserSchema.parse(req.body);
    const user = await createUser(data);
    res.status(201).json(user);
  } catch (err) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid input',
          details: err.errors
        }
      });
    }
    throw err;
  }
});
```

**Pydantic (Python):**
```python
from pydantic import BaseModel, EmailStr, Field, validator

class CreateUserRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=100)
    age: int = Field(ge=18, le=120)
    role: str = Field(default="user", pattern="^(user|admin)$")
    
    class Config:
        extra = "forbid"  # Reject unknown fields

@app.post("/users")
async def create_user(data: CreateUserRequest):
    user = await create_user_service(data)
    return user
```

---

## Timeouts Everywhere

- Database queries: set timeout, typically 5-30s
- External HTTP calls: connect timeout + read timeout—don't wait forever
- Overall request timeout—gateway or middleware level
- Background jobs: max execution time—prevent zombie processes

### Examples

**Database Timeout (Prisma):**
```typescript
const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL
    }
  }
});

// Query with timeout
const users = await prisma.$queryRaw`
  SELECT * FROM users WHERE active = true
`.timeout(5000); // 5 second timeout
```

**HTTP Timeout (Axios):**
```typescript
import axios from 'axios';

const api = axios.create({
  timeout: 10000, // 10 seconds total
  timeoutErrorMessage: 'Request timeout'
});

// With retry
import axiosRetry from 'axios-retry';
axiosRetry(api, {
  retries: 3,
  retryDelay: axiosRetry.exponentialDelay
});
```

**Request Timeout (Express):**
```typescript
import timeout from 'connect-timeout';

app.use(timeout('30s'));
app.use((req, res, next) => {
  if (!req.timedout) next();
});
```

---

## Retry Patterns

- Exponential backoff: 1s, 2s, 4s, 8s...—prevents thundering herd
- Add jitter: randomize delay—prevents synchronized retries
- Idempotency keys for non-idempotent operations—safe to retry
- Circuit breaker for failing dependencies—stop hammering, fail fast

### Examples

**Exponential Backoff with Jitter:**
```typescript
async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  maxRetries = 3,
  baseDelay = 1000
): Promise<T> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (err) {
      if (i === maxRetries - 1) throw err;
      
      // Exponential backoff with jitter
      const delay = baseDelay * Math.pow(2, i);
      const jitter = Math.random() * delay * 0.1;
      await sleep(delay + jitter);
    }
  }
  throw new Error('Max retries exceeded');
}

// Usage
const data = await retryWithBackoff(() => 
  fetch('https://api.example.com/data')
);
```

**Circuit Breaker (opossum):**
```typescript
import CircuitBreaker from 'opossum';

const options = {
  timeout: 3000,
  errorThresholdPercentage: 50,
  resetTimeout: 30000
};

const breaker = new CircuitBreaker(fetchExternalAPI, options);

breaker.fallback(() => ({ cached: true, data: [] }));

breaker.on('open', () => {
  logger.warn('Circuit breaker opened');
});

// Usage
const result = await breaker.fire(params);
```

---

## Database Practices

- Connection pooling: reuse connections—creating is expensive
- Transactions scoped minimal—hold locks briefly
- Read replicas for read-heavy workloads—separate read/write traffic
- Prepared statements always—SQL injection prevention, query plan cache

### Examples

**Connection Pool (PostgreSQL):**
```typescript
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20, // Max connections
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000
});

// Use connection
const client = await pool.connect();
try {
  const result = await client.query('SELECT * FROM users WHERE id = $1', [userId]);
  return result.rows[0];
} finally {
  client.release();
}
```

**Transaction (Prisma):**
```typescript
// Good: Minimal transaction scope
await prisma.$transaction(async (tx) => {
  const user = await tx.user.create({ data: userData });
  await tx.profile.create({ data: { userId: user.id, ...profileData } });
  return user;
});

// Bad: Long-running transaction
await prisma.$transaction(async (tx) => {
  const user = await tx.user.create({ data: userData });
  await sendWelcomeEmail(user.email); // ❌ External call in transaction
  return user;
});
```

**Read Replica:**
```typescript
const readPool = new Pool({ host: 'read-replica.example.com' });
const writePool = new Pool({ host: 'primary.example.com' });

// Read from replica
async function getUsers() {
  return readPool.query('SELECT * FROM users');
}

// Write to primary
async function createUser(data) {
  return writePool.query('INSERT INTO users ...', [data]);
}
```

---

## Caching Strategy

- Cache invalidation strategy decided upfront—TTL, event-based, or both
- Cache at right layer: query result, computed value, HTTP response
- Cache stampede prevention—lock or probabilistic early expiration
- Monitor hit rate—low hit rate = wasted resources

### Examples

**Redis Cache (Node.js):**
```typescript
import Redis from 'ioredis';

const redis = new Redis({
  host: process.env.REDIS_HOST,
  port: 6379,
  maxRetriesPerRequest: 3
});

async function getCachedUser(userId: string) {
  const cacheKey = `user:${userId}`;
  
  // Try cache first
  const cached = await redis.get(cacheKey);
  if (cached) {
    return JSON.parse(cached);
  }
  
  // Cache miss: fetch from DB
  const user = await db.user.findUnique({ where: { id: userId } });
  
  // Store in cache (1 hour TTL)
  await redis.setex(cacheKey, 3600, JSON.stringify(user));
  
  return user;
}

// Cache invalidation
async function updateUser(userId: string, data: any) {
  const user = await db.user.update({ where: { id: userId }, data });
  
  // Invalidate cache
  await redis.del(`user:${userId}`);
  
  return user;
}
```

**Cache Stampede Prevention:**
```typescript
import { Mutex } from 'async-mutex';

const locks = new Map<string, Mutex>();

async function getCachedWithLock(key: string, fetchFn: () => Promise<any>) {
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);
  
  // Get or create lock for this key
  if (!locks.has(key)) {
    locks.set(key, new Mutex());
  }
  const lock = locks.get(key)!;
  
  // Only one request fetches, others wait
  return lock.runExclusive(async () => {
    // Check cache again (might be populated by another request)
    const cached = await redis.get(key);
    if (cached) return JSON.parse(cached);
    
    // Fetch and cache
    const data = await fetchFn();
    await redis.setex(key, 3600, JSON.stringify(data));
    return data;
  });
}
```

---

## Rate Limiting

- Per-user/IP limits on expensive operations—login, signup, search
- Different limits for different operations—read vs write
- Return Retry-After header—tell clients when to retry
- Rate limit early in request pipeline—save resources

### Examples

**Express Rate Limit:**
```typescript
import rateLimit from 'express-rate-limit';

// General API rate limit
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false
});

// Strict limit for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // Only 5 login attempts
  skipSuccessfulRequests: true
});

app.use('/api/', apiLimiter);
app.use('/auth/login', authLimiter);
```

**Redis-based Rate Limit:**
```typescript
async function checkRateLimit(userId: string, limit: number, window: number) {
  const key = `ratelimit:${userId}`;
  const current = await redis.incr(key);
  
  if (current === 1) {
    await redis.expire(key, window);
  }
  
  if (current > limit) {
    const ttl = await redis.ttl(key);
    throw new RateLimitError(`Rate limit exceeded. Retry after ${ttl}s`);
  }
  
  return { remaining: limit - current, resetIn: await redis.ttl(key) };
}
```

---

## Health Checks

- Liveness: is process running—restart if fails
- Readiness: can handle traffic—remove from load balancer if fails
- Startup probe for slow-starting services—don't kill during init
- Health checks fast and cheap—don't hit database on every probe

### Examples

**Express Health Endpoints:**
```typescript
// Liveness: simple ping
app.get('/health/live', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Readiness: check dependencies
app.get('/health/ready', async (req, res) => {
  try {
    // Quick DB check
    await prisma.$queryRaw`SELECT 1`;
    
    // Quick Redis check
    await redis.ping();
    
    res.status(200).json({
      status: 'ready',
      checks: {
        database: 'ok',
        cache: 'ok'
      }
    });
  } catch (err) {
    res.status(503).json({
      status: 'not ready',
      error: err.message
    });
  }
});
```

**Kubernetes Probes:**
```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: app
    livenessProbe:
      httpGet:
        path: /health/live
        port: 3000
      initialDelaySeconds: 10
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /health/ready
        port: 3000
      initialDelaySeconds: 5
      periodSeconds: 5
    startupProbe:
      httpGet:
        path: /health/live
        port: 3000
      failureThreshold: 30
      periodSeconds: 10
```

---

## Graceful Shutdown

- Stop accepting new requests first—drain load balancer
- Wait for in-flight requests to complete—with timeout
- Close database connections cleanly—prevent connection leaks
- SIGTERM handling: graceful; SIGKILL after timeout

### Examples

**Node.js Graceful Shutdown:**
```typescript
const server = app.listen(3000);

let isShuttingDown = false;

// Stop accepting new connections
app.use((req, res, next) => {
  if (isShuttingDown) {
    res.set('Connection', 'close');
    return res.status(503).json({ error: 'Server is shutting down' });
  }
  next();
});

async function gracefulShutdown(signal: string) {
  console.log(`${signal} received, starting graceful shutdown`);
  isShuttingDown = true;
  
  // Stop accepting new connections
  server.close(async () => {
    console.log('HTTP server closed');
    
    try {
      // Close database connections
      await prisma.$disconnect();
      console.log('Database connections closed');
      
      // Close Redis connections
      await redis.quit();
      console.log('Redis connections closed');
      
      process.exit(0);
    } catch (err) {
      console.error('Error during shutdown:', err);
      process.exit(1);
    }
  });
  
  // Force shutdown after 30 seconds
  setTimeout(() => {
    console.error('Forced shutdown after timeout');
    process.exit(1);
  }, 30000);
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));
```

---

## Logging

- Structured logs (JSON)—parseable by log aggregators
- Request ID in every log—trace request across services
- Log level appropriate: debug for dev, info/error for prod
- Sensitive data never logged—passwords, tokens, PII

### Examples

**Winston Logger:**
```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'api' },
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

// Request logging middleware
app.use((req, res, next) => {
  req.id = req.headers['x-request-id'] || uuid();
  
  logger.info({
    requestId: req.id,
    method: req.method,
    path: req.path,
    ip: req.ip
  });
  
  next();
});

// Usage
logger.info({ requestId: req.id, userId, action: 'user_created' });
logger.error({ requestId: req.id, error: err.message, stack: err.stack });
```

---

## API Design

- Versioning strategy from day one—path (/v1/) or header
- Pagination for list endpoints—cursor or offset; include total count
- Consistent response format—same envelope everywhere
- Meaningful status codes—201 for create, 204 for delete, 404 for not found

### Examples

**RESTful API Design:**
```typescript
// Versioned routes
app.use('/api/v1', v1Router);

// Pagination
app.get('/api/v1/users', async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 20;
  const offset = (page - 1) * limit;
  
  const [users, total] = await Promise.all([
    db.user.findMany({ skip: offset, take: limit }),
    db.user.count()
  ]);
  
  res.json({
    data: users,
    pagination: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit)
    }
  });
});

// Consistent response format
interface ApiResponse<T> {
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    requestId: string;
    timestamp: string;
  };
}

// Status codes
app.post('/api/v1/users', async (req, res) => {
  const user = await createUser(req.body);
  res.status(201).json({ data: user }); // 201 Created
});

app.delete('/api/v1/users/:id', async (req, res) => {
  await deleteUser(req.params.id);
  res.status(204).send(); // 204 No Content
});
```

---

## Security Hygiene

- Secrets from environment or vault—never in code or config files
- Dependencies updated regularly—automated with Dependabot/Renovate
- Principle of least privilege—service accounts with minimal permissions
- Authentication and authorization separated—who you are vs what you can do

### Examples

**Environment Variables:**
```typescript
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
  REDIS_URL: z.string().url(),
  NODE_ENV: z.enum(['development', 'production', 'test'])
});

const env = envSchema.parse(process.env);

export default env;
```

**JWT Authentication:**
```typescript
import jwt from 'jsonwebtoken';

// Middleware
async function authenticate(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }
  
  try {
    const payload = jwt.verify(token, env.JWT_SECRET);
    req.user = payload;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

// Authorization
function authorize(...roles: string[]) {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    next();
  };
}

// Usage
app.get('/admin/users', authenticate, authorize('admin'), getUsers);
```

---

## Observability

- Metrics: request count, latency percentiles, error rate—the RED method
- Distributed tracing for microservices—follow request across services
- Alerting on symptoms, not causes—high error rate, not CPU usage
- Dashboards for operational visibility—know normal to spot abnormal

### Examples

**Prometheus Metrics:**
```typescript
import promClient from 'prom-client';

const register = new promClient.Registry();

// Request counter
const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'path', 'status'],
  registers: [register]
});

// Request duration
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration',
  labelNames: ['method', 'path', 'status'],
  buckets: [0.1, 0.5, 1, 2, 5],
  registers: [register]
});

// Middleware
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    
    httpRequestsTotal.inc({
      method: req.method,
      path: req.route?.path || req.path,
      status: res.statusCode
    });
    
    httpRequestDuration.observe({
      method: req.method,
      path: req.route?.path || req.path,
      status: res.statusCode
    }, duration);
  });
  
  next();
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});
```

---

## 📚 Additional Resources

- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [The Twelve-Factor App](https://12factor.net/)
- [API Security Checklist](https://github.com/shieldfy/API-Security-Checklist)
- [Microservices Patterns](https://microservices.io/patterns/)
