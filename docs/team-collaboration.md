# Team Collaboration Guide

## 📋 Overview

Panduan collaboration untuk Zahra Workspace - mendukung solo work dan team collaboration.

---

## 👥 Team Structure

### Roles

**1. Owner/Lead**
- Full access ke semua divisions
- Approve major decisions
- Review critical changes
- Manage team members

**2. Division Specialist**
- Expert di 1-2 divisions
- Lead projects di division tersebut
- Review code di division
- Mentor junior members

**3. Contributor**
- Work on assigned tasks
- Submit changes for review
- Follow conventions
- Document work

---

## 🔄 Collaboration Workflows

### 1. Project Kickoff

**Step 1: Create Project Brief**
```markdown
# Project: [Name]
Division: [Web/App/Agent/Bot/Content/Marketing/Research/Business]
Owner: [Name]
Timeline: [Start - End]

## Objective
[What we're building]

## Success Metrics
- [ ] Metric 1
- [ ] Metric 2

## Team
- Lead: [Name]
- Contributors: [Names]
```

**Step 2: Setup Project**
```bash
# Create project structure
mkdir -p E:\PROJECTS\<divisi>\<project-name>
cd E:\PROJECTS\<divisi>\<project-name>

# Initialize
git init
touch README.md SPEC.md TEAM.md

# Add to backlog
echo "- [ ] [Project Name] - [Division]" >> .ai/memory/backlog.md
```

**Step 3: Assign Tasks**
- Break down project ke tasks
- Assign ke team members
- Set deadlines
- Track di backlog.md

---

### 2. Code Review Process

**Before Submitting:**
```bash
# Self-review checklist
- [ ] Code follows conventions (.ai/conventions.md)
- [ ] Tests passing
- [ ] Documentation updated
- [ ] No console errors
- [ ] Security checklist passed
```

**Submit for Review:**
```bash
# Create feature branch
git checkout -b feature/your-feature

# Commit with convention
git commit -m "feat(scope): description"

# Push for review
git push origin feature/your-feature
```

**Review Process:**
1. **Reviewer checks:**
   - Code quality
   - Conventions compliance
   - Test coverage
   - Documentation
   - Security

2. **Feedback format:**
   ```markdown
   ## Review: [Feature Name]
   
   ### ✅ Strengths
   - [What's good]
   
   ### 🔧 Changes Needed
   - [ ] Change 1 (location: file.ts:123)
   - [ ] Change 2
   
   ### 💡 Suggestions
   - [Optional improvements]
   
   ### Decision: [Approve/Request Changes/Reject]
   ```

3. **Address feedback:**
   - Make requested changes
   - Update commit
   - Re-request review

4. **Merge:**
   ```bash
   # After approval
   git checkout main
   git merge feature/your-feature
   git push origin main
   ```

---

### 3. Communication Channels

**Daily Standup (Async)**
```markdown
## Standup: [Date]

### [Your Name]
**Yesterday:**
- [What you did]

**Today:**
- [What you'll do]

**Blockers:**
- [Any issues]
```

**Location:** `docs/standups/YYYY-MM-DD.md`

**Weekly Sync (Optional)**
- Review progress
- Discuss blockers
- Plan next week
- Share learnings

**Decision Log**
```markdown
## Decision: [Title]
**Date:** [YYYY-MM-DD]
**Participants:** [Names]
**Context:** [Why decision needed]
**Decision:** [What was decided]
**Reasoning:** [Why this choice]
**Alternatives:** [What was considered]
```

**Location:** `.ai/memory/decisions.md`

---

### 4. Project Handoff

**Handoff Checklist:**
```markdown
## Project Handoff: [Project Name]

### Documentation
- [ ] README.md complete
- [ ] SPEC.md up to date
- [ ] API documentation
- [ ] Deployment guide

### Code
- [ ] All tests passing
- [ ] No TODO/FIXME comments
- [ ] Dependencies documented
- [ ] Environment variables documented

### Knowledge Transfer
- [ ] Architecture overview session
- [ ] Code walkthrough
- [ ] Q&A session
- [ ] Contact info for questions

### Access
- [ ] Repository access granted
- [ ] API keys shared (securely)
- [ ] Deployment access granted
- [ ] Monitoring access granted

### Handoff Meeting
**Date:** [YYYY-MM-DD]
**Attendees:** [Names]
**Notes:** [Key points discussed]
```

**Location:** `docs/handoffs/[project-name].md`

---

## 📝 Documentation Standards

### 1. README.md (Every Project)
```markdown
# Project Name

## Overview
[Brief description]

## Team
- Lead: [Name]
- Contributors: [Names]

## Tech Stack
- [Technology 1]
- [Technology 2]

## Setup
\`\`\`bash
# Installation steps
\`\`\`

## Development
\`\`\`bash
# How to run locally
\`\`\`

## Testing
\`\`\`bash
# How to test
\`\`\`

## Deployment
\`\`\`bash
# How to deploy
\`\`\`

## Contact
- Lead: [email/slack]
- Team: [channel]
```

### 2. SPEC.md (Every Feature)
```markdown
# Feature: [Name]

## Problem
[What problem does this solve?]

## Solution
[How does this solve it?]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Technical Design
[Architecture, data flow, etc.]

## Testing Plan
[How to test]

## Rollout Plan
[How to deploy]

## Team
- Owner: [Name]
- Reviewers: [Names]
```

### 3. TEAM.md (Every Project)
```markdown
# Team: [Project Name]

## Current Team
- **Lead:** [Name] - [email/slack]
- **Contributors:**
  - [Name] - [email/slack] - [Focus area]
  - [Name] - [email/slack] - [Focus area]

## Roles & Responsibilities
- **Lead:** Architecture, reviews, deployment
- **Contributor 1:** Frontend development
- **Contributor 2:** Backend development

## Communication
- **Daily:** Async standups in docs/standups/
- **Weekly:** [Day/Time] sync meeting
- **Emergency:** [Contact method]

## Onboarding
New team members should:
1. Read README.md
2. Read SPEC.md
3. Setup local environment
4. Review conventions (.ai/conventions.md)
5. Pair with existing member
```

---

## 🔐 Access Management

### Repository Access
```markdown
## Access Levels

### Owner
- Full access
- Can delete
- Manage team

### Maintainer
- Push to main
- Manage issues
- Review PRs

### Developer
- Create branches
- Submit PRs
- Comment on issues

### Read-Only
- View code
- Clone repository
```

### Secrets Management
```markdown
## Secrets Sharing

### DO NOT:
- ❌ Commit secrets to git
- ❌ Share in plain text
- ❌ Email API keys

### DO:
- ✅ Use environment variables
- ✅ Share via secure channel (1Password, Bitwarden)
- ✅ Rotate regularly
- ✅ Document in .env.example (without values)
```

---

## 🎯 Conflict Resolution

### Code Conflicts
1. **Discuss:** Talk with team member
2. **Review:** Check both approaches
3. **Decide:** Lead makes final call
4. **Document:** Record decision in decisions.md

### Priority Conflicts
1. **Assess:** Check backlog priorities
2. **Discuss:** Team discussion
3. **Decide:** Owner/Lead decides
4. **Update:** Update backlog.md

### Technical Conflicts
1. **Research:** Both parties research
2. **Present:** Present findings
3. **Decide:** Technical lead decides
4. **Document:** Record in decisions.md

---

## 📊 Progress Tracking

### Individual Progress
**Location:** `.ai/memory/progress.md`

```markdown
## [Date] - [Your Name] - [Task]
- ✅ Completed: [what]
- 📝 Notes: [insights]
- 🔗 Files: [changed files]
- ⏱️ Time: [hours spent]
```

### Team Progress
**Location:** `docs/team-progress/YYYY-MM.md`

```markdown
## Team Progress: [Month Year]

### [Project Name]
**Status:** [On Track/At Risk/Blocked]
**Progress:** [X%]
**Team:** [Names]
**Next Milestone:** [Date]

### Completed This Month
- [Task 1] - [Owner]
- [Task 2] - [Owner]

### In Progress
- [Task 3] - [Owner] - [X%]
- [Task 4] - [Owner] - [X%]

### Blockers
- [Blocker 1] - [Owner] - [Status]
```

---

## 🤝 Onboarding New Members

### Day 1: Setup
```markdown
## New Member Onboarding

### Setup Checklist
- [ ] Clone repository
- [ ] Read README.md
- [ ] Read .ai/identity.md
- [ ] Read .ai/conventions.md
- [ ] Setup local environment
- [ ] Run tests successfully
- [ ] Join communication channels

### First Task
- [ ] Fix a small bug
- [ ] Submit first PR
- [ ] Get code reviewed
- [ ] Merge to main
```

### Week 1: Learn
- Read all documentation
- Pair with team member
- Understand architecture
- Complete first feature

### Month 1: Contribute
- Own small features
- Review others' code
- Participate in discussions
- Share learnings

---

## 📞 Support & Questions

### Getting Help
1. **Check docs first:** README, SPEC, conventions
2. **Search learnings:** `.ai/memory/learnings.md`
3. **Ask team:** Communication channel
4. **Escalate:** Lead if urgent

### Asking Good Questions
```markdown
## Question: [Brief title]

**Context:** [What you're trying to do]
**Problem:** [What's not working]
**Tried:** [What you've attempted]
**Expected:** [What should happen]
**Actual:** [What actually happens]
**Code:** [Relevant code snippet]
```

---

## 🎓 Knowledge Sharing

### Weekly Learnings
```markdown
## Learnings: Week of [Date]

### [Your Name]
**Learned:**
- [New skill/pattern/tool]

**Applied:**
- [Where you used it]

**Shared:**
- [How you documented it]
```

**Location:** `docs/learnings/YYYY-WW.md`

### Tech Talks (Optional)
- Monthly presentations
- Share new skills
- Demo projects
- Q&A sessions

---

## ✅ Quality Standards

### Code Quality
- [ ] Follows conventions
- [ ] Has tests
- [ ] Documented
- [ ] Reviewed
- [ ] No console errors

### Documentation Quality
- [ ] Clear and concise
- [ ] Examples included
- [ ] Up to date
- [ ] Reviewed

### Communication Quality
- [ ] Respectful
- [ ] Clear
- [ ] Actionable
- [ ] Timely

---

**Version:** 1.0.0
**Last Updated:** 2026-03-23
**Status:** Active
**Owner:** Zahra Maurita
