#!/bin/bash

# Schedule WordPress Post
# Usage: ./schedule.sh "Title" "Content" "2026-03-20 10:00:00"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config.json"

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found: $CONFIG_FILE"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "❌ jq is not installed"
    exit 1
fi

# Read config
WP_URL=$(jq -r '.wordpress.url' "$CONFIG_FILE")
WP_USER=$(jq -r '.wordpress.username' "$CONFIG_FILE")
WP_PASS=$(jq -r '.wordpress.app_password' "$CONFIG_FILE")

# Get arguments
TITLE="${1:-Untitled Post}"
CONTENT="${2:-}"
DATE="${3:-}"

# Validate inputs
if [ -z "$CONTENT" ]; then
    echo "❌ Content is required"
    echo "Usage: $0 \"Title\" \"Content\" \"YYYY-MM-DD HH:MM:SS\""
    exit 1
fi

if [ -z "$DATE" ]; then
    echo "❌ Date is required"
    echo "Usage: $0 \"Title\" \"Content\" \"YYYY-MM-DD HH:MM:SS\""
    exit 1
fi

# Convert to WordPress format (ISO 8601)
WP_DATE=$(date -d "$DATE" +"%Y-%m-%dT%H:%M:%S" 2>/dev/null || echo "")

if [ -z "$WP_DATE" ]; then
    echo "❌ Invalid date format: $DATE"
    echo "Use format: YYYY-MM-DD HH:MM:SS"
    exit 1
fi

# Create scheduled post data
JSON_DATA=$(jq -n \
  --arg title "$TITLE" \
  --arg content "$CONTENT" \
  --arg date "$WP_DATE" \
  '{title: $title, content: $content, status: "future", date: $date}')

# Schedule post
echo "📅 Scheduling post..."
echo "   Title: $TITLE"
echo "   Publish at: $DATE"
echo ""

RESPONSE=$(curl -s -X POST \
  "${WP_URL}/wp-json/wp/v2/posts" \
  -u "${WP_USER}:${WP_PASS}" \
  -H "Content-Type: application/json" \
  -d "$JSON_DATA")

# Check result
if echo "$RESPONSE" | jq -e '.id' >/dev/null 2>&1; then
  POST_ID=$(echo "$RESPONSE" | jq -r '.id')
  POST_LINK=$(echo "$RESPONSE" | jq -r '.link')
  POST_DATE=$(echo "$RESPONSE" | jq -r '.date')
  
  echo "✅ Post scheduled successfully!"
  echo "   ID: $POST_ID"
  echo "   Scheduled for: $POST_DATE"
  echo "   Link: $POST_LINK"
  echo ""
else
  echo "❌ Failed to schedule:"
  echo "$RESPONSE" | jq '.'
  exit 1
fi
