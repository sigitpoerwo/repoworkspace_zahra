---
name: core-tdd
description: "Use this to write well-tested, robust code following Test-Driven Development loops."
metadata: { "openclaw": { "emoji": "🧪", "requires": { "bins": [] } } }
---

# 🧪 Core TDD (Test-Driven Development)

## Overview
A strict workflow for writing robust, fail-safe code by enforcing test-writing *before* implementation.

## The Cycle (Red-Green-Refactor)

### 🔴 1. Red
Write a failing test case that defines the expected behavior of the feature or bugfix. This test MUST fail.

### 🟢 2. Green
Write the absolute minimum code required to make the test pass. The goal is correctness, not perfection.

### 🔵 3. Refactor
Once the tests turn green, clean up the redundant code, optimize structures, and improve naming conventions without breaking the tests.

## Hard Rules
- **No untested logic:** Every single edge case, error state, and feature must be covered.
- **Run the test suite immediately** after every small change. Do not write monolithic changes before verifying.

---

## 📚 Examples

### Example 1: Building a Calculator Function

**Step 1: 🔴 Red - Write Failing Test**
```typescript
// calculator.test.ts
import { describe, it, expect } from 'vitest';
import { add } from './calculator';

describe('Calculator', () => {
  it('should add two positive numbers', () => {
    expect(add(2, 3)).toBe(5);
  });
});

// Run: npm test
// ❌ FAIL: add is not defined
```

**Step 2: 🟢 Green - Minimum Code to Pass**
```typescript
// calculator.ts
export function add(a: number, b: number): number {
  return a + b;
}

// Run: npm test
// ✅ PASS: 1 test passed
```

**Step 3: 🔵 Refactor - Add More Tests & Edge Cases**
```typescript
// calculator.test.ts
describe('Calculator', () => {
  it('should add two positive numbers', () => {
    expect(add(2, 3)).toBe(5);
  });
  
  it('should add negative numbers', () => {
    expect(add(-2, -3)).toBe(-5);
  });
  
  it('should add zero', () => {
    expect(add(0, 5)).toBe(5);
  });
  
  it('should handle decimals', () => {
    expect(add(0.1, 0.2)).toBeCloseTo(0.3);
  });
});

// Run: npm test
// ✅ PASS: 4 tests passed
```

### Example 2: User Authentication

**Step 1: 🔴 Red - Write Failing Test**
```typescript
// auth.test.ts
import { describe, it, expect } from 'vitest';
import { login } from './auth';

describe('Authentication', () => {
  it('should return token for valid credentials', async () => {
    const result = await login('user@example.com', 'password123');
    expect(result).toHaveProperty('token');
    expect(result.token).toBeTruthy();
  });
});

// Run: npm test
// ❌ FAIL: login is not defined
```

**Step 2: 🟢 Green - Minimum Implementation**
```typescript
// auth.ts
export async function login(email: string, password: string) {
  // Hardcoded for now - just make test pass
  if (email === 'user@example.com' && password === 'password123') {
    return { token: 'fake-token-123' };
  }
  throw new Error('Invalid credentials');
}

// Run: npm test
// ✅ PASS: 1 test passed
```

**Step 3: 🔵 Refactor - Add Real Implementation**
```typescript
// auth.test.ts
describe('Authentication', () => {
  it('should return token for valid credentials', async () => {
    const result = await login('user@example.com', 'password123');
    expect(result).toHaveProperty('token');
    expect(result.token).toBeTruthy();
  });
  
  it('should throw error for invalid email', async () => {
    await expect(login('invalid@example.com', 'password123'))
      .rejects.toThrow('Invalid credentials');
  });
  
  it('should throw error for invalid password', async () => {
    await expect(login('user@example.com', 'wrongpassword'))
      .rejects.toThrow('Invalid credentials');
  });
  
  it('should validate email format', async () => {
    await expect(login('not-an-email', 'password123'))
      .rejects.toThrow('Invalid email format');
  });
});

// auth.ts (refactored)
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export async function login(email: string, password: string) {
  // Validate email format
  if (!email.includes('@')) {
    throw new Error('Invalid email format');
  }
  
  // Get user from database
  const user = await db.user.findUnique({ where: { email } });
  
  if (!user) {
    throw new Error('Invalid credentials');
  }
  
  // Verify password
  const valid = await bcrypt.compare(password, user.passwordHash);
  
  if (!valid) {
    throw new Error('Invalid credentials');
  }
  
  // Generate token
  const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET!);
  
  return { token };
}

// Run: npm test
// ✅ PASS: 4 tests passed
```

### Example 3: Shopping Cart

**Complete TDD Cycle**

```typescript
// cart.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { Cart } from './cart';

describe('Shopping Cart', () => {
  let cart: Cart;
  
  beforeEach(() => {
    cart = new Cart();
  });
  
  // 🔴 Red: Write test first
  it('should start empty', () => {
    expect(cart.getItems()).toHaveLength(0);
    expect(cart.getTotal()).toBe(0);
  });
  
  it('should add item to cart', () => {
    cart.addItem({ id: '1', name: 'Product', price: 10 });
    expect(cart.getItems()).toHaveLength(1);
    expect(cart.getTotal()).toBe(10);
  });
  
  it('should increase quantity for duplicate items', () => {
    cart.addItem({ id: '1', name: 'Product', price: 10 });
    cart.addItem({ id: '1', name: 'Product', price: 10 });
    expect(cart.getItems()).toHaveLength(1);
    expect(cart.getItems()[0].quantity).toBe(2);
    expect(cart.getTotal()).toBe(20);
  });
  
  it('should remove item from cart', () => {
    cart.addItem({ id: '1', name: 'Product', price: 10 });
    cart.removeItem('1');
    expect(cart.getItems()).toHaveLength(0);
    expect(cart.getTotal()).toBe(0);
  });
  
  it('should apply discount code', () => {
    cart.addItem({ id: '1', name: 'Product', price: 100 });
    cart.applyDiscount('SAVE20'); // 20% off
    expect(cart.getTotal()).toBe(80);
  });
});

// 🟢 Green: Implement to pass tests
// cart.ts
interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

export class Cart {
  private items: CartItem[] = [];
  private discountPercent = 0;
  
  addItem(item: { id: string; name: string; price: number }) {
    const existing = this.items.find(i => i.id === item.id);
    
    if (existing) {
      existing.quantity++;
    } else {
      this.items.push({ ...item, quantity: 1 });
    }
  }
  
  removeItem(id: string) {
    this.items = this.items.filter(item => item.id !== id);
  }
  
  getItems() {
    return this.items;
  }
  
  getTotal() {
    const subtotal = this.items.reduce(
      (sum, item) => sum + item.price * item.quantity,
      0
    );
    return subtotal * (1 - this.discountPercent / 100);
  }
  
  applyDiscount(code: string) {
    const discounts: Record<string, number> = {
      'SAVE20': 20,
      'SAVE10': 10,
    };
    this.discountPercent = discounts[code] || 0;
  }
}

// Run: npm test
// ✅ PASS: 5 tests passed
```

---

## 🎯 TDD Best Practices

### 1. Write Tests First (Always)
```typescript
// ❌ Bad: Write code first
function multiply(a, b) {
  return a * b;
}

// ✅ Good: Write test first
it('should multiply two numbers', () => {
  expect(multiply(2, 3)).toBe(6);
});
// Then implement multiply()
```

### 2. Test One Thing at a Time
```typescript
// ❌ Bad: Testing multiple things
it('should handle user operations', () => {
  const user = createUser('John');
  expect(user.name).toBe('John');
  user.updateEmail('john@example.com');
  expect(user.email).toBe('john@example.com');
  user.delete();
  expect(user.isDeleted).toBe(true);
});

// ✅ Good: Separate tests
it('should create user with name', () => {
  const user = createUser('John');
  expect(user.name).toBe('John');
});

it('should update user email', () => {
  const user = createUser('John');
  user.updateEmail('john@example.com');
  expect(user.email).toBe('john@example.com');
});

it('should mark user as deleted', () => {
  const user = createUser('John');
  user.delete();
  expect(user.isDeleted).toBe(true);
});
```

### 3. Test Edge Cases
```typescript
describe('divide', () => {
  it('should divide two numbers', () => {
    expect(divide(10, 2)).toBe(5);
  });
  
  // Edge cases
  it('should handle division by zero', () => {
    expect(() => divide(10, 0)).toThrow('Division by zero');
  });
  
  it('should handle negative numbers', () => {
    expect(divide(-10, 2)).toBe(-5);
  });
  
  it('should handle decimals', () => {
    expect(divide(1, 3)).toBeCloseTo(0.333, 2);
  });
});
```

### 4. Use Descriptive Test Names
```typescript
// ❌ Bad: Vague test names
it('works', () => { ... });
it('test 1', () => { ... });

// ✅ Good: Descriptive names
it('should return 404 when user not found', () => { ... });
it('should hash password before saving to database', () => { ... });
it('should send welcome email after successful registration', () => { ... });
```

---

## 🔧 Testing Patterns

### Pattern 1: Arrange-Act-Assert (AAA)

```typescript
it('should calculate total with tax', () => {
  // Arrange: Setup test data
  const cart = new Cart();
  cart.addItem({ id: '1', price: 100 });
  
  // Act: Execute the function
  const total = cart.getTotalWithTax(0.1); // 10% tax
  
  // Assert: Verify the result
  expect(total).toBe(110);
});
```

### Pattern 2: Test Doubles (Mocks, Stubs, Spies)

```typescript
import { vi } from 'vitest';

it('should send email on user registration', async () => {
  // Mock email service
  const emailService = {
    send: vi.fn().mockResolvedValue(true)
  };
  
  const userService = new UserService(emailService);
  await userService.register('user@example.com', 'password');
  
  // Verify email was sent
  expect(emailService.send).toHaveBeenCalledWith({
    to: 'user@example.com',
    subject: 'Welcome!',
    body: expect.any(String)
  });
});
```

### Pattern 3: Parameterized Tests

```typescript
describe('isValidEmail', () => {
  it.each([
    ['user@example.com', true],
    ['user.name@example.co.uk', true],
    ['invalid', false],
    ['@example.com', false],
    ['user@', false],
  ])('should return %s for email %s', (email, expected) => {
    expect(isValidEmail(email)).toBe(expected);
  });
});
```

---

## 🐛 Common TDD Mistakes

### Mistake 1: Writing Tests After Code

**Bad:**
```typescript
// 1. Write implementation first
function calculateDiscount(price: number, percent: number) {
  return price * (percent / 100);
}

// 2. Then write tests
it('should calculate discount', () => {
  expect(calculateDiscount(100, 20)).toBe(20);
});
```

**Good:**
```typescript
// 1. Write test first (it will fail)
it('should calculate discount', () => {
  expect(calculateDiscount(100, 20)).toBe(20);
});

// 2. Then implement
function calculateDiscount(price: number, percent: number) {
  return price * (percent / 100);
}
```

### Mistake 2: Testing Implementation Details

**Bad:**
```typescript
it('should call internal method', () => {
  const service = new UserService();
  const spy = vi.spyOn(service as any, '_validateEmail');
  service.register('user@example.com');
  expect(spy).toHaveBeenCalled(); // Testing private method
});
```

**Good:**
```typescript
it('should throw error for invalid email', () => {
  const service = new UserService();
  expect(() => service.register('invalid-email'))
    .toThrow('Invalid email'); // Testing behavior
});
```

### Mistake 3: Not Running Tests Frequently

**Bad:**
```typescript
// Write 100 lines of code
// Then run tests
// 50 tests fail, hard to debug
```

**Good:**
```typescript
// Write 1 test → Run → Pass
// Write 1 function → Run → Pass
// Write 1 test → Run → Pass
// Repeat...
```

---

## 📝 TDD Workflow Checklist

- [ ] Write a failing test (🔴 Red)
- [ ] Run test suite (should fail)
- [ ] Write minimum code to pass (🟢 Green)
- [ ] Run test suite (should pass)
- [ ] Refactor code (🔵 Refactor)
- [ ] Run test suite (should still pass)
- [ ] Commit changes
- [ ] Repeat for next feature

---

## 📚 Additional Resources

- [Test-Driven Development by Kent Beck](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- [Vitest Documentation](https://vitest.dev/)
- [Jest Documentation](https://jestjs.io/)
- [Testing Library](https://testing-library.com/)
- [Martin Fowler on TDD](https://martinfowler.com/bliki/TestDrivenDevelopment.html)
