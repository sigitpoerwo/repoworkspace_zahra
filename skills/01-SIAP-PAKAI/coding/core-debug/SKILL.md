---
name: core-debug
description: "Use this when encountering bugs, crashes, or unhandled states. Methodical 4-phase debugging approach."
metadata: { "openclaw": { "emoji": "🐛", "requires": { "bins": [] } } }
---

# 🐛 Systematic Debugging

## Overview
Do NOT blindly guess fixes. Use this 4-phase rigorous methodology to find the root cause of an issue.

## 4-Phase System

### 1. Reproduce
- Ensure you can consistently trigger the bug.
- Log the steps clearly. Find the exact inputs, environmental conditions, and state.

### 2. Isolate
- Strip away complexities.
- Isolate the error to a specific module, function, or line of code.

### 3. Root Cause Identification
- Find the actual cause.
- Do not stop at the symptom level. Use assertions, console logs, or debug loops.

### 4. Verify Fix
- Write a TDD test that naturally fails because of this bug.
- Fix the bug completely.
- Verify the test passes, and watch out for regressions.
