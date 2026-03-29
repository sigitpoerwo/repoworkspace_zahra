# Zahra Maurita - OpenClaw Workspace Structure

## Directory Layout

```
joniaws-workspace/
├── .ai/                    # AI memory & context
├── .github/                # GitHub workflows & configs
├── .vscode/                # VS Code settings
├── .continue/              # Continue IDE config
├── .codex/                 # Codex config
├── docs/                   # Documentation
├── skills/                 # 663 skills library
│   ├── 01-SIAP-PAKAI/     # 200 ready skills
│   ├── 02-PERLU-SETUP/    # 177 setup-required skills
│   ├── 03-BELUM-DICOBA/   # 209 untested skills
│   ├── 04-TIDAK-RELEVAN/  # 1 irrelevant skill
│   └── 05-CUSTOM-SKILLS/  # 67 custom skills
├── IDENTITY.md             # Core identity
├── SOUL.md                 # Personality
├── AGENTS.md               # Multi-agent rules
├── USER.md                 # User profile
├── CLAUDE.md               # Claude Code instructions
├── MEMORY.md               # Memory system
├── TOOLS.md                # Available tools
├── BOOTSTRAP.md            # Initialization
├── HEARTBEAT.md            # Health check
├── GROWTH.md               # Learning & evolution
├── README.md               # Main documentation
├── SETUP.md                # Installation guide
├── LICENSE                 # MIT License
└── .gitignore              # Security exclusions
```

## OpenClaw Integration

When pulled to OpenClaw workspace (`~/.openclaw/workspace/`):

1. **Identity files** → Loaded on startup
2. **Skills** → Available via `openclaw skills list`
3. **Memory** → Persistent across sessions
4. **Docs** → Reference material

## Usage in OpenClaw

```bash
# After pulling to ~/.openclaw/workspace/
openclaw gateway restart

# Verify identity
openclaw gateway status

# List skills
openclaw skills list

# Test via Telegram
# Bot will respond with Zahra Maurita identity
```

## Customization

Edit these files to customize:
- `IDENTITY.md` - Change name, role, domains
- `SOUL.md` - Adjust personality
- `AGENTS.md` - Modify agent behavior
- `USER.md` - Update user preferences

## Backup & Sync

This workspace is designed to be:
- ✅ Version controlled (Git)
- ✅ Portable (works on any OpenClaw instance)
- ✅ Secure (no credentials)
- ✅ Extensible (add custom skills)

---

**Last Updated:** 2026-03-29
**OpenClaw Compatible:** 2026.3.24+
