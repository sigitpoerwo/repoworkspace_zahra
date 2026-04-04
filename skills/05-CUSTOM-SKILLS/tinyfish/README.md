# TinyFish Skill

AI-powered web automation using TinyFish Web Agent.

## Overview

This skill enables web scraping and automation using natural language instructions. No CSS selectors or XPath needed - just describe what you want to extract or automate.

## Files

- **SKILL.md** (11.2KB) - Complete skill documentation
- **examples.md** (12.8KB) - 10 usage examples with code
- **README.md** (this file)

## Quick Start

### 1. Start TinyFish MCP Server

```bash
cd E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish
npm start
```

### 2. Use in Your Code

```python
import requests

response = requests.post('http://localhost:8080/tools/web_scrape', json={
    'url': 'https://example.com',
    'goal': 'Extract product names and prices. Return as JSON.'
})

result = response.json()
print(result['data'])
```

## Features

- ✅ Natural language control
- ✅ Web scraping (data extraction)
- ✅ Web automation (forms, clicks)
- ✅ Anti-bot detection (stealth mode)
- ✅ Structured JSON output
- ✅ Bot integration ready

## Use Cases

1. **E-commerce** - Price monitoring, product scraping
2. **Lead Generation** - Contact info extraction
3. **Content Aggregation** - News, articles, social media
4. **Research** - Academic papers, citations
5. **Market Intelligence** - Competitor analysis
6. **Form Automation** - Data entry, submissions
7. **Web Testing** - Automated UI testing
8. **Data Migration** - Extract from old systems

## Documentation

- **Full Documentation:** See SKILL.md
- **Code Examples:** See examples.md
- **MCP Server:** E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish\
- **API Docs:** https://docs.tinyfish.ai/

## Status

✅ **Production Ready**

- Server tested and working
- Documentation complete
- Examples provided
- Bot integration ready

## Author

Zahra AI - AI Chief Digital Officer  
Created: 2026-03-29
