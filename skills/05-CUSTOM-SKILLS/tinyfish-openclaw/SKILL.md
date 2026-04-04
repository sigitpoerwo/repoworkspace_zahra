---
name: tinyfish-openclaw
description: TinyFish Web Agent integration for OpenClaw. Use this skill to scrape websites, automate web tasks, extract structured data, and perform browser automation using natural language. Works seamlessly with OpenClaw's MCP protocol.
license: MIT
---

# TinyFish for OpenClaw

AI-powered web automation integrated with OpenClaw via MCP protocol.

## Quick Start

The TinyFish MCP server is already configured and running. You can use it directly through OpenClaw commands.

### Basic Usage

```bash
# Scrape a website
tinyfish scrape "https://example.com" "Extract product names and prices"

# Automate a task
tinyfish automate "https://example.com/contact" "Fill form with name John Doe and submit"
```

## Available Commands

### 1. tinyfish scrape

Extract data from websites using natural language.

**Syntax:**
```bash
tinyfish scrape <url> <goal>
```

**Examples:**

```bash
# Extract product information
tinyfish scrape "https://store.com/products" "Extract first 10 product names, prices, and ratings as JSON"

# Collect contact information
tinyfish scrape "https://directory.com" "Extract company names, emails, and phone numbers"

# Aggregate news
tinyfish scrape "https://news-site.com" "Extract top 5 article titles, authors, and URLs"

# Research data
tinyfish scrape "https://scholar.google.com/scholar?q=AI" "Extract paper titles, authors, and citation counts"

# Price monitoring
tinyfish scrape "https://competitor.com/product" "Extract product name, current price, and discount"
```

### 2. tinyfish automate

Automate tasks on websites.

**Syntax:**
```bash
tinyfish automate <url> <goal>
```

**Examples:**

```bash
# Form filling
tinyfish automate "https://example.com/contact" "Fill name 'John Doe', email 'john@example.com', and submit"

# Login and extract
tinyfish automate "https://example.com/login" "Login with username 'test' password 'pass123', go to dashboard, extract balance"

# Multi-step workflow
tinyfish automate "https://example.com/signup" "Fill signup form, accept terms, click register"

# Search and extract
tinyfish automate "https://example.com" "Search for 'laptop', click search, extract first 5 results"
```

## Integration with OpenClaw Workflows

### Workflow 1: Daily Price Monitoring

Create a cron job in OpenClaw:

```yaml
# .openclaw/workflows/price-monitor.yml
name: Daily Price Monitor
schedule: "0 9 * * *"  # Every day at 9 AM
steps:
  - name: Check Competitor Prices
    command: tinyfish scrape "https://competitor.com/products" "Extract all product names and prices as JSON"
  - name: Compare with Our Prices
    command: compare-prices --input $PREVIOUS_OUTPUT
  - name: Send Alert
    command: notify --channel telegram --message "Price changes detected"
```

### Workflow 2: Lead Generation

```yaml
# .openclaw/workflows/lead-gen.yml
name: Lead Generation
trigger: manual
steps:
  - name: Scrape Directory
    command: tinyfish scrape "https://business-directory.com" "Extract company names, emails, phones, websites"
  - name: Save to Database
    command: save-to-db --table leads --data $PREVIOUS_OUTPUT
  - name: Send to CRM
    command: crm-sync --source leads
```

### Workflow 3: Content Aggregation

```yaml
# .openclaw/workflows/content-aggregator.yml
name: Content Aggregator
schedule: "0 */6 * * *"  # Every 6 hours
steps:
  - name: Scrape News Site 1
    command: tinyfish scrape "https://news1.com" "Extract top 10 articles with titles, authors, URLs"
  - name: Scrape News Site 2
    command: tinyfish scrape "https://news2.com" "Extract top 10 articles with titles, authors, URLs"
  - name: Merge Results
    command: merge-json --files $STEP1_OUTPUT $STEP2_OUTPUT
  - name: Post to Channel
    command: post-to-discord --channel news --data $PREVIOUS_OUTPUT
```

## Advanced Usage

### Using with OpenClaw Scripts

```bash
#!/bin/bash
# monitor-prices.sh

# Scrape competitor prices
PRICES=$(tinyfish scrape "https://competitor.com/products" "Extract product names and prices as JSON")

# Parse and compare
echo "$PRICES" | jq '.items[] | select(.price < 100)'

# Send alert if needed
if [ $? -eq 0 ]; then
    openclaw notify --message "Low prices detected!"
fi
```

### Using with OpenClaw Agents

```python
# openclaw-agent.py
import subprocess
import json

def scrape_website(url, goal):
    result = subprocess.run(
        ['openclaw', 'tinyfish', 'scrape', url, goal],
        capture_output=True,
        text=True
    )
    return json.loads(result.stdout)

# Usage
data = scrape_website(
    'https://example.com',
    'Extract product information'
)

print(f"Found {len(data['items'])} products")
```

## Configuration

### MCP Server Settings

The TinyFish MCP server is configured in OpenClaw's config:

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

### Environment Variables

Set in `.openclaw/env`:

```bash
TINYFISH_API_KEY=sk-tinyfish-F2ZFleAQ680jRwwSB2UKLuimrAJuELaT
TINYFISH_URL=http://localhost:8080
```

## Best Practices

### 1. Write Clear Goals

❌ Bad: "Get data"
✅ Good: "Extract product names, prices, and ratings as JSON array"

### 2. Specify Output Format

❌ Bad: "Extract products"
✅ Good: "Extract products as JSON with fields: name, price, inStock"

### 3. Limit Scope

❌ Bad: "Extract all products"
✅ Good: "Extract first 10 products"

### 4. Handle Errors

```bash
if tinyfish scrape "$URL" "$GOAL"; then
    echo "Success"
else
    echo "Failed, retrying..."
    sleep 5
    tinyfish scrape "$URL" "$GOAL"
fi
```

### 5. Use Caching

```bash
# Cache results for 1 hour
CACHE_FILE="/tmp/tinyfish-cache-$(echo $URL | md5sum | cut -d' ' -f1)"

if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt 3600 ]; then
    cat "$CACHE_FILE"
else
    tinyfish scrape "$URL" "$GOAL" | tee "$CACHE_FILE"
fi
```

## Common Use Cases

### 1. Price Monitoring Bot

```bash
# Check prices every hour
*/60 * * * * tinyfish scrape "https://competitor.com" "Extract prices" | openclaw notify
```

### 2. Lead Generation

```bash
# Generate leads from directory
tinyfish scrape "https://directory.com" "Extract contacts" | openclaw save-leads
```

### 3. Content Aggregation

```bash
# Aggregate news from multiple sources
for site in news1.com news2.com news3.com; do
    tinyfish scrape "https://$site" "Extract articles"
done | openclaw merge-and-post
```

### 4. Research Data Collection

```bash
# Collect academic papers
tinyfish scrape "https://scholar.google.com/scholar?q=$QUERY" "Extract papers" | openclaw save-research
```

### 5. Market Intelligence

```bash
# Monitor competitor activities
tinyfish scrape "https://competitor.com/blog" "Extract latest posts" | openclaw analyze-trends
```

## Troubleshooting

### Server Not Responding

```bash
# Check server status
curl http://localhost:8080/health

# Restart server
cd E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish
npm start
```

### Timeout Errors

- Increase timeout in OpenClaw config
- Simplify the goal
- Try again (some sites are slow)

### Empty Results

- Make goal more specific
- Check if URL is correct
- Verify website is accessible

## Performance

- **Average execution time:** 15-30 seconds
- **Success rate:** High (depends on website)
- **Concurrent requests:** Supported
- **Rate limiting:** Handled automatically

## Resources

- **TinyFish Docs:** https://docs.tinyfish.ai/
- **OpenClaw Docs:** E:\ZAHRA-WORKSPACE\docs
- **MCP Server:** E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish
- **Support:** https://discord.gg/tinyfish

## License

MIT License

## Author

Zahra AI - AI Chief Digital Officer  
Created: 2026-03-29
