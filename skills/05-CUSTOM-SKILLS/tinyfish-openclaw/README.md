# TinyFish for OpenClaw

AI-powered web automation integrated with OpenClaw via MCP protocol.

## Overview

This skill enables seamless web scraping and automation within OpenClaw workflows using TinyFish Web Agent. No CSS selectors or XPath needed - just natural language instructions.

## Files

- **SKILL.md** (7.8KB) - Complete skill documentation
- **workflows.md** (11.3KB) - 5 complete workflow examples
- **README.md** (this file)

## Quick Start

### 1. Ensure TinyFish MCP Server is Running

```bash
cd E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish
npm start
```

### 2. Use in OpenClaw

```bash
# Scrape a website
openclaw tinyfish scrape "https://example.com" "Extract product names and prices"

# Automate a task
openclaw tinyfish automate "https://example.com/contact" "Fill form and submit"
```

## What You Can Do

### 1. Web Scraping
- Extract product prices and information
- Collect contact information (emails, phones)
- Aggregate news articles and content
- Gather research data (papers, citations)
- Monitor competitor websites
- Track market trends

### 2. Web Automation
- Fill and submit forms automatically
- Login to websites and extract data
- Complete multi-step workflows
- Automate repetitive browser tasks
- Test web applications
- Schedule automated tasks

### 3. OpenClaw Integration
- Use in workflows (YAML)
- Schedule with cron
- Chain with other tools
- Pipe data between steps
- Trigger notifications
- Save to databases

## Example Workflows

### Price Monitoring

```yaml
name: Price Monitor
schedule: "0 */6 * * *"
steps:
  - name: Scrape Prices
    tool: tinyfish
    action: scrape
    params:
      url: "https://competitor.com"
      goal: "Extract product prices"
  - name: Send Alert
    command: notify --message "Prices updated"
```

### Lead Generation

```yaml
name: Lead Generation
trigger: manual
steps:
  - name: Scrape Directory
    tool: tinyfish
    action: scrape
    params:
      url: "https://directory.com"
      goal: "Extract company contacts"
  - name: Save to Database
    command: save-to-db --table leads
```

### Content Aggregation

```yaml
name: Content Aggregator
schedule: "0 8 * * *"
steps:
  - name: Scrape News
    tool: tinyfish
    action: scrape
    params:
      url: "https://news-site.com"
      goal: "Extract top articles"
  - name: Post to Social
    command: post-to-twitter
```

## Use Cases

1. **E-commerce** - Price monitoring, product tracking
2. **Lead Generation** - Contact extraction, prospect building
3. **Content Marketing** - News aggregation, trend monitoring
4. **Research** - Paper collection, citation tracking
5. **Market Intelligence** - Competitor monitoring, trend analysis
6. **Automation** - Form filling, data entry
7. **Testing** - Automated UI testing
8. **Data Migration** - Extract from legacy systems

## Features

- ✅ Natural language control
- ✅ MCP protocol integration
- ✅ OpenClaw workflow support
- ✅ Scheduled automation
- ✅ Error handling
- ✅ Structured JSON output
- ✅ Anti-bot detection
- ✅ Production ready

## Documentation

- **Full Documentation:** See SKILL.md
- **Workflow Examples:** See workflows.md
- **MCP Server:** E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish\
- **TinyFish Docs:** https://docs.tinyfish.ai/

## Configuration

TinyFish is configured in OpenClaw's MCP settings:

```json
{
  "mcp": {
    "servers": {
      "tinyfish": {
        "command": "node",
        "args": ["E:\\ZAHRA-WORKSPACE\\mcp-servers\\tinyfish\\server.js"],
        "env": {
          "TINYFISH_API_KEY": "sk-tinyfish-F2ZFleAQ680jRwwSB2UKLuimrAJuELaT",
          "PORT": "8080"
        }
      }
    }
  }
}
```

## Performance

- **Average execution time:** 15-30 seconds
- **Success rate:** High (depends on website)
- **Concurrent requests:** Supported
- **Rate limiting:** Handled automatically

## Troubleshooting

### Server not responding
```bash
curl http://localhost:8080/health
cd E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish && npm start
```

### Timeout errors
- Simplify the goal
- Try again (some sites are slow)
- Check website accessibility

### Empty results
- Make goal more specific
- Verify URL is correct
- Check website structure

## Resources

- **TinyFish API:** https://docs.tinyfish.ai/
- **OpenClaw Docs:** E:\ZAHRA-WORKSPACE\docs
- **Support:** https://discord.gg/tinyfish

## Status

✅ **Production Ready**

- MCP server tested and working
- OpenClaw integration complete
- Workflow examples provided
- Documentation complete

## Author

Zahra AI - AI Chief Digital Officer  
Created: 2026-03-29  
Status: Production Ready 🚀
