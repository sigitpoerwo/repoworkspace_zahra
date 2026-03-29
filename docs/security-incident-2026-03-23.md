# 🚨 SECURITY INCIDENT: Token Exposure

## Incident Details
- **Date:** 2026-03-23
- **Type:** GitHub Personal Access Token exposed in chat
- **Severity:** CRITICAL
- **Status:** REQUIRES IMMEDIATE ACTION

## Immediate Actions Required

### 1. REVOKE TOKEN IMMEDIATELY ⚠️

**Steps:**
1. Go to: https://github.com/settings/tokens
2. Find token starting with `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`
3. Click "Delete" or "Revoke"
4. Confirm deletion

### 2. Generate New Token

**Steps:**
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Set expiration (recommended: 90 days)
4. Select scopes needed:
   - `repo` (if need repository access)
   - `workflow` (if need GitHub Actions)
5. Click "Generate token"
6. **COPY TOKEN IMMEDIATELY** (won't be shown again)

### 3. Store Token Securely

**DO NOT:**
- ❌ Share in chat/email
- ❌ Commit to git
- ❌ Store in plain text files
- ❌ Share in screenshots

**DO:**
- ✅ Use environment variables
- ✅ Use GitHub Secrets (for Actions)
- ✅ Use password manager (1Password, Bitwarden)
- ✅ Use `.env` file (add to `.gitignore`)

### 4. Update Token Usage

**For GitHub Actions:**
```yaml
# In .github/workflows/*.yml
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**For Local Development:**
```bash
# In .env file (add to .gitignore)
GITHUB_TOKEN=your_new_token_here
```

**For Scripts:**
```typescript
// Read from environment
const token = process.env.GITHUB_TOKEN;
if (!token) {
  throw new Error('GITHUB_TOKEN not set');
}
```

## Prevention Measures

### 1. Add to .gitignore
```
# .gitignore
.env
.env.local
.env.*.local
*.key
*.pem
secrets/
```

### 2. Use Git Secrets Scanner
```bash
# Install git-secrets
brew install git-secrets  # macOS
# or
apt-get install git-secrets  # Linux

# Setup
git secrets --install
git secrets --register-aws
```

### 3. Pre-commit Hook
```bash
# .husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

# Check for secrets
if git diff --cached | grep -E "(ghp_|github_pat_|glpat-|sk-|pk_|api_key)"; then
  echo "❌ Potential secret detected! Commit blocked."
  exit 1
fi
```

## Lessons Learned

1. **Never share tokens in chat** - Use secure channels
2. **Use environment variables** - Never hardcode
3. **Rotate tokens regularly** - Set expiration dates
4. **Use minimal scopes** - Principle of least privilege
5. **Monitor token usage** - Check GitHub audit log

## Checklist

- [ ] Token revoked
- [ ] New token generated
- [ ] Token stored securely
- [ ] `.env` added to `.gitignore`
- [ ] Pre-commit hook added
- [ ] Team notified (if applicable)
- [ ] Audit log checked
- [ ] Incident documented

## Resources

- GitHub Token Security: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure
- Git Secrets: https://github.com/awslabs/git-secrets
- Environment Variables: https://12factor.net/config

---

**Status:** ACTIVE INCIDENT
**Priority:** P0 (Critical)
**Action Required:** IMMEDIATE
**Owner:** Zahra Maurita
