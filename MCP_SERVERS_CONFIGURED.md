# MCP SERVERS - CONFIGURED & READY

**Last Updated:** 4 April 2026, 23:52 WIB  
**Total Servers:** 8 (7 fully active, 1 need setup)  
**Total Cost:** $0/month (all free tier)

---

## ✅ FULLY ACTIVE MCP SERVERS (7)

### 1. Wikipedia MCP
**Package:** `@modelcontextprotocol/server-wiki-explorer`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Quick facts & background information
- Historical context
- General knowledge queries
- Multi-language support

**Config:**
```json
"wikipedia": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-wiki-explorer"]
}
```

---

### 2. ArXiv MCP
**Package:** `@fre4x/arxiv`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Academic papers search
- Research citations
- Scientific literature
- Pre-print access

**Config:**
```json
"arxiv": {
  "command": "npx",
  "args": ["-y", "@fre4x/arxiv"]
}
```

---

### 3. Tavily MCP
**Package:** `tavily-mcp`  
**Status:** ✅ Active (Configured)  
**API Key:** `YOUR_TAVILY_API_KEY_HERE`  
**Free Tier:** 1000 searches/month  
**Capabilities:**
- Web search & extraction
- Real-time information
- Content aggregation
- News & trends

**Config:**
```json
"tavily": {
  "command": "npx",
  "args": ["-y", "tavily-mcp"],
  "env": {
    "TAVILY_API_KEY": "YOUR_TAVILY_API_KEY_HERE"
  }
}
```

---

### 4. Google Sheets MCP
**Package:** `google-sheets-mcp`  
**Status:** ✅ Active (Configured)  
**Service Account:** `openclaw-sheet@mcpserver-openclaw.iam.gserviceaccount.com`  
**Owner:** `masigit01@gmail.com`  
**Credentials:** `C:\Users\Administrator\.openclaw\google-sheets-credentials.json`  
**Capabilities:**
- Read/write spreadsheets
- Data automation
- Report generation
- Spreadsheet management

**Config:**
```json
"google-sheets": {
  "command": "npx",
  "args": ["-y", "google-sheets-mcp"],
  "env": {
    "GOOGLE_APPLICATION_CREDENTIALS": "C:\\Users\\Administrator\\.openclaw\\google-sheets-credentials.json"
  }
}
```

**Note:** Share spreadsheet dengan service account email untuk akses

---

### 5. Calculator MCP
**Package:** `@wrtnlabs/calculator-mcp`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Basic arithmetic operations
- Advanced calculations
- Math functions
- Formula evaluation

**Config:**
```json
"calculator": {
  "command": "npx",
  "args": ["-y", "@wrtnlabs/calculator-mcp"]
}
```

---

### 6. Time MCP
**Package:** `time-mcp`  
**Status:** ✅ Active (No API key needed)  
**Capabilities:**
- Timezone conversions
- Time calculations
- Date operations
- Scheduling helpers

**Config:**
```json
"time": {
  "command": "npx",
  "args": ["-y", "time-mcp"]
}
```

---

### 7. GitHub MCP
**Package:** `@fre4x/github`  
**Status:** ✅ Active (Configured)  
**Token:** `YOUR_GITHUB_TOKEN_HERE`  
**Rate Limits:**
- REST API: 5,000 requests/hour
- Search API: 30 requests/minute
- GraphQL API: 5,000 points/hour

**Capabilities:**
- Repository management
- Issues & Pull Requests
- Code search
- Branches & commits
- Workflows & releases
- Organization access

**Config:**
```json
"github": {
  "command": "npx",
  "args": ["-y", "@fre4x/github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_TOKEN_HERE"
  }
}
```

---

## ⚠️ NEED SETUP (1)

### 8. Notion MCP
**Package:** `@notionhq/notion-mcp-server`  
**Status:** ⚠️ Installed, need API key  
**Capabilities:**
- Notion workspace integration
- Database management
- Page creation/editing
- Content organization

**Config:**
```json
"notion": {
  "command": "npx",
  "args": ["-y", "@notionhq/notion-mcp-server"],
  "env": {
    "NOTION_API_KEY": ""
  }
}
```

**Setup Steps:**
1. Create Notion Integration: https://www.notion.so/my-integrations
2. Get API key
3. Share Notion pages with integration
4. Update `NOTION_API_KEY` in config

---

## 📋 COMPLETE OPENCLAW CONFIG

**File:** `~/.openclaw/openclaw.json` or `C:\Users\Administrator\.openclaw\openclaw.json`

```json
{
  "mcp": {
    "servers": {
      "wikipedia": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-wiki-explorer"]
      },
      "arxiv": {
        "command": "npx",
        "args": ["-y", "@fre4x/arxiv"]
      },
      "tavily": {
        "command": "npx",
        "args": ["-y", "tavily-mcp"],
        "env": {
          "TAVILY_API_KEY": "YOUR_TAVILY_API_KEY_HERE"
        }
      },
      "google-sheets": {
        "command": "npx",
        "args": ["-y", "google-sheets-mcp"],
        "env": {
          "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/google-sheets-credentials.json"
        }
      },
      "calculator": {
        "command": "npx",
        "args": ["-y", "@wrtnlabs/calculator-mcp"]
      },
      "time": {
        "command": "npx",
        "args": ["-y", "time-mcp"]
      },
      "github": {
        "command": "npx",
        "args": ["-y", "@fre4x/github"],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_TOKEN_HERE"
        }
      },
      "notion": {
        "command": "npx",
        "args": ["-y", "@notionhq/notion-mcp-server"],
        "env": {
          "NOTION_API_KEY": ""
        }
      }
    }
  }
}
```

---

## 🚀 QUICK INSTALL SCRIPT

```bash
#!/bin/bash
# Install all MCP servers

echo "Installing MCP Servers..."

npm install -g \
  @modelcontextprotocol/server-wiki-explorer \
  @fre4x/arxiv \
  tavily-mcp \
  google-sheets-mcp \
  @wrtnlabs/calculator-mcp \
  time-mcp \
  @fre4x/github \
  @notionhq/notion-mcp-server

echo "✓ All MCP Servers installed"
echo ""
echo "Next steps:"
echo "1. Update openclaw.json with API keys"
echo "2. Restart gateway: openclaw gateway restart"
echo "3. Verify: openclaw mcp list"
```

---

## 🧪 TESTING

```bash
# List all MCP servers
openclaw mcp list

# Show specific server config
openclaw mcp show wikipedia
openclaw mcp show github
openclaw mcp show tavily

# Test via OpenClaw
# "Search Wikipedia for AI research"
# "Find papers on arXiv about machine learning"
# "Search web for latest tech news"
# "List my GitHub repositories"
```

---

## 📊 CAPABILITIES SUMMARY

### Research & Information:
- ✅ Wikipedia (general knowledge)
- ✅ ArXiv (academic papers)
- ✅ Tavily (web search)

### Productivity:
- ✅ Google Sheets (spreadsheets)
- ✅ Calculator (math operations)
- ✅ Time (timezone & scheduling)

### Development:
- ✅ GitHub (repository management)
- ⚠️ Notion (workspace, need setup)

---

## 💰 COST BREAKDOWN

| Server | Cost | Free Tier |
|--------|------|-----------|
| Wikipedia | $0 | Unlimited |
| ArXiv | $0 | Unlimited |
| Tavily | $0 | 1000 searches/month |
| Google Sheets | $0 | Unlimited |
| Calculator | $0 | Unlimited |
| Time | $0 | Unlimited |
| GitHub | $0 | 5000 requests/hour |
| Notion | $0 | Unlimited |

**Total: $0/month** ✅

---

## 🔐 SECURITY NOTES

### Credentials Storage:
- ✅ Tavily API key in config
- ✅ Google Sheets credentials in JSON file
- ✅ GitHub token in config
- ✅ All credentials in environment variables
- ✅ Not exposed in public repos

### Best Practices:
- Rotate tokens every 90 days
- Use minimal required scopes
- Monitor API usage
- Revoke compromised tokens immediately

---

## 📚 DOCUMENTATION

- **Tavily:** https://docs.tavily.com
- **Google Sheets API:** https://developers.google.com/sheets/api
- **GitHub API:** https://docs.github.com/en/rest
- **Notion API:** https://developers.notion.com
- **OpenClaw Docs:** https://docs.openclaw.ai

---

**Status:** 7/8 servers fully active, 1 need setup  
**Ready for:** Research, automation, development workflows  
**Last Verified:** 4 April 2026, 23:52 WIB

---

**Created:** 2026-04-04 23:52 WIB  
**Location:** E:\bahan repo joniaws\MCP_SERVERS_CONFIGURED.md
