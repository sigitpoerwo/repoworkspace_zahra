# Google Workspace CLI Skill

Automate Google Workspace (Drive, Gmail, Calendar, Sheets, Docs) via command line.

## Quick Start

```bash
# Invoke skill
/google-workspace-cli

# Or use Skill tool
Skill(skill: "google-workspace-cli")
```

## What It Does

- 📧 Bulk email operations (announcements, reminders)
- 📁 Drive automation (folders, sharing, backup)
- 📅 Calendar management (events, scheduling)
- 📊 Sheets manipulation (grades, reports)
- 📄 Document generation (syllabus, handouts)
- 🤖 AI agent integration (structured JSON output)

## For Lecturers

### Common Use Cases
- Send class announcements via email
- Create assignment folders automatically
- Manage grade spreadsheets
- Schedule office hours and deadlines
- Generate course documents
- Backup student submissions

### Quick Examples

**Bulk Email:**
```bash
gws gmail messages send \
  --json '{"to":"class@university.edu","subject":"Reminder","body":"..."}'
```

**Create Folders:**
```bash
for week in {1..14}; do
  gws drive files create --json '{"name":"Week-'$week'-Assignment","mimeType":"application/vnd.google-apps.folder"}'
done
```

**Grade Spreadsheet:**
```bash
gws sheets spreadsheets create --json '{"properties":{"title":"Grades-Spring-2024"}}'
```

## Setup

```bash
# Install
npm install -g @googleworkspace/cli

# Authenticate
gws auth setup     # One-time setup
gws auth login     # Login with scopes

# Test
gws drive files list --params '{"pageSize":5}'
```

## Important Notes

⚠️ **Pre-v1.0** - Active development, expect changes
✅ **Well-documented** - Comprehensive README and examples
🔒 **Secure** - AES-256-GCM encrypted credentials
🤖 **Agent-ready** - 40+ skills included

## Repository

https://github.com/googleworkspace/cli

## Version

1.0 - Initial skill creation (2026-03-22)
