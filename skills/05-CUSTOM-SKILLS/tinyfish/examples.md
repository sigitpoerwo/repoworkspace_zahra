# TinyFish Skill - Usage Examples

## Quick Examples

### 1. Simple Product Scraping

**Goal:** Extract product information from an e-commerce site

```python
import requests

response = requests.post('http://localhost:8080/tools/web_scrape', json={
    'url': 'https://scrapeme.live/shop',
    'goal': 'Extract the first 5 product names and prices. Return as JSON array.'
})

result = response.json()
print(result['data'])
```

**Output:**
```json
{
  "items": [
    { "name": "Bulbasaur", "price": "£63.00" },
    { "name": "Ivysaur", "price": "£87.00" },
    { "name": "Venusaur", "price": "£105.00" },
    { "name": "Charmander", "price": "£48.00" },
    { "name": "Charmeleon", "price": "£165.00" }
  ]
}
```

### 2. Contact Information Extraction

**Goal:** Generate leads from a business directory

```python
response = requests.post('http://localhost:8080/tools/web_scrape', json={
    'url': 'https://business-directory.com/companies',
    'goal': 'Extract company names, email addresses, phone numbers, and website URLs. Return as JSON array with fields: company, email, phone, website.'
})
```

### 3. News Article Aggregation

**Goal:** Collect latest news articles

```python
response = requests.post('http://localhost:8080/tools/web_scrape', json={
    'url': 'https://news-site.com',
    'goal': 'Extract the top 10 article titles, authors, publication dates, and article URLs. Return as JSON array.'
})
```

### 4. Form Automation

**Goal:** Automate contact form submission

```python
response = requests.post('http://localhost:8080/tools/web_automation', json={
    'url': 'https://example.com/contact',
    'goal': 'Fill the contact form with name "John Doe", email "john@example.com", subject "Inquiry", message "I would like more information", and click submit.'
})
```

### 5. Price Monitoring

**Goal:** Track competitor prices

```python
response = requests.post('http://localhost:8080/tools/web_scrape', json={
    'url': 'https://competitor.com/products',
    'goal': 'Extract all product names, current prices, and discount percentages. Return as JSON array with fields: name, price, discount.'
})
```

## Advanced Examples

### 6. Multi-page Scraping

**Goal:** Scrape data from multiple pages

```python
base_url = 'https://example.com/products?page='
all_products = []

for page in range(1, 6):  # Pages 1-5
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': f'{base_url}{page}',
        'goal': 'Extract all product names and prices. Return as JSON array.'
    })
    
    if response.json()['success']:
        all_products.extend(response.json()['data']['items'])

print(f"Total products: {len(all_products)}")
```

### 7. Scheduled Monitoring

**Goal:** Monitor website changes every hour

```python
import schedule
import time

def check_website():
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': 'https://example.com/status',
        'goal': 'Extract the current status message and last update time.'
    })
    
    result = response.json()
    if result['success']:
        print(f"Status: {result['data']}")
        # Send notification if status changed

schedule.every().hour.do(check_website)

while True:
    schedule.run_pending()
    time.sleep(60)
```

### 8. Database Integration

**Goal:** Save scraped data to database

```python
import sqlite3

def scrape_and_save(url, goal):
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': url,
        'goal': goal
    })
    
    result = response.json()
    
    if result['success']:
        conn = sqlite3.connect('scraping_results.db')
        cursor = conn.cursor()
        
        for item in result['data']['items']:
            cursor.execute('''
                INSERT INTO products (name, price, scraped_at)
                VALUES (?, ?, datetime('now'))
            ''', (item['name'], item['price']))
        
        conn.commit()
        conn.close()
        
        return len(result['data']['items'])
```

### 9. Comparison Shopping

**Goal:** Compare prices across multiple stores

```python
stores = [
    'https://store1.com/product/laptop',
    'https://store2.com/product/laptop',
    'https://store3.com/product/laptop'
]

prices = []

for store in stores:
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': store,
        'goal': 'Extract product name, price, and availability. Return as JSON.'
    })
    
    if response.json()['success']:
        prices.append(response.json()['data'])

# Find best price
best_deal = min(prices, key=lambda x: float(x['price'].replace('$', '')))
print(f"Best deal: {best_deal}")
```

### 10. Research Paper Collection

**Goal:** Collect academic papers for research

```python
def collect_papers(query, max_results=20):
    url = f"https://scholar.google.com/scholar?q={query}"
    
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': url,
        'goal': f'Extract the first {max_results} paper titles, authors, publication years, citation counts, and paper URLs. Return as JSON array.'
    })
    
    result = response.json()
    
    if result['success']:
        papers = result['data']['items']
        
        # Save to CSV
        import csv
        with open('papers.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=papers[0].keys())
            writer.writeheader()
            writer.writerows(papers)
        
        return papers
```

## Integration Examples

### Telegram Bot Integration

```python
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes
import requests

TINYFISH_URL = 'http://localhost:8080'

async def price_check(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Check product price: /price <url>"""
    if not context.args:
        await update.message.reply_text("Usage: /price <product_url>")
        return
    
    url = context.args[0]
    await update.message.reply_text("🔍 Checking price...")
    
    response = requests.post(f'{TINYFISH_URL}/tools/web_scrape', json={
        'url': url,
        'goal': 'Extract product name, current price, and availability status.'
    })
    
    result = response.json()
    
    if result['success']:
        data = result['data']
        await update.message.reply_text(
            f"📦 {data['name']}\n"
            f"💰 Price: {data['price']}\n"
            f"✅ Status: {data['availability']}"
        )
    else:
        await update.message.reply_text(f"❌ Error: {result['error']}")

async def scrape_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Scrape website: /scrape <url> <goal>"""
    if len(context.args) < 2:
        await update.message.reply_text("Usage: /scrape <url> <goal>")
        return
    
    url = context.args[0]
    goal = " ".join(context.args[1:])
    
    await update.message.reply_text(f"🔍 Scraping {url}...")
    
    response = requests.post(f'{TINYFISH_URL}/tools/web_scrape', json={
        'url': url,
        'goal': goal
    })
    
    result = response.json()
    
    if result['success']:
        await update.message.reply_text(
            f"✅ Completed in {result['executionTime']}\n\n"
            f"📊 Result:\n```json\n{result['data']}\n```",
            parse_mode='Markdown'
        )
    else:
        await update.message.reply_text(f"❌ Error: {result['error']}")

# Setup bot
app = Application.builder().token("YOUR_BOT_TOKEN").build()
app.add_handler(CommandHandler("price", price_check))
app.add_handler(CommandHandler("scrape", scrape_command))
app.run_polling()
```

### Discord Bot Integration

```python
import discord
from discord.ext import commands
import requests

TINYFISH_URL = 'http://localhost:8080'

bot = commands.Bot(command_prefix='!')

@bot.command()
async def scrape(ctx, url: str, *, goal: str):
    """Scrape a website: !scrape <url> <goal>"""
    await ctx.send(f"🔍 Scraping {url}...")
    
    response = requests.post(f'{TINYFISH_URL}/tools/web_scrape', json={
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

@bot.command()
async def monitor(ctx, url: str):
    """Monitor a website for changes"""
    await ctx.send(f"👀 Monitoring {url}...")
    
    # Initial scrape
    response = requests.post(f'{TINYFISH_URL}/tools/web_scrape', json={
        'url': url,
        'goal': 'Extract all visible text content.'
    })
    
    if response.json()['success']:
        await ctx.send("✅ Monitoring started. I'll notify you of changes.")
        # Store initial state and set up periodic checks

bot.run("YOUR_BOT_TOKEN")
```

### FastAPI Integration

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import requests

app = FastAPI()
TINYFISH_URL = 'http://localhost:8080'

class ScrapeRequest(BaseModel):
    url: str
    goal: str

@app.post("/scrape")
async def scrape_website(request: ScrapeRequest):
    response = requests.post(f'{TINYFISH_URL}/tools/web_scrape', json={
        'url': request.url,
        'goal': request.goal
    })
    
    result = response.json()
    
    if not result['success']:
        raise HTTPException(status_code=500, detail=result['error'])
    
    return result

@app.get("/price/{product_id}")
async def get_price(product_id: str):
    url = f"https://example.com/product/{product_id}"
    
    response = requests.post(f'{TINYFISH_URL}/tools/web_scrape', json={
        'url': url,
        'goal': 'Extract product name, price, and availability.'
    })
    
    result = response.json()
    
    if not result['success']:
        raise HTTPException(status_code=500, detail=result['error'])
    
    return result['data']
```

## Tips for Better Results

### 1. Be Specific

❌ Bad: "Extract product information"
✅ Good: "Extract product name, price, rating, and review count"

### 2. Specify Format

❌ Bad: "Get the data"
✅ Good: "Return as JSON array with fields: name, price, inStock"

### 3. Limit Scope

❌ Bad: "Extract all products"
✅ Good: "Extract the first 10 products"

### 4. Include Field Names

❌ Bad: "Get article details"
✅ Good: "Extract: title, author, date, url"

### 5. Handle Errors

```python
response = requests.post('http://localhost:8080/tools/web_scrape', json={
    'url': url,
    'goal': goal
})

result = response.json()

if result['success']:
    # Process data
    data = result['data']
else:
    # Handle error
    print(f"Error: {result['error']}")
    # Retry or log
```

## Common Patterns

### Pattern 1: Retry on Failure

```python
def scrape_with_retry(url, goal, max_retries=3):
    for attempt in range(max_retries):
        response = requests.post('http://localhost:8080/tools/web_scrape', json={
            'url': url,
            'goal': goal
        })
        
        result = response.json()
        
        if result['success']:
            return result['data']
        
        if attempt < max_retries - 1:
            time.sleep(5)  # Wait before retry
    
    return None
```

### Pattern 2: Batch Processing

```python
def scrape_batch(urls, goal):
    results = []
    
    for url in urls:
        response = requests.post('http://localhost:8080/tools/web_scrape', json={
            'url': url,
            'goal': goal
        })
        
        if response.json()['success']:
            results.append(response.json()['data'])
        
        time.sleep(1)  # Rate limiting
    
    return results
```

### Pattern 3: Cache Results

```python
import json
from datetime import datetime, timedelta

cache = {}

def scrape_with_cache(url, goal, cache_duration=3600):
    cache_key = f"{url}:{goal}"
    
    # Check cache
    if cache_key in cache:
        cached_data, cached_time = cache[cache_key]
        if datetime.now() - cached_time < timedelta(seconds=cache_duration):
            return cached_data
    
    # Scrape
    response = requests.post('http://localhost:8080/tools/web_scrape', json={
        'url': url,
        'goal': goal
    })
    
    result = response.json()
    
    if result['success']:
        cache[cache_key] = (result['data'], datetime.now())
        return result['data']
    
    return None
```

---

**Created:** 2026-03-29  
**Author:** Zahra AI  
**Status:** Production Ready
