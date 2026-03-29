---
name: TinyFish Web Automation
version: 1.0.0
description: Enterprise web automation untuk AI agents - scraping, form filling, data extraction at scale
tags: [web-automation, scraping, data-extraction, mcp, enterprise]
author: Zahra Maurita
category: web-automation
mcp_server: true
---

# TinyFish Web Automation Skill

Skill untuk mengakses informasi dari internet menggunakan TinyFish AI - enterprise infrastructure untuk web automation agents.

## 🎯 Kapan Menggunakan Skill Ini?

Gunakan skill ini ketika kamu perlu:

- ✅ **Scraping data dari website** - Extract structured data dari web pages
- ✅ **Monitoring harga/stock** - Track product prices & availability
- ✅ **Research kompetitor** - Gather competitive intelligence
- ✅ **Form automation** - Fill & submit web forms automatically
- ✅ **Lead generation** - Extract contact info & business data
- ✅ **News aggregation** - Collect articles & content from multiple sources
- ✅ **Real-time web data** - Get current information from live websites
- ✅ **Multi-site comparison** - Compare data across multiple websites
- ✅ **Academic research** - Extract papers, citations, research data
- ✅ **Social media data** - Gather public profile & post information

## 🚀 Setup

### 1. Install MCP Server

```bash
cd E:/ZAHRA-WORKSPACE/projects/tinyfish-mcp
npm install
npm run build
```

### 2. Get TinyFish API Key

1. Visit https://tinyfish.ai
2. Apply untuk accelerator program atau request API access
3. Dapatkan API key

### 3. Configure MCP Client

**Claude Desktop:**

Edit `%APPDATA%\Claude\claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "tinyfish": {
      "command": "node",
      "args": ["E:/ZAHRA-WORKSPACE/projects/tinyfish-mcp/dist/index.js"],
      "env": {
        "TINYFISH_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

**Cline:**

Add to MCP settings:

```json
{
  "tinyfish": {
    "command": "node",
    "args": ["E:/ZAHRA-WORKSPACE/projects/tinyfish-mcp/dist/index.js"],
    "env": {
      "TINYFISH_API_KEY": "your-api-key-here"
    }
  }
}
```

## 📚 Available Tools

### 1. `tinyfish_run_automation`

Run web automation dengan natural language.

**Use Case:**
- Scraping product data
- Extracting contact information
- Monitoring prices
- Filling forms
- Multi-step workflows

**Example:**
```
Use tinyfish_run_automation:
- goal: "Go to Amazon and find the current price of iPhone 15 Pro 256GB"
```

### 2. `tinyfish_get_run_status`

Check status automation yang sedang berjalan.

**Example:**
```
Use tinyfish_get_run_status:
- run_id: "run_abc123"
```

### 3. `tinyfish_get_run_result`

Get hasil lengkap dari automation.

**Returns:**
- Extracted data
- Screenshots
- Execution logs
- Steps taken

**Example:**
```
Use tinyfish_get_run_result:
- run_id: "run_abc123"
```

### 4. `tinyfish_list_runs`

List semua automation runs.

**Example:**
```
Use tinyfish_list_runs:
- status: "completed"
- limit: 10
```

### 5. `tinyfish_cancel_run`

Cancel running automation.

**Example:**
```
Use tinyfish_cancel_run:
- run_id: "run_abc123"
```

## 💡 Use Cases & Examples

### E-Commerce Price Monitoring

```
Goal: "Compare the price of Sony WH-1000XM5 headphones on Amazon, Best Buy, and Walmart. Extract product name, price, and availability for each site."
```

### Lead Generation

```
Goal: "Visit techcrunch.com and extract the titles, summaries, and publication dates of the 10 most recent AI startup articles"
```

### Form Automation

```
Goal: "Fill out the contact form on example.com with:
- Name: John Doe
- Email: john.doe@example.com
- Message: Interested in your services
Then submit the form"
```

### Competitive Analysis

```
Goal: "Visit competitor-website.com and extract their product categories, featured products, and pricing tiers"
```

### Stock Monitoring

```
Goal: "Check if PlayStation 5 is in stock on Target, Best Buy, and GameStop. Return availability status and price for each."
```

### Academic Research

```
Goal: "Search Google Scholar for 'machine learning transformers' published in 2025-2026, extract the first 10 papers with title, authors, and abstract"
```

### News Aggregation

```
Goal: "Visit news.ycombinator.com and extract the top 20 posts including title, points, number of comments, and URL"
```

### Real Estate Data

```
Goal: "Go to zillow.com, search for apartments in San Francisco under $3000/month, and extract the first 10 listings with address, price, and bedrooms"
```

## 🔄 Workflow Pattern

### Simple Scraping

```
1. Run automation dengan goal yang jelas
2. Get run_id dari response
3. Check status sampai completed
4. Get result untuk extract data
```

### Long-Running Task

```
1. Run automation dengan max_steps & timeout yang lebih besar
2. Periodic check status setiap 30 detik
3. Jika timeout, cancel dan retry dengan parameter berbeda
4. Get result setelah completed
```

### Multi-Site Comparison

```
1. Run automation untuk site 1
2. Run automation untuk site 2 (parallel)
3. Run automation untuk site 3 (parallel)
4. Wait semua completed
5. Get results dari semua runs
6. Compare & aggregate data
```

## ⚙️ Advanced Parameters

### Long Task
```json
{
  "goal": "Extract all products from 20 pages",
  "max_steps": 200,
  "timeout": 900
}
```

### Specific Starting Point
```json
{
  "goal": "Extract job listings",
  "url": "https://careers.example.com/jobs",
  "max_steps": 50
}
```

## 🎯 Integration dengan Workflow Lain

### Dengan Research Workflow

```
1. Use tinyfish untuk scrape latest research papers
2. Use ddg-research untuk deep dive specific topics
3. Use notebooklm untuk synthesize findings
```

### Dengan Content Creation

```
1. Use tinyfish untuk gather trending topics
2. Use content-marketer untuk create content strategy
3. Use copywriting untuk write actual content
```

### Dengan Business Analysis

```
1. Use tinyfish untuk competitive intelligence
2. Use business-analyst untuk market analysis
3. Use startup-analyst untuk business model validation
```

## 🚨 Best Practices

### 1. Be Specific
```
❌ "Get product info"
✅ "Extract product name, price, rating, and availability from Amazon product page"
```

### 2. Set Realistic Limits
```
Simple task: max_steps: 50, timeout: 300
Complex task: max_steps: 200, timeout: 900
```

### 3. Handle Errors
```
- Check status before getting results
- Implement retry logic for failed runs
- Have fallback data sources
```

### 4. Respect Rate Limits
```
- Don't spam requests
- Use parallel runs wisely
- Monitor API usage
```

### 5. Structured Output
```
Specify format dalam goal:
"Extract data in JSON format with fields: name, price, rating, url"
```

## 🔒 Security Notes

- ⚠️ Jangan commit API key ke git
- ⚠️ Use environment variables untuk credentials
- ⚠️ API key memiliki rate limits
- ⚠️ Respect website terms of service
- ⚠️ Don't scrape personal/private data

## 📊 Performance Tips

### Parallel Operations
TinyFish bisa handle 1,000+ parallel operations. Gunakan untuk:
- Multi-site scraping
- Bulk data extraction
- Competitive monitoring

### Caching
- Cache results untuk data yang jarang berubah
- Implement TTL untuk cached data
- Use run_id untuk reference previous results

### Error Recovery
- Implement exponential backoff
- Retry failed runs dengan adjusted parameters
- Log errors untuk debugging

## 🆘 Troubleshooting

### API Key Issues
```
Error: TINYFISH_API_KEY environment variable is required
→ Set API key di MCP config atau environment
```

### Timeout Issues
```
Run timeout sebelum selesai
→ Increase timeout parameter
→ Reduce max_steps
→ Simplify goal
```

### Rate Limit
```
Too many requests
→ Implement rate limiting
→ Use exponential backoff
→ Batch requests
```

### Data Quality
```
Extracted data tidak akurat
→ Be more specific dalam goal
→ Specify exact fields needed
→ Add validation criteria
```

## 📖 Resources

- [TinyFish Website](https://tinyfish.ai)
- [TinyFish Docs](https://docs.tinyfish.ai)
- [MCP Server Code](E:/ZAHRA-WORKSPACE/projects/tinyfish-mcp/)
- [Examples](E:/ZAHRA-WORKSPACE/projects/tinyfish-mcp/EXAMPLES.md)

## 🔄 Updates

**v1.0.0** (2026-03-23)
- Initial release
- 5 core tools
- MCP server implementation
- Comprehensive documentation

---

**Note:** TinyFish API masih dalam development. Beberapa features mungkin berubah. Selalu check dokumentasi terbaru.

## 🎓 Skill Activation

Skill ini aktif ketika:
- User meminta data dari website
- User perlu scraping/extraction
- User butuh real-time web information
- User perlu automation web tasks

Skill ini akan otomatis suggest TinyFish tools ketika detect kebutuhan web automation.
