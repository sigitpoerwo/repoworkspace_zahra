# 🔍 03-BELUM-DICOBA

Skills yang belum di-test. Perlu evaluasi sebelum digunakan.

---

## 📥 Dari ClawHub (4 skills)

Skills yang diinstall dari ClawHub tapi belum dicoba.

- **mcporter-1.0.0** - MCP server porter
  - Status: Not tested
  - Purpose: MCP server management
  - Next: Test functionality

- **nano-banana-pro-2-0.1.0** - Nano Banana Pro
  - Status: Not tested
  - Purpose: Unknown (needs investigation)
  - Next: Read documentation

- **ontology-1.0.4** - Ontology management
  - Status: Not tested
  - Purpose: Knowledge graph management
  - Next: Test with sample data

- **new** - New skill template
  - Status: Not tested
  - Purpose: Skill creation template
  - Next: Review template structure

---

## 📥 Dari GitHub (0 skills)

*No GitHub skills yet*

---

## ✅ Testing Checklist

Before moving to other categories:

1. **Read Documentation**
   - [ ] Check SKILL.md
   - [ ] Understand purpose
   - [ ] Note requirements

2. **Test Functionality**
   - [ ] Run basic test
   - [ ] Check for errors
   - [ ] Verify output

3. **Evaluate Usefulness**
   - [ ] Does it solve a problem?
   - [ ] Is it better than alternatives?
   - [ ] Will you use it regularly?

4. **Categorize**
   - [ ] Move to 01-SIAP-PAKAI if works well
   - [ ] Move to 02-PERLU-SETUP if needs config
   - [ ] Move to 04-TIDAK-RELEVAN if not useful

---

## 🔄 After Testing

### If Skill Works Well
```bash
# Move to appropriate SIAP-PAKAI category
mv 03-BELUM-DICOBA/dari-clawhub/skill-name \
   01-SIAP-PAKAI/category/
```

### If Needs Setup
```bash
# Move to PERLU-SETUP
mv 03-BELUM-DICOBA/dari-clawhub/skill-name \
   02-PERLU-SETUP/butuh-api-key/
```

### If Not Useful
```bash
# Archive to TIDAK-RELEVAN
mv 03-BELUM-DICOBA/dari-clawhub/skill-name \
   04-TIDAK-RELEVAN/
```

---

## 📝 Testing Notes Template

When testing a skill, document:

```markdown
## Skill: [name]
**Tested**: [date]
**Result**: ✅ Works / ⚠️ Needs Setup / ❌ Not Useful

### What it does:
[description]

### Test results:
[what happened]

### Decision:
- [ ] Move to 01-SIAP-PAKAI/[category]
- [ ] Move to 02-PERLU-SETUP/[subcategory]
- [ ] Move to 04-TIDAK-RELEVAN
- [ ] Keep here for more testing

### Notes:
[additional observations]
```

---

**Total**: 4 skills awaiting testing 🔍

**Priority**: Test these skills when you have time to evaluate their usefulness.
