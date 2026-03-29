---
name: core-verify
description: "Pre-completion checklist to guarantee robust code before finalizing."
metadata: { "openclaw": { "emoji": "✅", "requires": { "bins": [] } } }
---

# ✅ Verification Grid

## Overview
A zero-exception final check to assert everything works and no unintended side effects were introduced. Execute this checklist completely before treating a task as finished.

## 1. Test Suite & Coverage
- [ ] Ensure `pnpm test` (or equivalent) passes flawlessly.
- [ ] No warnings, no console errors left behind in output logs.
- [ ] Ensure edge cases and mock environments run properly.

## 2. Environment Impact
- [ ] Code properly formats via linters.
- [ ] Package dependencies stay intact, lockfiles not unexpectedly bloated.
- [ ] Typescript build completes without warnings.

## 3. UI/UX (Frontend)
- [ ] Layout is responsive on main viewports (Mobile, Tablet, Desktop).
- [ ] No orphaned states (loading spinners get cleared, error states render).
- [ ] Console dev tools show zero warnings (e.g., React missing keys).

Only pass to `core-finish` after all checkboxes are strictly satisfied.
