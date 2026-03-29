---
name: core-finish
description: "The pipeline closer. Wraps up a feature cleanly after verification."
metadata: { "openclaw": { "emoji": "🏁", "requires": { "bins": [] } } }
---

# 🏁 Core Task Finisher

## Overview
Close the loop seamlessly. Do not leave the branch messy or out of sync.

## Final Lifecycle Management

### 1. Verification Confirm
Did the `core-verify` pass entirely? If not, do not finish.

### 2. PR / Merge Prep
- Package the feature into clean, logical semantic commits (`feat`, `fix`, `chore`, `refactor`).
- Squash commits if necessary to maintain history hygiene.

### 3. Cleanup
- Remove any diagnostic code (like extraneous console.logs) and debug flags.
- Update internal `.md` plans/tickets marking them as complete.
- Leave branch, sync back to main development trunk.

---

## 📚 Examples

### Example 1: Feature Completion Workflow

**Scenario:** Completing a user authentication feature

```bash
# Step 1: Verify everything passes
npm test
npm run lint
npm run build

# Step 2: Clean up debug code
git diff  # Review changes
# Remove console.logs, debug flags, commented code

# Step 3: Commit with semantic message
git add .
git commit -m "feat: add user authentication with JWT

- Implement login/logout endpoints
- Add password hashing with bcrypt
- Create auth middleware
- Add tests for auth flow

Closes #123"

# Step 4: Update documentation
# Edit CHANGELOG.md, README.md if needed

# Step 5: Push and create PR
git push origin feature/user-auth
gh pr create --title "feat: User Authentication" --body "Implements JWT-based authentication system"

# Step 6: After merge, cleanup
git checkout main
git pull
git branch -d feature/user-auth
```

### Example 2: Bug Fix Completion

**Scenario:** Fixed a critical bug

```bash
# Step 1: Verify fix works
npm test -- --grep "payment processing"
npm run e2e

# Step 2: Clean commit
git add src/payment/processor.ts
git commit -m "fix: prevent duplicate payment processing

- Add idempotency key validation
- Implement transaction locking
- Add retry logic with exponential backoff

Fixes #456"

# Step 3: Hotfix deployment
git push origin hotfix/payment-duplicate
gh pr create --title "fix: Prevent duplicate payments" --label "hotfix"

# Step 4: After merge to main, backport to stable
git checkout stable
git cherry-pick <commit-hash>
git push origin stable
```

### Example 3: Refactoring Completion

**Scenario:** Code refactoring without feature changes

```bash
# Step 1: Verify no behavior changes
npm test
npm run build
# Compare bundle sizes

# Step 2: Squash commits for clean history
git rebase -i HEAD~5
# Mark commits as 'squash' except first

# Step 3: Clean commit message
git commit -m "refactor: simplify user service architecture

- Extract validation logic to separate module
- Replace class-based services with functions
- Improve type safety with stricter types
- No behavior changes, all tests pass"

# Step 4: Push
git push origin refactor/user-service --force-with-lease
```

---

## 🎯 Completion Checklist

### Pre-Finish Verification
- [ ] All tests pass (`npm test`)
- [ ] Linting passes (`npm run lint`)
- [ ] Build succeeds (`npm run build`)
- [ ] Manual testing completed
- [ ] Code review feedback addressed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated (if applicable)

### Code Cleanup
- [ ] Remove all `console.log()` statements
- [ ] Remove commented-out code
- [ ] Remove debug flags and temporary code
- [ ] Remove unused imports
- [ ] Remove TODO comments (or create issues)
- [ ] Format code (`npm run format`)

### Commit Hygiene
- [ ] Commits follow semantic convention
- [ ] Commit messages are descriptive
- [ ] Large commits are split logically
- [ ] Squash unnecessary commits
- [ ] No merge commits (rebase instead)

### Documentation
- [ ] README.md updated (if needed)
- [ ] API documentation updated
- [ ] Migration guide added (if breaking changes)
- [ ] Examples updated
- [ ] Comments explain "why", not "what"

### Final Steps
- [ ] Branch is up to date with main
- [ ] Conflicts resolved
- [ ] PR description is complete
- [ ] Reviewers assigned
- [ ] Labels added
- [ ] Linked to issue/ticket

---

## 🔧 Semantic Commit Convention

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Code style (formatting, semicolons)
- **refactor**: Code change that neither fixes bug nor adds feature
- **perf**: Performance improvement
- **test**: Adding or updating tests
- **chore**: Maintenance tasks (deps, config)
- **ci**: CI/CD changes
- **build**: Build system changes

### Examples

**Feature:**
```
feat(auth): add OAuth2 authentication

- Implement Google OAuth provider
- Add user profile sync
- Create auth callback handler

Closes #123
```

**Bug Fix:**
```
fix(payment): prevent race condition in checkout

Race condition occurred when multiple payment requests
were submitted simultaneously, causing duplicate charges.

- Add transaction locking
- Implement idempotency keys
- Add integration tests

Fixes #456
```

**Breaking Change:**
```
feat(api)!: change user endpoint response format

BREAKING CHANGE: User API now returns nested profile object
instead of flat structure.

Migration guide:
- Old: user.name, user.email
- New: user.profile.name, user.profile.email

Closes #789
```

---

## 🚀 PR Best Practices

### PR Title
```
feat: Add user authentication system
fix: Resolve payment processing bug
refactor: Simplify database queries
```

### PR Description Template
```markdown
## Description
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
[Add screenshots here]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests pass locally

## Related Issues
Closes #123
Relates to #456
```

---

## 🐛 Common Mistakes to Avoid

### Mistake 1: Leaving Debug Code

**Bad:**
```typescript
function processPayment(amount: number) {
  console.log('Processing payment:', amount); // ❌ Debug code
  debugger; // ❌ Debug statement
  
  // TODO: Add validation // ❌ Unresolved TODO
  
  return payment.process(amount);
}
```

**Good:**
```typescript
function processPayment(amount: number) {
  logger.info('Processing payment', { amount }); // ✅ Proper logging
  
  if (amount <= 0) {
    throw new Error('Invalid amount');
  }
  
  return payment.process(amount);
}
```

### Mistake 2: Messy Commit History

**Bad:**
```
fix typo
fix another typo
wip
wip 2
actually fix it
final fix
```

**Good:**
```
feat: add user authentication

- Implement JWT-based auth
- Add login/logout endpoints
- Create auth middleware
```

### Mistake 3: Incomplete Documentation

**Bad:**
```typescript
// ❌ No documentation
export function calculate(a: number, b: number) {
  return a * b + Math.sqrt(a);
}
```

**Good:**
```typescript
/**
 * Calculates the weighted score based on value and weight.
 * 
 * @param value - The base value to calculate from
 * @param weight - The weight multiplier
 * @returns The weighted score using formula: value * weight + sqrt(value)
 * 
 * @example
 * calculate(100, 2) // Returns 210
 */
export function calculateWeightedScore(value: number, weight: number): number {
  return value * weight + Math.sqrt(value);
}
```

---

## 📝 Post-Merge Cleanup

### After PR is Merged

```bash
# 1. Switch to main branch
git checkout main

# 2. Pull latest changes
git pull origin main

# 3. Delete local feature branch
git branch -d feature/user-auth

# 4. Delete remote feature branch (if not auto-deleted)
git push origin --delete feature/user-auth

# 5. Update dependencies (if needed)
npm install

# 6. Verify everything still works
npm test
npm run build

# 7. Tag release (if applicable)
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0
```

### Update Project Tracking

```markdown
## Task Completion

- [x] Feature implemented
- [x] Tests added
- [x] Documentation updated
- [x] PR merged
- [x] Branch cleaned up
- [x] Stakeholders notified

**Completed:** 2026-03-28
**PR:** #123
**Deployed:** v1.2.0
```

---

## 🎯 Quality Gates

Before marking as complete, ensure:

### Code Quality
- ✅ No linting errors
- ✅ No TypeScript errors
- ✅ Test coverage maintained/improved
- ✅ No security vulnerabilities
- ✅ Performance benchmarks met

### Documentation
- ✅ README updated
- ✅ API docs updated
- ✅ CHANGELOG updated
- ✅ Migration guide (if breaking)

### Process
- ✅ Code reviewed and approved
- ✅ CI/CD pipeline passes
- ✅ Deployed to staging
- ✅ QA testing completed
- ✅ Stakeholder approval

---

## 📚 Additional Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Git Best Practices](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)
- [Writing Good Commit Messages](https://chris.beams.io/posts/git-commit/)
