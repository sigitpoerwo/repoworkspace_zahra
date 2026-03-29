# 🛠️ 05-CUSTOM-SKILLS

Skills buatan sendiri atau modifikasi dari skills yang ada.

---

## 📦 Custom Skills (1)

- **auto-create-ai-team** - Auto AI team creation
  - Type: Custom built
  - Purpose: Automatically create AI agent teams
  - Status: Active

---

## 🎯 Purpose

Folder ini untuk:

- ✅ Skills yang kamu buat sendiri
- ✅ Modifikasi dari skills existing
- ✅ Kombinasi beberapa skills
- ✅ Project-specific skills
- ✅ Experimental skills

---

## 📝 Creating Custom Skills

### 1. Skill Structure

```
skill-name/
├── SKILL.md          # Required: Skill definition
├── README.md         # Optional: Documentation
├── scripts/          # Optional: Helper scripts
├── templates/        # Optional: Templates
└── examples/         # Optional: Usage examples
```

### 2. SKILL.md Template

```markdown
---
name: skill-name
description: Brief description of what this skill does
---

# Skill Name

## Purpose
What problem does this solve?

## Usage
How to use this skill?

## Examples
Practical examples

## Notes
Additional information
```

### 3. Best Practices

- **Clear naming**: Use descriptive, lowercase names with hyphens
- **Good documentation**: Explain purpose, usage, and examples
- **Version control**: Use git for tracking changes
- **Testing**: Test thoroughly before using in production
- **Sharing**: Consider publishing useful skills to ClawHub

---

## 🔄 Workflow

### Creating New Skill

```bash
# 1. Create directory
mkdir 05-CUSTOM-SKILLS/my-new-skill

# 2. Create SKILL.md
cat > 05-CUSTOM-SKILLS/my-new-skill/SKILL.md << 'EOF'
---
name: my-new-skill
description: What it does
---

# My New Skill

[Content here]
EOF

# 3. Test the skill
/my-new-skill

# 4. Document in INVENTARIS.md
```

### Modifying Existing Skill

```bash
# 1. Copy to custom skills
cp -r 01-SIAP-PAKAI/category/skill-name \
      05-CUSTOM-SKILLS/skill-name-modified

# 2. Make modifications
# Edit files as needed

# 3. Rename in SKILL.md
# Update name and description

# 4. Test modifications
```

---

## 📚 Skill Ideas

### Common Custom Skills

- **Project-specific workflows**: Automate your project tasks
- **Combined skills**: Merge multiple skills into one
- **Enhanced versions**: Add features to existing skills
- **Domain-specific**: Skills for your industry/niche
- **Integration skills**: Connect different tools/services

### Examples

```markdown
## project-setup
Automated setup for your specific project type

## deploy-workflow
Custom deployment pipeline for your stack

## content-pipeline
End-to-end content creation workflow

## data-processor
Custom data processing for your use case
```

---

## 🚀 Publishing

If your custom skill is useful for others:

1. **Clean up code**: Remove project-specific details
2. **Write docs**: Clear README and examples
3. **Test thoroughly**: Ensure it works in different contexts
4. **Publish to ClawHub**: Share with community
5. **Maintain**: Update based on feedback

---

## 📊 Tracking

Keep track of your custom skills:

```markdown
## Custom Skills Log

### [Skill Name]
- Created: [date]
- Purpose: [why created]
- Status: Active/Deprecated
- Usage: [how often used]
- Notes: [observations]
```

---

## 💡 Tips

- Start simple, iterate based on usage
- Document as you build
- Version your skills (use git tags)
- Share successful patterns
- Learn from community skills

---

**Total**: 1 custom skill 🛠️

**Potential**: Unlimited! Create skills that solve YOUR specific needs.
