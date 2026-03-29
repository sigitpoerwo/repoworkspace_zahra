# Free MCP Servers Setup for Zahra
# Academic Research & Productivity Focus

## 1. Brave Search MCP (Free - Web Research)

### Install:
```bash
npm install -g @modelcontextprotocol/server-brave-search
```

### Config (~/.openclaw/openclaw.json):
```json
"mcpServers": {
  "brave-search": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-brave-search"],
    "env": {
      "BRAVE_API_KEY": "YOUR_FREE_API_KEY"
    }
  }
}
```

Get free API key: https://brave.com/search/api/

**Capabilities:**
- Real-time web search
- News & trends
- Market research
- Academic sources

---

## 2. Filesystem MCP (Free - Local Files)

### Install:
```bash
npm install -g @modelcontextprotocol/server-filesystem
```

### Config:
```json
"mcpServers": {
  "filesystem": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-filesystem",
      "/home/ubuntu/.openclaw/projects",
      "/home/ubuntu/research"
    ]
  }
}
```

**Capabilities:**
- Read/write research files
- Organize documents
- Project management

---

## 3. Memory MCP (Free - Context Retention)

### Install:
```bash
npm install -g @modelcontextprotocol/server-memory
```

### Config:
```json
"mcpServers": {
  "memory": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"]
  }
}
```

**Capabilities:**
- Remember user preferences
- Store research notes
- Context across sessions

---

## 4. GitHub MCP (Free - Code & Research Repos)

### Install:
```bash
npm install -g @modelcontextprotocol/server-github
```

### Config:
```json
"mcpServers": {
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_TOKEN"
    }
  }
}
```

Get token: https://github.com/settings/tokens

**Capabilities:**
- Access research repos
- Collaborate on papers
- Version control

---

## 5. Puppeteer MCP (Free - Web Scraping)

### Install:
```bash
npm install -g @modelcontextprotocol/server-puppeteer
```

### Config:
```json
"mcpServers": {
  "puppeteer": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
  }
}
```

**Capabilities:**
- Scrape research websites
- Extract data from journals
- Automated data collection

---

## 6. SQLite MCP (Free - Research Database)

### Install:
```bash
npm install -g @modelcontextprotocol/server-sqlite
```

### Config:
```json
"mcpServers": {
  "sqlite": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-sqlite",
      "--db-path",
      "/home/ubuntu/.openclaw/research.db"
    ]
  }
}
```

**Capabilities:**
- Store research data
- Query literature database
- Citation management

---

## Quick Install Script

```bash
#!/bin/bash
# Install Free MCP Servers for Zahra

echo "Installing MCP Servers..."

# Install all free MCP servers
npm install -g \
  @modelcontextprotocol/server-brave-search \
  @modelcontextprotocol/server-filesystem \
  @modelcontextprotocol/server-memory \
  @modelcontextprotocol/server-github \
  @modelcontextprotocol/server-puppeteer \
  @modelcontextprotocol/server-sqlite

echo "✓ MCP Servers installed"
echo ""
echo "Next steps:"
echo "1. Get Brave Search API key: https://brave.com/search/api/"
echo "2. Get GitHub token: https://github.com/settings/tokens"
echo "3. Add to ~/.openclaw/openclaw.json"
echo "4. Restart gateway: openclaw gateway restart"
```

---

## Recommended Setup for Zahra (Top 3 Free)

**Priority 1: Brave Search**
- Essential for real-time research
- Free tier: 2000 queries/month

**Priority 2: Filesystem**
- Organize research files
- No API key needed

**Priority 3: Memory**
- Remember research context
- No API key needed

---

## Full Config Example

```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "YOUR_KEY"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/ubuntu/.openclaw/projects"
      ]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

---

## Testing

After setup, test via Telegram:
- "Search latest research on digital transformation"
- "Save this to my research notes"
- "Remember my research focus is e-commerce"

---

**All free, no credit card required!**
