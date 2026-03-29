# WordPress Publisher - Quick Start

Auto-publish content from OpenClaw to WordPress via REST API.

## 🚀 Quick Setup

### 1. Configure WordPress

**Create Application Password:**
1. Login to WordPress admin
2. Go to: **Users → Your Profile**
3. Scroll to **"Application Passwords"**
4. Name: `OpenClaw Integration`
5. Click **"Add New Application Password"**
6. **Copy the password** (shows only once!)

### 2. Configure OpenClaw

Edit `config.json`:

```json
{
  "wordpress": {
    "url": "https://your-site.com",
    "username": "your-username",
    "app_password": "xxxx xxxx xxxx xxxx xxxx xxxx"
  }
}
```

### 3. Test Connection

```bash
bash scripts/test.sh
```

Expected output:
```
✅ Connection successful!
```

## 📝 Usage Examples

### Publish Single Post

```bash
# As draft
bash scripts/publish.sh "My Post Title" "Post content here"

# Publish immediately
bash scripts/publish.sh "My Post Title" "Content" "publish"
```

### Schedule Post

```bash
bash scripts/schedule.sh "Future Post" "Content" "2026-03-20 10:00:00"
```

### Bulk Publish

```bash
# Use example file
bash scripts/bulk.sh posts.example.json

# Or create your own posts.json
bash scripts/bulk.sh my-posts.json
```

## 📋 JSON Format for Bulk Publishing

```json
[
  {
    "title": "Post Title",
    "content": "<p>HTML content here</p>",
    "status": "draft"
  }
]
```

## 🔧 Requirements

- WordPress 5.6+
- `curl` (usually pre-installed)
- `jq` (JSON processor)

### Install jq

**Windows (via Chocolatey):**
```powershell
choco install jq
```

**Linux:**
```bash
sudo apt install jq
```

**macOS:**
```bash
brew install jq
```

## 🛡️ Security

- ✅ Always use HTTPS
- ✅ Application Password (not main password)
- ✅ Config file permissions: `chmod 600 config.json`
- ✅ Rate limiting: 10 posts per minute

## ❌ Troubleshooting

**401 Unauthorized:**
- Regenerate application password
- Check username is correct

**403 Forbidden:**
- User needs Editor or Author role
- Verify REST API is enabled

**Connection failed:**
- Check WordPress URL
- Verify HTTPS is working
- Test: `curl https://your-site.com/wp-json/wp/v2/posts`

## 📚 Files

```
wordpress-publisher/
├── SKILL.md              # Full documentation
├── config.json           # Your credentials
├── posts.example.json    # Example bulk posts
├── README.md             # This file
└── scripts/
    ├── publish.sh        # Publish single post
    ├── test.sh           # Test connection
    ├── schedule.sh       # Schedule post
    └── bulk.sh           # Bulk publish
```

## 🎯 Workflow

```
OpenClaw → Generate Content → Review → Publish → WordPress → Live!
```

## 💡 Tips

- Start with `draft` status to review before publishing
- Use `posts.example.json` as template for bulk publishing
- Test connection before bulk operations
- Schedule posts during off-peak hours

## 📖 More Info

See `SKILL.md` for complete documentation.

---

**Last Updated:** 2026-03-15
