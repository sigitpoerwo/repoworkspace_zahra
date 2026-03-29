---
name: zahra-workspace-manager
description: Comprehensive workspace management skill for Zahra Maurita's development environment. Use when managing projects across 8 divisions (Web, App, AI Agent, Bot, Content, Marketing, Research, Business), organizing files, tracking progress, managing memory, or coordinating multi-domain work. Triggers on mentions of workspace organization, project management, division-specific tasks, memory updates, or cross-domain coordination.
compatibility:
  required_tools:
    - file_operations
    - command_execution
  optional_tools:
    - web_search
    - git_operations
---

# Zahra Workspace Manager

Comprehensive workspace management untuk Zahra Maurita - Adaptive Research & Creation Hub.

## Overview

Zahra Workspace adalah polymath digital workspace dengan 8 divisi spesialisasi. Skill ini membantu manage projects, track progress, update memory, dan coordinate work across divisions.

## Workspace Structure

```
E:\ZAHRA-WORKSPACE\
├── .ai\                    # AI configuration & memory
│   ├── identity.md         # Who you are, principles
│   ├── skills.md           # Capabilities across 8 domains
│   ├── conventions.md      # Coding & writing standards
│   ├── workflows.md        # SOP per domain
│   └── memory\             # Long-term memory
│       ├── progress.md     # State terakhir
│       ├── backlog.md      # Task queue
│       ├── decisions.md    # Architectural decisions
│       └── learnings.md    # Lessons & gotchas
│
├── projects\               # Active projects
│   └── <project-name>\
│
├── skills\                 # 86 curated skills
│   ├── 01-SIAP-PAKAI\     # 48 ready-to-use
│   ├── 02-PERLU-SETUP\    # 13 need setup
│   └── 03-BELUM-DICOBA\   # 24 for testing
│
├── docs\                   # Documentation
├── scripts\                # Utilities & tools
└── plans\                  # Project plans
```

## 8 Divisi Kerja

| Divisi | Folder | Mindset | Tools |
|--------|--------|---------|-------|
| 🌐 Web Dev | `E:\PROJECTS\web\` | "Bisa handle 1 juta user?" | React, Next.js, Vue, Nuxt |
| 📱 App Dev | `E:\PROJECTS\apps\` | "UX-nya world-class?" | React Native, Flutter |
| 🤖 AI Agent | `E:\PROJECTS\agents\` | "Client bisa pakai tanpa support?" | LangChain, CrewAI, AutoGen |
| 🔧 Bot | `E:\PROJECTS\bots\` | "Edge case sudah ke-handle?" | Telegram, Discord, WhatsApp |
| 🎬 Content | `E:\PROJECTS\content\` | "Orang akan share ini?" | TikTok, Threads, YouTube |
| 📈 Marketing | `E:\PROJECTS\marketing\` | "Berapa cost per acquisition?" | Ads, SEO, Email |
| 🔬 Research | `E:\PROJECTS\research\` | "Reviewer akan accept?" | SPSS, SmartPLS, LaTeX |
| 💡 Business | `E:\PROJECTS\business\` | "Orang mau bayar?" | Lean Canvas, MVP |

## Core Workflows

### 1. Opening Protocol (Setiap Sesi Baru)

**WAJIB baca berurutan:**
1. `.ai/memory/progress.md` → State terakhir
2. `.ai/memory/backlog.md` → Task queue
3. Tampilkan status & tanya divisi

**Template:**
```
📊 WORKSPACE STATUS

Last Activity: [dari progress.md]
Pending Tasks: [dari backlog.md]

🎯 Mau kerja di divisi mana hari ini?
🌐 Web | 📱 App | 🤖 Agent | 🔧 Bot | 🎬 Content | 📈 Marketing | 🔬 Research | 💡 Business
```

### 2. Memory Update Protocol

**After completing work, ALWAYS update:**

**progress.md:**
```markdown
## [Date] - [Divisi] - [Task]
- ✅ Completed: [what]
- 📝 Notes: [insights]
- 🔗 Files: [changed files]
```

**backlog.md:**
```markdown
## High Priority
- [ ] Task 1
- [ ] Task 2

## Medium Priority
- [ ] Task 3

## Low Priority
- [ ] Task 4
```

**decisions.md** (jika ada keputusan arsitektur):
```markdown
## [Date] - [Decision Title]
**Context:** [why decision needed]
**Decision:** [what was decided]
**Reasoning:** [why this choice]
**Alternatives:** [what was considered]
**Status:** [Active/Superseded]
```

**learnings.md** (jika ada insight penting):
```markdown
## [Date] - [Topic]
**Problem:** [what happened]
**Solution:** [how fixed]
**Lesson:** [what learned]
**Prevention:** [how to avoid]
```

### 3. Project Creation Workflow

**Step 1: Determine Division**
```bash
# Ask user which division
# Set project location: E:\PROJECTS\<divisi>\<nama-project>\
```

**Step 2: Create Structure**
```bash
mkdir -p E:\PROJECTS\<divisi>\<nama-project>
cd E:\PROJECTS\<divisi>\<nama-project>

# Create standard files
touch README.md
touch SPEC.md
touch .gitignore
```

**Step 3: Initialize Based on Division**

**Web/App:**
```bash
npm init -y
# Add dependencies based on stack
```

**Agent/Bot:**
```bash
# Create virtual env or npm project
# Add AI/bot dependencies
```

**Content:**
```bash
# Create content structure
mkdir -p scripts templates output
```

**Research:**
```bash
# Create research structure
mkdir -p data analysis papers
```

**Business:**
```bash
# Create business structure
mkdir -p canvas validation mvp
```

**Step 4: Update Memory**
- Add to backlog.md
- Note in progress.md
- Create initial SPEC.md

### 4. Division-Specific Workflows

#### 🌐📱 Web & App Development
```
1. Design (UI/UX) → 2. Brainstorm → 3. Plan → 4. TDD → 5. Verify → 6. Review → 7. Deploy
```

**Quality Gates:**
- [ ] Mobile-first responsive
- [ ] LCP < 2.5s
- [ ] WCAG 2.1 AA compliant
- [ ] OWASP Top 10 checked

#### 🤖🔧 AI Agent & Bot
```
1. Define Spec → 2. Design Tools → 3. Implement → 4. Test → 5. Optimize → 6. Deploy
```

**Quality Gates:**
- [ ] Error handling comprehensive
- [ ] Edge cases covered
- [ ] Rate limiting implemented
- [ ] Logging complete

#### 🎬 Content Creation
```
1. Research → 2. Ideation → 3. Script → 4. Production → 5. Optimize → 6. Post & Monitor
```

**Quality Gates:**
- [ ] Hook dalam 3 detik
- [ ] Value proposition jelas
- [ ] CTA actionable
- [ ] Platform-optimized

#### 📈 Digital Marketing
```
1. Strategy → 2. Creative → 3. Setup → 4. Launch → 5. Optimize → 6. Report
```

**Quality Gates:**
- [ ] Target audience defined
- [ ] KPIs set
- [ ] Tracking configured
- [ ] Budget allocated

#### 🔬 Research
```
1. Topic → 2. Literature Review → 3. Methodology → 4. Data → 5. Analysis → 6. Writing → 7. Submit
```

**Quality Gates:**
- [ ] Novelty clear
- [ ] Methodology sound
- [ ] Citations proper (APA 7th)
- [ ] Similarity < 20%

#### 💡 Business Ideas
```
1. Ideation → 2. Lean Canvas → 3. Validation → 4. MVP → 5. Build → 6. Launch → 7. Iterate
```

**Quality Gates:**
- [ ] Problem validated
- [ ] Market size estimated
- [ ] Revenue model clear
- [ ] MVP scope defined

## Commands & Shortcuts

### Quick Commands
```bash
# Check workspace status
/status

# Update memory
/update-memory

# Create new project
/new-project <divisi> <nama>

# Switch division
/switch <divisi>

# Show backlog
/backlog

# Show recent progress
/progress
```

### File Operations
```bash
# Read memory files
cat .ai/memory/progress.md
cat .ai/memory/backlog.md

# Update memory
echo "## [Date] - [Task]" >> .ai/memory/progress.md

# List projects by division
ls E:\PROJECTS\<divisi>\
```

## Best Practices

### 1. Memory Discipline
- ✅ ALWAYS update progress.md after work
- ✅ Keep backlog.md current
- ✅ Document important decisions
- ✅ Record learnings & gotchas

### 2. Code Quality
- ✅ TypeScript untuk type safety
- ✅ Functional components dengan hooks
- ✅ Error handling comprehensive
- ✅ No hardcoded values (use env vars)

### 3. Documentation
- ✅ README untuk setiap project
- ✅ SPEC.md untuk setiap feature
- ✅ Comments untuk complex logic
- ✅ API documentation

### 4. Security
- ✅ No secrets in code
- ✅ Environment variables configured
- ✅ Input validation implemented
- ✅ Rate limiting active

## Templates

### Project README Template
```markdown
# Project Name

## Overview
[Brief description]

## Tech Stack
- [Technology 1]
- [Technology 2]

## Setup
\`\`\`bash
# Installation steps
\`\`\`

## Usage
\`\`\`bash
# How to use
\`\`\`

## Status
- [x] Phase 1
- [ ] Phase 2
```

### SPEC.md Template
```markdown
# Feature Specification

## Problem
[What problem does this solve?]

## Solution
[How does this solve it?]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Technical Design
[Architecture, data flow, etc.]

## Testing
[How to test]

## Deployment
[How to deploy]
```

## Troubleshooting

### If Stuck
1. Check `.ai/memory/learnings.md` for similar issues
2. Review `.ai/conventions.md` for standards
3. Check `skills/` for relevant skills
4. Ask user for clarification

### If Error
1. Read error message carefully
2. Check learnings.md for known issues
3. Use `/debug` skill if available
4. Document solution in learnings.md

## Integration with Other Skills

### Power Combo Skills
- `/ui-ux-pro-max` - Design system (67 styles, 161 palettes)
- `/brainstorm` - Architecture planning
- `/plan` - Project planning
- `/tdd` - Test-driven development
- `/verify` - Quality checks
- `/review` - Code review
- `/finish` - Deployment

### Skill Location
- Ready-to-use: `skills/01-SIAP-PAKAI/`
- Need setup: `skills/02-PERLU-SETUP/`
- Testing: `skills/03-BELUM-DICOBA/`

## Success Metrics

### Per Division
- **Web/App:** Performance, accessibility, user satisfaction
- **Agent/Bot:** Reliability, error rate, user adoption
- **Content:** Engagement, shares, conversions
- **Marketing:** ROI, CAC, conversion rate
- **Research:** Publications, citations, impact
- **Business:** Revenue, users, product-market fit

### Workspace Health
- Memory files updated regularly
- Backlog prioritized
- Projects organized
- Documentation current
- Skills utilized

## Notes

- Bahasa default: Bahasa Indonesia (komunikasi)
- Code: English (variables, functions, comments)
- Research: Sesuai target jurnal
- Content: Sesuai target audience

---

**Version:** 1.0.0
**Last Updated:** 2026-03-23
**Status:** Production Ready
**Author:** Zahra Maurita
