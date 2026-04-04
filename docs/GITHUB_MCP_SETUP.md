# GITHUB MCP - SETUP GUIDE

**Tanggal:** 3 April 2026, 23:56 WIB  
**Status:** Installed, Need Token

---

## 📋 OVERVIEW

GitHub MCP memungkinkan OpenClaw untuk:
- Manage repositories
- Create/update issues & PRs
- Search code
- Manage branches & commits
- View workflows & releases
- Access organization data

---

## 🔧 SETUP STEPS

### **Step 1: Create GitHub Personal Access Token**

1. **Login ke GitHub:**
   - Buka: https://github.com/settings/tokens

2. **Generate New Token:**
   - Click "Generate new token" → "Generate new token (classic)"
   - Token name: `OpenClaw MCP`
   - Expiration: `No expiration` (atau sesuai kebutuhan)

3. **Select Scopes:**
   
   **Repository Access:**
   - ✅ `repo` - Full control of private repositories
     - `repo:status` - Access commit status
     - `repo_deployment` - Access deployment status
     - `public_repo` - Access public repositories
     - `repo:invite` - Access repository invitations
     - `security_events` - Read/write security events
   
   **Organization Access:**
   - ✅ `read:org` - Read org and team membership
   - ✅ `read:project` - Read project data
   
   **User Access:**
   - ✅ `user` - Update ALL user data
     - `read:user` - Read ALL user profile data
     - `user:email` - Access user email addresses
     - `user:follow` - Follow/unfollow users
   
   **Workflow Access:**
   - ✅ `workflow` - Update GitHub Action workflows
   
   **Gist Access (Optional):**
   - ☐ `gist` - Create gists

4. **Generate Token:**
   - Click "Generate token"
   - **COPY TOKEN IMMEDIATELY** (won't be shown again)
   - Format: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

---

### **Step 2: Update OpenClaw Config**

**File:** `C:\Users\Administrator\.openclaw\openclaw.json`

**Update GitHub MCP section:**
```json
{
  "mcp": {
    "servers": {
      "github": {
        "command": "npx",
        "args": ["-y", "@fre4x/github"],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
        }
      }
    }
  }
}
```

---

### **Step 3: Verify Configuration**

```bash
# Check GitHub MCP config
openclaw mcp show github

# List all MCP servers
openclaw mcp list
```

---

## 📝 USAGE EXAMPLES

### **Repository Management:**
```
"List my GitHub repositories"
"Show details of repo: openclaw/openclaw"
"Create new repository named 'test-project'"
"Fork repository: username/repo-name"
```

### **Issues:**
```
"List issues in repo: owner/repo"
"Create issue in repo: owner/repo with title 'Bug fix'"
"Close issue #123 in repo: owner/repo"
"Add comment to issue #123: 'Fixed in PR #124'"
```

### **Pull Requests:**
```
"List PRs in repo: owner/repo"
"Get PR #45 details in repo: owner/repo"
"Create PR from branch 'feature' to 'main'"
"Merge PR #45 in repo: owner/repo"
```

### **Code Search:**
```
"Search code 'function main' in repo: owner/repo"
"Find files named 'config.json' in repo: owner/repo"
"Search for TODO comments in my repositories"
```

### **Branches & Commits:**
```
"List branches in repo: owner/repo"
"Get latest commits in repo: owner/repo"
"Create branch 'feature-x' in repo: owner/repo"
"Get commit details: abc123def"
```

### **Workflows & Releases:**
```
"List workflows in repo: owner/repo"
"Get workflow run status for repo: owner/repo"
"List releases in repo: owner/repo"
"Create release v1.0.0 in repo: owner/repo"
```

---

## 🔐 SECURITY BEST PRACTICES

### **Token Security:**
- ✅ Never commit token to Git
- ✅ Store token in config file only
- ✅ Use minimal required scopes
- ✅ Rotate token periodically (every 90 days)
- ✅ Revoke token if compromised

### **Access Control:**
- ✅ Use fine-grained tokens when possible
- ✅ Limit token to specific repositories
- ✅ Review token usage regularly
- ✅ Enable 2FA on GitHub account

---

## 🆘 TROUBLESHOOTING

### **Error: "Bad credentials"**
- Token expired or invalid
- Regenerate token with correct scopes
- Update config with new token

### **Error: "Not found"**
- Repository doesn't exist or no access
- Check repository name spelling
- Verify token has `repo` scope

### **Error: "Resource not accessible"**
- Token missing required scope
- Add necessary scope to token
- Regenerate and update config

### **Error: "Rate limit exceeded"**
- GitHub API rate limit reached
- Wait for rate limit reset
- Use authenticated requests (token)

---

## 📊 GITHUB API RATE LIMITS

### **With Token (Authenticated):**
- **REST API:** 5,000 requests/hour
- **Search API:** 30 requests/minute
- **GraphQL API:** 5,000 points/hour

### **Without Token (Unauthenticated):**
- **REST API:** 60 requests/hour
- **Search API:** 10 requests/minute

**Recommendation:** Always use token for better rate limits

---

## 🎯 INTEGRATION WITH OPENCLAW

### **Skills Integration:**
- `github` skill (if exists)
- `coding-agent` skill
- `auto-create-ai-team` skill

### **Workflows:**
1. **Code Review:** Fetch PR, analyze code, add comments
2. **Issue Management:** Create issues from bugs, assign, track
3. **Release Automation:** Create releases, generate changelogs
4. **Repository Sync:** Clone, pull, push changes
5. **CI/CD Monitoring:** Check workflow status, trigger builds

---

## 📚 RESOURCES

- **GitHub API Docs:** https://docs.github.com/en/rest
- **Personal Access Tokens:** https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
- **MCP Package:** https://npm.im/@fre4x/github
- **OpenClaw Docs:** https://docs.openclaw.ai

---

## 📝 QUICK SETUP CHECKLIST

- [ ] Create GitHub Personal Access Token
- [ ] Copy token (format: `ghp_...`)
- [ ] Update `openclaw.json` with token
- [ ] Verify config: `openclaw mcp show github`
- [ ] Test: "List my GitHub repositories"

---

**Status:** ⚠️ Awaiting Token Setup  
**Next:** Create GitHub token and update config

---

**Created:** 2026-04-03 23:56 WIB  
**Location:** E:\ZAHRA-WORKSPACE\mcp-servers\GITHUB_MCP_SETUP.md
