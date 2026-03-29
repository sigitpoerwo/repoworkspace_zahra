---
name: core-brainstorm
description: "Use this BEFORE writing any code. Explores user intent, requirements, architecture, and design before implementation begins."
metadata: { "openclaw": { "emoji": "🧠", "requires": { "bins": [] } } }
---

# 🧠 Core Brainstorming & Design

## Overview
Turning raw ideas into fully formed, structured designs through natural collaborative dialogue. This is the **mandatory first step** before any coding happens.

## 🛑 HARD GATE
**DO NOT write code, scaffold projects, or take implementation actions until you have presented a design and the user has APPROVED it.**

## The Process

### 1. Understand the Context
- Analyze the project context (files, docs, recent commits).
- Ask clarifying questions **one at a time**. Focus on constraints, edge-cases, and success criteria.
- Prefer multiple-choice questions if applicable.

### 2. Propose Approaches
- Provide 2-3 approaches with their respective pros and cons.
- Lead with your recommended approach and explain *why* it's the best.

### 3. Present the Design
Present the architecture, component structure, data flow, and error handling. Break it down:
- Scale content based on complexity.
- Ask explicitly: *"Is this design approved for us to move to the planning stage?"*

## Output
Once approved, save the design to `docs/plans/YYYY-MM-DD-<topic>-design.md` and transition to creating an implementation plan.
