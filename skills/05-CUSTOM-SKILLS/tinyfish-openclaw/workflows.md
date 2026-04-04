# TinyFish OpenClaw Workflows

Complete workflow examples for common automation tasks.

## Workflow 1: E-commerce Price Monitor

Monitor competitor prices and send alerts when prices drop.

```yaml
# .openclaw/workflows/price-monitor.yml
name: E-commerce Price Monitor
description: Monitor competitor prices and alert on changes
schedule: "0 */6 * * *"  # Every 6 hours

steps:
  - name: Scrape Competitor Prices
    tool: tinyfish
    action: scrape
    params:
      url: "https://competitor.com/products"
      goal: "Extract all product names, current prices, and discount percentages. Return as JSON array with fields: name, price, discount, url"
    output: competitor_prices

  - name: Load Our Prices
    command: cat data/our-prices.json
    output: our_prices

  - name: Compare Prices
    script: |
      import json
      competitor = json.loads('$competitor_prices')
      ours = json.loads('$our_prices')
      
      alerts = []
      for comp_product in competitor['items']:
          for our_product in ours:
              if comp_product['name'] == our_product['name']:
                  comp_price = float(comp_product['price'].replace('$', ''))
                  our_price = float(our_product['price'].replace('$', ''))
                  
                  if comp_price < our_price:
                      alerts.append({
                          'product': comp_product['name'],
                          'our_price': our_price,
                          'competitor_price': comp_price,
                          'difference': our_price - comp_price
                      })
      
      print(json.dumps(alerts))
    output: price_alerts

  - name: Send Alerts
    condition: len($price_alerts) > 0
    command: openclaw notify --channel telegram --message "Price alerts: $price_alerts"
```

## Workflow 2: Lead Generation Pipeline

Scrape business directories and build lead database.

```yaml
# .openclaw/workflows/lead-generation.yml
name: Lead Generation Pipeline
description: Scrape directories and build lead database
trigger: manual

steps:
  - name: Scrape Business Directory
    tool: tinyfish
    action: scrape
    params:
      url: "https://business-directory.com/companies"
      goal: "Extract company names, email addresses, phone numbers, website URLs, and industry. Return as JSON array with fields: company, email, phone, website, industry"
    output: raw_leads

  - name: Validate Emails
    script: |
      import json
      import re
      
      leads = json.loads('$raw_leads')
      valid_leads = []
      
      email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
      
      for lead in leads['items']:
          if re.match(email_pattern, lead['email']):
              valid_leads.append(lead)
      
      print(json.dumps(valid_leads))
    output: validated_leads

  - name: Save to Database
    command: |
      echo '$validated_leads' | jq -r '.[] | [.company, .email, .phone, .website, .industry] | @csv' >> data/leads.csv
    output: save_result

  - name: Send to CRM
    command: crm-sync --source data/leads.csv --target salesforce

  - name: Send Summary
    command: |
      TOTAL=$(echo '$validated_leads' | jq 'length')
      openclaw notify --channel telegram --message "Lead generation complete: $TOTAL new leads added"
```

## Workflow 3: Content Aggregator

Aggregate content from multiple sources and post to social media.

```yaml
# .openclaw/workflows/content-aggregator.yml
name: Content Aggregator
description: Aggregate news from multiple sources
schedule: "0 8,14,20 * * *"  # 8 AM, 2 PM, 8 PM

steps:
  - name: Scrape Tech News
    tool: tinyfish
    action: scrape
    params:
      url: "https://news.ycombinator.com"
      goal: "Extract top 10 post titles, points, and URLs. Return as JSON array"
    output: tech_news

  - name: Scrape Industry News
    tool: tinyfish
    action: scrape
    params:
      url: "https://industry-news.com"
      goal: "Extract top 10 article titles, authors, and URLs. Return as JSON array"
    output: industry_news

  - name: Scrape Research Papers
    tool: tinyfish
    action: scrape
    params:
      url: "https://arxiv.org/list/cs.AI/recent"
      goal: "Extract top 5 paper titles, authors, and URLs. Return as JSON array"
    output: research_papers

  - name: Merge All Content
    script: |
      import json
      
      tech = json.loads('$tech_news')
      industry = json.loads('$industry_news')
      research = json.loads('$research_papers')
      
      merged = {
          'tech': tech['items'][:5],
          'industry': industry['items'][:5],
          'research': research['items'][:3]
      }
      
      print(json.dumps(merged))
    output: merged_content

  - name: Format for Social Media
    script: |
      import json
      
      content = json.loads('$merged_content')
      
      post = "📰 Daily Tech Digest\n\n"
      post += "🔥 Trending:\n"
      for item in content['tech']:
          post += f"• {item['title']}\n"
      
      post += "\n📊 Industry News:\n"
      for item in content['industry']:
          post += f"• {item['title']}\n"
      
      post += "\n🔬 Research:\n"
      for item in content['research']:
          post += f"• {item['title']}\n"
      
      print(post)
    output: social_post

  - name: Post to Twitter
    command: twitter-post --message "$social_post"

  - name: Post to LinkedIn
    command: linkedin-post --message "$social_post"

  - name: Post to Telegram
    command: openclaw notify --channel telegram --message "$social_post"
```

## Workflow 4: Research Data Collector

Collect academic papers and build research database.

```yaml
# .openclaw/workflows/research-collector.yml
name: Research Data Collector
description: Collect academic papers from multiple sources
trigger: manual
params:
  - name: query
    type: string
    required: true
  - name: max_results
    type: integer
    default: 20

steps:
  - name: Search Google Scholar
    tool: tinyfish
    action: scrape
    params:
      url: "https://scholar.google.com/scholar?q=$query"
      goal: "Extract first $max_results paper titles, authors, years, citation counts, and URLs. Return as JSON array"
    output: scholar_results

  - name: Search arXiv
    tool: tinyfish
    action: scrape
    params:
      url: "https://arxiv.org/search/?query=$query"
      goal: "Extract first $max_results paper titles, authors, dates, and URLs. Return as JSON array"
    output: arxiv_results

  - name: Merge Results
    script: |
      import json
      
      scholar = json.loads('$scholar_results')
      arxiv = json.loads('$arxiv_results')
      
      all_papers = scholar['items'] + arxiv['items']
      
      # Remove duplicates by title
      seen = set()
      unique_papers = []
      for paper in all_papers:
          if paper['title'] not in seen:
              seen.add(paper['title'])
              unique_papers.append(paper)
      
      print(json.dumps({'papers': unique_papers}))
    output: all_papers

  - name: Save to Database
    command: |
      echo '$all_papers' | jq -r '.papers[] | [.title, .authors, .year, .citations, .url] | @csv' >> data/research-$query.csv

  - name: Generate Summary
    script: |
      import json
      
      papers = json.loads('$all_papers')
      total = len(papers['papers'])
      
      summary = f"Research collection complete for query: $query\n"
      summary += f"Total papers found: {total}\n\n"
      summary += "Top 5 papers:\n"
      
      for i, paper in enumerate(papers['papers'][:5], 1):
          summary += f"{i}. {paper['title']}\n"
      
      print(summary)
    output: summary

  - name: Send Summary
    command: openclaw notify --channel telegram --message "$summary"
```

## Workflow 5: Market Intelligence

Monitor competitor activities and market trends.

```yaml
# .openclaw/workflows/market-intelligence.yml
name: Market Intelligence
description: Monitor competitors and market trends
schedule: "0 10 * * 1"  # Every Monday at 10 AM

steps:
  - name: Scrape Competitor Blog
    tool: tinyfish
    action: scrape
    params:
      url: "https://competitor.com/blog"
      goal: "Extract latest 10 blog post titles, dates, and URLs. Return as JSON array"
    output: competitor_blog

  - name: Scrape Competitor Products
    tool: tinyfish
    action: scrape
    params:
      url: "https://competitor.com/products"
      goal: "Extract all product names, prices, and features. Return as JSON array"
    output: competitor_products

  - name: Scrape Industry News
    tool: tinyfish
    action: scrape
    params:
      url: "https://industry-news.com"
      goal: "Extract articles mentioning our company or competitors. Return as JSON array"
    output: industry_mentions

  - name: Analyze Trends
    script: |
      import json
      from collections import Counter
      
      blog = json.loads('$competitor_blog')
      products = json.loads('$competitor_products')
      news = json.loads('$industry_mentions')
      
      # Extract keywords from titles
      keywords = []
      for post in blog['items']:
          keywords.extend(post['title'].lower().split())
      
      # Count top keywords
      keyword_counts = Counter(keywords).most_common(10)
      
      report = {
          'competitor_activity': {
              'blog_posts': len(blog['items']),
              'products': len(products['items']),
              'trending_keywords': keyword_counts
          },
          'industry_mentions': len(news['items'])
      }
      
      print(json.dumps(report))
    output: intelligence_report

  - name: Generate Weekly Report
    script: |
      import json
      
      report = json.loads('$intelligence_report')
      
      message = "📊 Weekly Market Intelligence Report\n\n"
      message += f"Competitor Activity:\n"
      message += f"• Blog posts: {report['competitor_activity']['blog_posts']}\n"
      message += f"• Products: {report['competitor_activity']['products']}\n"
      message += f"• Industry mentions: {report['industry_mentions']}\n\n"
      message += "🔥 Trending Keywords:\n"
      
      for keyword, count in report['competitor_activity']['trending_keywords']:
          message += f"• {keyword}: {count}\n"
      
      print(message)
    output: weekly_report

  - name: Send Report
    command: openclaw notify --channel telegram --message "$weekly_report"

  - name: Save Report
    command: echo "$weekly_report" >> reports/market-intelligence-$(date +%Y-%m-%d).txt
```

## Usage

### Run a Workflow

```bash
# Run manually
openclaw workflow run price-monitor

# Run with parameters
openclaw workflow run research-collector --query "machine learning" --max-results 50

# Schedule a workflow
openclaw workflow schedule content-aggregator --cron "0 8 * * *"
```

### List Workflows

```bash
openclaw workflow list
```

### View Workflow Status

```bash
openclaw workflow status price-monitor
```

### View Workflow Logs

```bash
openclaw workflow logs price-monitor
```

## Tips

1. **Test workflows manually first** before scheduling
2. **Use small datasets** for testing
3. **Add error handling** for production workflows
4. **Monitor execution time** and optimize if needed
5. **Set up alerts** for workflow failures

## Author

Zahra AI - AI Chief Digital Officer  
Created: 2026-03-29
