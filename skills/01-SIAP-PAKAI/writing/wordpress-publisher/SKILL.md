---
name: wordpress-publisher
description: "Publish content from OpenClaw to WordPress automatically via REST API. Use when: auto-publishing blog posts, scheduling content, bulk publishing, or managing WordPress content from OpenClaw."
risk: safe
source: openclaw-workspace
metadata:
  openclaw:
    emoji: "📝"
    requires:
      bins: ["curl", "jq"]
---

# WordPress Publisher

Publish drafts from OpenClaw to WordPress automatically via REST API.

## Features

- ✅ Auto-publish to WordPress
- ✅ Schedule posts for future dates
- ✅ Bulk publish from JSON
- ✅ Template-based formatting
- ✅ Draft or publish mode
- ✅ Category & tag support

## Usage

### Publish Single Post

```bash
# Publish as draft
bash skills/wordpress-publisher/scripts/publish.sh "Post Title" "Post content here"

# Publish immediately
bash skills/wordpress-publisher/scripts/publish.sh "Post Title" "Content" "publish"
```

### Test Connection

```bash
bash skills/wordpress-publisher/scripts/test.sh
```

### Schedule Post

```bash
bash skills/wordpress-publisher/scripts/schedule.sh "Title" "Content" "2026-03-20 10:00:00"
```

### Bulk Publish

```bash
# From JSON file
bash skills/wordpress-publisher/scripts/bulk.sh posts.json
```

## Setup

1. **Enable WordPress REST API** (already enabled by default in WP 5.6+)

2. **Create Application Password**:
   - Login to WordPress admin
   - Go to: Users → Your Profile
   - Scroll to "Application Passwords"
   - Add new: "OpenClaw Integration"
   - Copy the generated password

3. **Configure credentials**:
   - Edit `skills/wordpress-publisher/config.json`
   - Add your WordPress URL, username, and app password

4. **Test connection**:
   ```bash
   bash skills/wordpress-publisher/scripts/test.sh
   ```

## Configuration

Edit `config.json`:

```json
{
  "wordpress": {
    "url": "https://your-site.com",
    "username": "your-username",
    "app_password": "xxxx xxxx xxxx xxxx xxxx"
  },
  "defaults": {
    "status": "draft",
    "author": 1
  }
}
```

## Requirements

- WordPress 5.6+ (REST API enabled)
- Application Password configured
- `curl` and `jq` installed

## Security

- ✅ Use HTTPS only
- ✅ Application Password (not main password)
- ✅ Config file permissions: 600
- ✅ Rate limiting: max 10 req/min

## Examples

### Publish Tutorial

```bash
bash skills/wordpress-publisher/scripts/publish.sh \
  "How to Use OpenClaw" \
  "<h1>Tutorial</h1><p>Step by step guide...</p>" \
  "publish"
```

### Bulk Publish

Create `posts.json`:
```json
[
  {"title": "Post 1", "content": "Content 1"},
  {"title": "Post 2", "content": "Content 2"}
]
```

Then:
```bash
bash skills/wordpress-publisher/scripts/bulk.sh posts.json
```

## Troubleshooting

**401 Unauthorized**:
- Check application password
- Regenerate if expired

**403 Forbidden**:
- Check user permissions (need Editor or Author role)
- Verify REST API is enabled

**Connection failed**:
- Verify WordPress URL is correct
- Check HTTPS is working
- Test with: `curl https://your-site.com/wp-json/wp/v2/posts`

## Workflow

```
OpenClaw → Generate Content → Review → Approve → WordPress Publish → Live Post
```

## Last Updated

2026-03-15
