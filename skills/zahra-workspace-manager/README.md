# Zahra Workspace Manager Skill

Custom skill untuk managing Zahra Workspace - comprehensive workspace management across 8 divisions.

## What is This?

Custom skill yang dibuat mengikuti Anthropic Skills standard untuk managing Zahra Workspace. Skill ini mengintegrasikan semua workflows, memory management, dan division-specific processes dalam satu skill yang bisa di-load oleh AI assistants.

## Features

### 1. **Opening Protocol**
- Auto-read memory files (progress.md, backlog.md)
- Display workspace status
- Ask which division to work on

### 2. **Memory Management**
- Structured updates untuk progress.md
- Backlog prioritization
- Decision documentation
- Learnings capture

### 3. **Project Creation**
- Division-specific project setup
- Standard file structure
- Dependency initialization
- Memory updates

### 4. **Division-Specific Workflows**
- Web & App Development (7 steps)
- AI Agent & Bot (6 steps)
- Content Creation (6 steps)
- Digital Marketing (6 steps)
- Research (7 steps)
- Business Ideas (7 steps)

### 5. **Quality Gates**
- Per-division quality checks
- Security checklist
- Performance metrics
- Documentation requirements

## How to Use

### In Claude.ai (Paid Plans)

1. Go to Claude.ai
2. Click on Skills
3. Upload `skills/zahra-workspace-manager/SKILL.md`
4. Skill will auto-trigger when you mention:
   - Workspace management
   - Project organization
   - Division-specific tasks
   - Memory updates
   - Cross-domain coordination

### In Claude Code

```bash
# Add as plugin (if supported)
/plugin install zahra-workspace-manager

# Or reference directly
# Just mention workspace management in your prompts
```

### In API

```python
from anthropic import Anthropic

client = Anthropic(api_key="your-key")

# Upload skill
with open("skills/zahra-workspace-manager/SKILL.md", "r") as f:
    skill_content = f.read()

# Use in conversation
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=4096,
    messages=[{
        "role": "user",
        "content": "Check workspace status and show me pending tasks"
    }],
    # Skill will auto-trigger based on description
)
```

## Skill Structure

```
skills/zahra-workspace-manager/
└── SKILL.md                    # Main skill file
    ├── YAML frontmatter        # Metadata
    │   ├── name                # zahra-workspace-manager
    │   ├── description         # When to trigger
    │   └── compatibility       # Required tools
    └── Markdown content        # Instructions
        ├── Overview
        ├── Workspace Structure
        ├── 8 Divisi Kerja
        ├── Core Workflows
        ├── Commands & Shortcuts
        ├── Best Practices
        ├── Templates
        └── Troubleshooting
```

## Triggering

Skill auto-triggers pada mentions of:
- "workspace organization"
- "project management"
- "division-specific tasks"
- "memory updates"
- "cross-domain coordination"
- Nama divisi (Web, App, Agent, Bot, Content, Marketing, Research, Business)
- Memory files (progress.md, backlog.md, decisions.md, learnings.md)

## Examples

### Example 1: Check Status
```
User: "Check workspace status"

Claude (with skill):
📊 WORKSPACE STATUS

Last Activity: 2026-03-23 - Research - Skales Repository Study
Pending Tasks: 
- Study mcp-builder guide
- Extract evaluation scripts
- Create custom skills

🎯 Mau kerja di divisi mana hari ini?
🌐 Web | 📱 App | 🤖 Agent | 🔧 Bot | 🎬 Content | 📈 Marketing | 🔬 Research | 💡 Business
```

### Example 2: Create Project
```
User: "Create new AI agent project for document processing"

Claude (with skill):
Creating project in AI Agent division...

📁 E:\PROJECTS\agents\document-processor\
├── README.md
├── SPEC.md
├── .gitignore
├── package.json
└── src\

✅ Project structure created
✅ Dependencies initialized
✅ Memory updated

Next steps:
1. Define agent capabilities in SPEC.md
2. Implement document processing tools
3. Add error handling
4. Test with sample documents
```

### Example 3: Update Memory
```
User: "Update memory - completed Skales extraction"

Claude (with skill):
Updating memory files...

✅ progress.md updated:
## 2026-03-23 - Research - Skales Extraction
- ✅ Completed: Extracted rate limiter & file guard utilities
- 📝 Notes: Zero conflicts, production-ready patterns
- 🔗 Files: scripts/rate-limiter.ts, scripts/file-access-guard.ts

✅ backlog.md updated:
Removed: "Extract Skales utilities"
Added: "Study mcp-builder guide"

Memory synchronized ✓
```

## Benefits

### 1. **Consistency**
- Standardized workflows across divisions
- Consistent memory updates
- Uniform project structure

### 2. **Efficiency**
- Auto-read memory files
- Quick status checks
- Division-specific templates

### 3. **Quality**
- Built-in quality gates
- Best practices enforced
- Documentation templates

### 4. **Memory**
- Structured progress tracking
- Decision documentation
- Learnings capture

## Customization

### Add New Division
Edit SKILL.md, add to "8 Divisi Kerja" section:
```markdown
| 🎨 Design | `E:\PROJECTS\design\` | "User akan wow?" | Figma, Adobe XD |
```

### Add New Workflow
Edit SKILL.md, add to "Division-Specific Workflows":
```markdown
#### 🎨 Design
\`\`\`
1. Research → 2. Wireframe → 3. Mockup → 4. Prototype → 5. Test → 6. Deliver
\`\`\`
```

### Add New Command
Edit SKILL.md, add to "Commands & Shortcuts":
```markdown
# Show design projects
/design-projects
```

## Integration with Existing Skills

This skill works alongside:
- `/ui-ux-pro-max` - Design system
- `/brainstorm` - Architecture planning
- `/plan` - Project planning
- `/tdd` - Test-driven development
- All 86 skills in `skills/` folder

## Version History

- **v1.0.0** (2026-03-23) - Initial release
  - 8 division support
  - Memory management
  - Project creation workflows
  - Quality gates
  - Templates & best practices

## License

Custom skill untuk Zahra Workspace - Internal use

## Author

Zahra Maurita - Adaptive Research & Creation Hub

---

**Status:** ✅ Production Ready
**Compatibility:** Claude.ai, Claude Code, Claude API
**Last Updated:** 2026-03-23
