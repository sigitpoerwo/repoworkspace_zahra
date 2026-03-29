---
name: code-review
description: "Request or provide code reviews. Check for correctness, maintainability, performance, security. Report issues by severity."
metadata: { "openclaw": { "emoji": "👁️", "requires": { "bins": [] } } }
---

# Code Review

## Overview

A systematic approach to reviewing code for correctness, maintainability, performance, and security.

## Requesting Code Review

### Before Requesting

- [ ] All tests pass locally
- [ ] Code is self-reviewed
- [ ] PR description is clear
- [ ] Changes are focused (not too large)
- [ ] Documentation updated

### What to Include

1. **Context:** What problem does this solve?
2. **Approach:** How does it solve it?
3. **Concerns:** Any areas you're unsure about?
4. **Testing:** How was this tested?

## Performing Code Review

### Review Checklist

#### Correctness
- [ ] Does it solve the stated problem?
- [ ] Are edge cases handled?
- [ ] Are error cases handled?
- [ ] Does it match the design/spec?

#### Code Quality
- [ ] Is it readable and well-named?
- [ ] Is DRY (Don't Repeat Yourself)?
- [ ] Is complexity appropriate?
- [ ] Are functions/methods focused?

#### Testing
- [ ] Are there adequate tests?
- [ ] Do tests cover edge cases?
- [ ] Are tests meaningful (not just coverage)?

#### Performance
- [ ] Any obvious performance issues?
- [ ] Appropriate data structures?
- [ ] Efficient algorithms?

#### Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] Output encoding correct
- [ ] No SQL injection, XSS, etc.

#### Maintainability
- [ ] Is it documented?
- [ ] Can someone else understand it?
- [ ] Will it be easy to modify?

### Issue Severity Levels

**🔴 Critical** - Must fix before merge
- Security vulnerabilities
- Data loss/corruption
- Breaking existing functionality
- Critical performance issues

**🟡 Major** - Should fix soon
- Code that will cause problems later
- Significant technical debt
- Missing important tests
- Poor error handling

**🟢 Minor** - Nice to fix
- Style improvements
- Minor optimizations
- Documentation improvements
- Better naming

**💬 Suggestion** - Consider but optional
- Alternative approaches
- Food for thought
- Non-blocking feedback

## Writing Review Comments

### Good Comments

```
🔴 Critical: This SQL query is vulnerable to injection.
Use parameterized queries instead:

cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))

Reference: https://OWASP.org/...
```

```
🟡 Major: This function is doing too many things.
Consider splitting into:
- validateInput()
- processData()
- saveResults()

This will make it easier to test and maintain.
```

```
🟢 Minor: Consider using more descriptive names.
`x` and `y` don't convey meaning.
How about `rowIndex` and `columnIndex`?
```

### Bad Comments

- "This is wrong" (without explanation)
- "I don't like this" (subjective without alternative)
- "LGTM" on large PRs (not actually reviewed)

## Responding to Review

1. **Address all comments** - Even if you disagree
2. **Explain your reasoning** - Why you made certain choices
3. **Ask for clarification** - If feedback is unclear
4. **Make changes or explain why not** - Don't ignore feedback

## Code Review Anti-Patterns

- **Rubber stamping:** "LGTM" without reading
- **Nitpicking:** Focusing only on style
- **Scope creep:** Requesting unrelated changes
- **Blocking forever:** Never approving
- **Being vague:** "This could be better" (how?)

## After Review

- [ ] All critical issues addressed
- [ ] Major issues discussed/resolved
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Ready to merge