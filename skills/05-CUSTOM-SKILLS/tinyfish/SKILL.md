---
name: tinyfish
description: AI-powered web automation using TinyFish Web Agent. Use when you need to scrape data from websites, automate form filling, extract structured information, or perform any web-based task using natural language instructions. Works with any website including those with JavaScript, dynamic content, and bot protection.
license: MIT
---

# TinyFish Web Agent Skill

AI-powered web automation that turns natural language into browser actions.

## When to Use This Skill

Use TinyFish when you need to:
- **Scrape data** from websites (prices, contacts, articles, etc.)
- **Automate forms** (filling, submission, multi-step workflows)
- **Extract structured data** (JSON, tables, lists)
- **Monitor websites** (price tracking, content changes)
- **Collect research data** (papers, citations, statistics)
- **Generate leads** (contact information, company data)
- **Test web applications** (automated UI testing)
- **Aggregate content** (news, social media, forums)

## Quick Start

### 1. Start TinyFish MCP Server

```bash
cd E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish
npm start
```

Server runs on `http://localhost:8080`

### 2. Use the Tools

Two tools available:
- `web_scrape` - Extract data from websites
- `web_automation` - Automate tasks on websites

## Tool 1: web_scrape

Extract data from any website using natural language.

### Parameters

- `url` (string, required) - Target website URL
- `goal` (string, required) - Natural language instruction of what to extract

### Examples

**Example 1: Product Price Monitoring**
```json
{
  "url": "https://example.com/products",
  "goal": "Extract all product names, prices, and availability status. Return as JSON array with fields: name, price, inStock."
}
```

**Example 2: Lead Generation**
```json
{
  "url": "https://company-directory.com",
  "goal": "Extract company names, email addresses, phone numbers, and website URLs from the first page. Return as structured JSON."
}
```

**Example 3: News Aggregation**
```json
{
  "url": "https://news-site.com",
  "goal": "Extract the top 10 article titles, authors, publication dates, and article URLs. Return as JSON array."
}
```

**Example 4: Research Data Collection**
```json
{
  "url": "https://scholar.google.com/scholar?q=machine+learning",
  "goal": "Extract the first 5 paper titles, authors, publication years, and citation counts."
}
```

**Example 5: E-commerce Comparison**
```json
{
  "url": "https://store.com/search?q=laptop",
  "goal": "Extract product names, prices, ratings, and review counts for the first 10 results. Return as JSON."
}
```

### Best Practices for web_scrape

1. **Be specific about data fields**
   - ✅ "Extract product name, price, and rating"
   - ❌ "Extract product information"

2. **Specify output format**
   - ✅ "Return as JSON array with fields: name, price, inStock"
   - ❌ "Return the data"

3. **Limit the scope**
   - ✅ "Extract the first 10 products"
   - ❌ "Extract all products" (might timeout)

4. **Include field names**
   - ✅ "Extract: title, author, date, url"
   - ❌ "Extract article information"

## Tool 2: web_automation

Automate tasks on websites (forms, clicks, workflows).

### Parameters

- `url` (string, required) - Target website URL
- `goal` (string, required) - Natural language instruction of what to do

### Examples

**Example 1: Form Filling**
```json
{
  "url": "https://example.com/contact",
  "goal": "Fill the contact form with name 'John Doe', email 'john@example.com', subject 'Inquiry', message 'Test message', and click the submit button."
}
```

**Example 2: Login and Extract**
```json
{
  "url": "https://example.com/login",
  "goal": "Login with username 'testuser' and password 'testpass', then navigate to the dashboard and extract the account balance."
}
```

**Example 3: Multi-step Workflow**
```json
{
  "url": "https://example.com/signup",
  "goal": "Fill signup form with email 'test@example.com', password 'SecurePass123', confirm password, accept terms and conditions, and click register."
}
```

**Example 4: Search and Extract**
```json
{
  "url": "https://example.com",
  "goal": "Search for 'laptop' in the search bar, click search, wait for results, then extract the first 5 product names and prices."
}
```

**Example 5: Data Entry**
```json
{
  "url": "https://example.com/admin/add-product",
  "goal": "Fill product form with name 'New Product', price '99.99', category 'Electronics', description 'Test product', and click save."
}
```

### Best Practices for web_automation

1. **Break down complex tasks**
   - ✅ "Login, navigate to settings, change email, save"
   - ❌ "Update my account settings"

2. **Specify exact values**
   - ✅ "Fill email field with 'test@example.com'"
   - ❌ "Fill the form with test data"

3. **Mention button/link text**
   - ✅ "Click the 'Submit' button"
   - ❌ "Submit the form"

4. **Include expected outcomes**
   - ✅ "Click submit and wait for success message"
   - ❌ "Click submit"

## Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    "items": [
      { "name": "Product 1", "price": "$99" },
      { "name": "Product 2", "price": "$149" }
    ]
  },
  "runId": "a4732944-3192-4e23-8675-865f908a944c",
  "status": "COMPLETED",
  "executionTime": "18s"
}
```

### Error Response

```json
{
  "success": false,
  "error": "TinyFish API Error: Invalid URL"
}
```

## Common Use Cases

### 1. Price Monitoring Bot

Monitor competitor prices daily:

```python
import requests
import schedule

def check_prices():
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': 'https://competitor.com/products',
        'goal': 'Extract all product names and prices. Return as JSON array.'
    })
    
    result = response.json()
    if result['success']:
        # Compare with your prices
        # Send alert if needed
        print(f"Found {len(result['data']['items'])} products")

schedule.every().day.at("09:00").do(check_prices)
```

### 2. Lead Generation

Extract contact information from directories:

```python
def generate_leads(url):
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': url,
        'goal': 'Extract company names, email addresses, phone numbers, and website URLs. Return as JSON array.'
    })
    
    result = response.json()
    if result['success']:
        # Save to database
        # Send to CRM
        return result['data']
```

### 3. Content Aggregation

Collect news articles from multiple sources:

```python
sources = [
    'https://news1.com',
    'https://news2.com',
    'https://news3.com'
]

all_articles = []
for source in sources:
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': source,
        'goal': 'Extract top 5 article titles, authors, and URLs. Return as JSON.'
    })
    
    if response.json()['success']:
        all_articles.extend(response.json()['data']['items'])
```

### 4. Research Data Collection

Extract paper information from academic sites:

```python
def collect_papers(query):
    url = f"https://scholar.google.com/scholar?q={query}"
    
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': url,
        'goal': 'Extract paper titles, authors, years, and citation counts for the first 10 results.'
    })
    
    return response.json()['data']
```

### 5. Form Automation

Automate repetitive form submissions:

```python
def submit_application(data):
    response = requests.post('http://localhost:8080/tools/web_automation', json={
        'url': 'https://example.com/apply',
        'goal': f"Fill application form with name '{data['name']}', email '{data['email']}', phone '{data['phone']}', and submit."
    })
    
    return response.json()['success']
```

## Integration with Bots

### Telegram Bot

```python
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes
import requests

async def scrape_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Usage: /scrape <url> <goal>"""
    if len(context.args) < 2:
        await update.message.reply_text("Usage: /scrape <url> <goal>")
        return
    
    url = context.args[0]
    goal = " ".join(context.args[1:])
    
    await update.message.reply_text(f"🔍 Scraping {url}...")
    
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': url,
        'goal': goal
    })
    
    result = response.json()
    
    if result['success']:
        await update.message.reply_text(
            f"✅ Completed in {result['executionTime']}\n\n"
            f"📊 Result:\n{result['data']}"
        )
    else:
        await update.message.reply_text(f"❌ Error: {result['error']}")
```

### Discord Bot

```python
import discord
from discord.ext import commands
import requests

@bot.command()
async def scrape(ctx, url: str, *, goal: str):
    """Scrape a website using TinyFish"""
    await ctx.send(f"🔍 Scraping {url}...")
    
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': url,
        'goal': goal
    })
    
    result = response.json()
    
    if result['success']:
        embed = discord.Embed(
            title="✅ Scraping Complete",
            description=f"Execution time: {result['executionTime']}",
            color=discord.Color.green()
        )
        embed.add_field(
            name="Result",
            value=f"```json\n{result['data']}\n```",
            inline=False
        )
        await ctx.send(embed=embed)
    else:
        await ctx.send(f"❌ Error: {result['error']}")
```

## Performance

- **Average execution time:** 15-20 seconds
- **Success rate:** High (depends on website complexity)
- **Concurrent requests:** Supported
- **Rate limiting:** Handled by TinyFish API
- **Timeout:** Automatic (managed by TinyFish)

## Troubleshooting

### Server not responding

**Check:**
1. Server is running (`npm start` in tinyfish directory)
2. Port 8080 is accessible
3. No firewall blocking

**Solution:**
```bash
cd E:\ZAHRA-WORKSPACE\mcp-servers\tinyfish
npm start
```

### Empty or incorrect results

**Check:**
1. URL is correct and accessible
2. Goal is specific enough
3. Website hasn't changed structure

**Solution:**
- Make goal more specific
- Include exact field names
- Test with simpler websites first

### Timeout errors

**Possible causes:**
- Website is slow to load
- Complex page with lots of JavaScript
- Anti-bot protection

**Solution:**
- TinyFish handles this automatically
- Wait for completion (15-30 seconds)
- Try again if first attempt fails

## Advanced Features

### Stealth Mode

For websites with bot protection, TinyFish automatically uses stealth mode.

### Proxy Support

TinyFish supports geographic routing through proxies (configured in TinyFish dashboard).

### Real-time Streaming

For long-running tasks, use SSE streaming endpoint (see TinyFish API docs).

## Resources

- **TinyFish Docs:** https://docs.tinyfish.ai/
- **TinyFish Discord:** https://discord.gg/tinyfish
- **Email Support:** support@tinyfish.io
- **API Dashboard:** https://agent.tinyfish.ai/

## License

MIT License

## Author

Zahra AI - AI Chief Digital Officer
