---
name: core-review
description: "Act as a Senior Auditor for code changes before merging."
metadata: { "openclaw": { "emoji": "👁️", "requires": { "bins": [] } } }
---

# 👁️ Core Review & Security Auditor

## Overview
A hyper-systematic checklist for reviewing code correctness, maintainability, performance, and memory leaks. Act as an expert reviewer who spots bad patterns, XSS vulnerabilities, SQL injections, and data access leaks.

## Audit Checklist (The Gauntlet)

### 1. Correctness & Architecture
- Code matches the approved design spec exactly and operates defensively.
- No race conditions or improper async handling.
- Components are not overloaded.

### 2. Performance & Scale
- No unneeded renders, redundant calculations, or inefficient iterations.
- Database access patterns are optimal (no N+1).
- Debouncing and throttling applied where necessary.

### 3. Security (Critical)
- **Input Validation**: No raw payload processing. Strong schemas in place (e.g., Zod).
- **Secrets Management**: No hardcoded secrets. Proper environment variables used.
- **XSS/Injection protection**: No raw innerHTML or unchecked URL variables.

## Severity Report
- 🔴 **Critical**: Vulnerabilities, data loss, crashing the app. Must fix.
- 🟡 **Major**: Technical debt, performance bottlenecks, unhandled states.
- 🟢 **Minor**: Code style, naming, refactoring suggestions.

---

## 📚 Review Examples

### Example 1: Security Review

**Code to Review:**
```typescript
// ❌ CRITICAL ISSUES
export async function loginUser(req: Request) {
  const { email, password } = await req.json();
  
  // Issue 1: No input validation
  const user = await db.query(
    `SELECT * FROM users WHERE email = '${email}'` // Issue 2: SQL Injection
  );
  
  // Issue 3: Plain text password comparison
  if (user.password === password) {
    // Issue 4: Hardcoded secret
    const token = jwt.sign({ id: user.id }, 'secret123');
    return { token };
  }
}
```

**Review Report:**
```markdown
🔴 CRITICAL (4 issues):

1. **No Input Validation** (Line 3)
   - Risk: Malformed data can crash the app
   - Fix: Add Zod schema validation
   
2. **SQL Injection Vulnerability** (Line 6-7)
   - Risk: Attacker can execute arbitrary SQL
   - Fix: Use parameterized queries
   
3. **Plain Text Password** (Line 11)
   - Risk: Passwords stored/compared in plain text
   - Fix: Use bcrypt.compare()
   
4. **Hardcoded Secret** (Line 13)
   - Risk: Secret exposed in code
   - Fix: Use environment variable

**Fixed Code:**
```typescript
import { z } from 'zod';
import bcrypt from 'bcrypt';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
});

export async function loginUser(req: Request) {
  // ✅ Input validation
  const body = await req.json();
  const { email, password } = loginSchema.parse(body);
  
  // ✅ Parameterized query
  const user = await db.query(
    'SELECT * FROM users WHERE email = $1',
    [email]
  );
  
  if (!user) {
    throw new Error('Invalid credentials');
  }
  
  // ✅ Hashed password comparison
  const valid = await bcrypt.compare(password, user.passwordHash);
  
  if (!valid) {
    throw new Error('Invalid credentials');
  }
  
  // ✅ Environment variable
  const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET!);
  return { token };
}
```

### Example 2: Performance Review

**Code to Review:**
```typescript
// ❌ PERFORMANCE ISSUES
export default function UserList({ users }) {
  return (
    <div>
      {users.map((user) => (
        <div key={user.id}>
          <h3>{user.name}</h3>
          {/* Issue 1: N+1 query in component */}
          <Posts userId={user.id} />
        </div>
      ))}
    </div>
  );
}

function Posts({ userId }) {
  const [posts, setPosts] = useState([]);
  
  // Issue 2: Fetch in useEffect (runs for each user)
  useEffect(() => {
    fetch(`/api/posts?userId=${userId}`)
      .then(res => res.json())
      .then(setPosts);
  }, [userId]);
  
  return (
    <ul>
      {posts.map((post) => (
        // Issue 3: Missing key
        <li>{post.title}</li>
      ))}
    </ul>
  );
}
```

**Review Report:**
```markdown
🟡 MAJOR (3 issues):

1. **N+1 Query Problem** (Line 7)
   - Risk: 100 users = 100 API calls
   - Impact: Slow page load, high server load
   - Fix: Fetch all posts in parent, pass as prop
   
2. **Inefficient Data Fetching** (Line 17-21)
   - Risk: Multiple sequential fetches
   - Impact: Waterfall loading, poor UX
   - Fix: Use Server Component or parallel fetching
   
3. **Missing Key Prop** (Line 26)
   - Risk: React reconciliation issues
   - Impact: Incorrect updates, performance degradation
   - Fix: Add key={post.id}

**Fixed Code:**
```typescript
// ✅ Fetch all data at once (Server Component)
async function getUsersWithPosts() {
  const users = await db.user.findMany({
    include: { posts: true }
  });
  return users;
}

export default async function UserList() {
  const users = await getUsersWithPosts();
  
  return (
    <div>
      {users.map((user) => (
        <div key={user.id}>
          <h3>{user.name}</h3>
          <ul>
            {user.posts.map((post) => (
              <li key={post.id}>{post.title}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}
```

### Example 3: Code Quality Review

**Code to Review:**
```typescript
// ❌ CODE QUALITY ISSUES
function processData(d) { // Issue 1: Poor naming
  let r = []; // Issue 2: Unclear variable
  
  // Issue 3: No error handling
  for (let i = 0; i < d.length; i++) {
    if (d[i].status == 'active') { // Issue 4: Loose equality
      // Issue 5: Complex nested logic
      if (d[i].type == 'premium') {
        if (d[i].balance > 100) {
          r.push({
            id: d[i].id,
            name: d[i].name,
            // Issue 6: Magic number
            discount: d[i].price * 0.2
          });
        }
      }
    }
  }
  
  return r;
}
```

**Review Report:**
```markdown
🟢 MINOR (6 issues):

1. **Poor Function Naming** (Line 2)
   - Issue: 'processData' is too generic
   - Fix: Use descriptive name like 'getActivePremiumUsersWithDiscount'
   
2. **Unclear Variable Names** (Line 2-3)
   - Issue: 'd' and 'r' are cryptic
   - Fix: Use 'data' and 'results' or better names
   
3. **No Error Handling** (Line 6)
   - Issue: No try-catch or validation
   - Fix: Add error boundaries
   
4. **Loose Equality** (Line 7, 10)
   - Issue: Using == instead of ===
   - Fix: Use strict equality
   
5. **Deep Nesting** (Line 7-17)
   - Issue: Hard to read and maintain
   - Fix: Use early returns or filter chains
   
6. **Magic Number** (Line 15)
   - Issue: 0.2 has no context
   - Fix: Use named constant

**Fixed Code:**
```typescript
const PREMIUM_DISCOUNT_RATE = 0.2;
const MINIMUM_BALANCE = 100;

interface User {
  id: string;
  name: string;
  status: 'active' | 'inactive';
  type: 'premium' | 'basic';
  balance: number;
  price: number;
}

interface DiscountedUser {
  id: string;
  name: string;
  discount: number;
}

function getActivePremiumUsersWithDiscount(
  users: User[]
): DiscountedUser[] {
  try {
    return users
      .filter(user => user.status === 'active')
      .filter(user => user.type === 'premium')
      .filter(user => user.balance > MINIMUM_BALANCE)
      .map(user => ({
        id: user.id,
        name: user.name,
        discount: user.price * PREMIUM_DISCOUNT_RATE
      }));
  } catch (error) {
    console.error('Error processing users:', error);
    return [];
  }
}
```

---

## 🎯 Review Checklist

### Security Checklist
- [ ] All user inputs are validated
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Secrets are in environment variables
- [ ] Authentication is properly implemented
- [ ] Authorization checks are in place
- [ ] CORS is configured correctly
- [ ] Rate limiting is implemented
- [ ] Sensitive data is encrypted
- [ ] Error messages don't leak information

### Performance Checklist
- [ ] No N+1 query problems
- [ ] Database queries are optimized
- [ ] Proper indexing is used
- [ ] Caching is implemented where needed
- [ ] Images are optimized
- [ ] Bundle size is reasonable
- [ ] No memory leaks
- [ ] Debouncing/throttling is used
- [ ] Lazy loading is implemented
- [ ] Code splitting is used

### Code Quality Checklist
- [ ] Functions are small and focused
- [ ] Variable names are descriptive
- [ ] No magic numbers or strings
- [ ] Error handling is comprehensive
- [ ] Code is DRY (Don't Repeat Yourself)
- [ ] Comments explain "why", not "what"
- [ ] TypeScript types are properly defined
- [ ] Tests are included
- [ ] Documentation is updated
- [ ] No console.logs in production

---

## 🐛 Common Issues & Fixes

### Issue: Unhandled Promise Rejection

**Bad:**
```typescript
async function fetchData() {
  const data = await fetch('/api/data');
  return data.json();
}
```

**Good:**
```typescript
async function fetchData() {
  try {
    const response = await fetch('/api/data');
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch data:', error);
    throw error;
  }
}
```

### Issue: Memory Leak in useEffect

**Bad:**
```typescript
useEffect(() => {
  const interval = setInterval(() => {
    fetchData();
  }, 1000);
  // Missing cleanup!
}, []);
```

**Good:**
```typescript
useEffect(() => {
  const interval = setInterval(() => {
    fetchData();
  }, 1000);
  
  return () => clearInterval(interval);
}, []);
```

### Issue: Race Condition

**Bad:**
```typescript
let data = null;

async function loadData() {
  data = await fetchData();
  processData(data);
}

// Race condition if called multiple times
loadData();
loadData();
```

**Good:**
```typescript
let abortController: AbortController | null = null;

async function loadData() {
  // Cancel previous request
  if (abortController) {
    abortController.abort();
  }
  
  abortController = new AbortController();
  
  try {
    const data = await fetchData({ signal: abortController.signal });
    processData(data);
  } catch (error) {
    if (error.name === 'AbortError') {
      console.log('Request cancelled');
    } else {
      throw error;
    }
  }
}
```

---

## 📝 Review Template

```markdown
## Code Review: [Feature Name]

### Summary
Brief description of what this PR does.

### Security Review
🔴 Critical: [count]
🟡 Major: [count]
🟢 Minor: [count]

#### Critical Issues
1. [Issue description]
   - Location: [file:line]
   - Risk: [security risk]
   - Fix: [recommended fix]

### Performance Review
- [ ] No N+1 queries
- [ ] Proper caching
- [ ] Optimized queries
- [ ] Bundle size impact: [size]

### Code Quality
- [ ] Tests included
- [ ] Documentation updated
- [ ] TypeScript types complete
- [ ] No console.logs

### Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

### Approval Status
- [ ] Approved
- [ ] Approved with minor changes
- [ ] Needs major changes
- [ ] Rejected

**Reviewer:** [Name]
**Date:** [Date]
```

---

## 📚 Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Code Review Best Practices](https://google.github.io/eng-practices/review/)
- [Security Checklist](https://github.com/shieldfy/API-Security-Checklist)
- [Performance Best Practices](https://web.dev/performance/)
