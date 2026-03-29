#!/bin/bash

# WordPress Publisher Script
# Usage: ./publish.sh "Title" "Content" [status]

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config.json"

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found: $CONFIG_FILE"
    echo "Please create config.json with your WordPress credentials"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "❌ jq is not installed. Please install jq first."
    exit 1
fi

# Read config
WP_URL=$(jq -r '.wordpress.url' "$CONFIG_FILE")
WP_USER=$(jq -r '.wordpress.username' "$CONFIG_FILE")
WP_PASS=$(jq -r '.wordpress.app_password' "$CONFIG_FILE")
DEFAULT_STATUS=$(jq -r '.defaults.status' "$CONFIG_FILE")

# Get arguments
TITLE="${1:-Untitled Post}"
CONTENT="${2:-}"
STATUS="${3:-$DEFAULT_STATUS}"

# Validate inputs
if [ -z "$CONTENT" ]; then
    echo "❌ Content is required"
    echo "Usage: $0 \"Title\" \"Content\" [status]"
    exit 1
fi

# Create post data
JSON_DATA=$(jq -n \
  --arg title "$TITLE" \
  --arg content "$CONTENT" \
  --arg status "$STATUS" \
  '{title: $title, content: $content, status: $status}')

# Publish to WordPress
echo "📝 Publishing to WordPress..."
echo "   Title: $TITLE"
echo "   Status: $STATUS"
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
  POST_STATUS=$(echo "$RESPONSE" | jq -r '.status')
  
  echo "✅ Published successfully!"
  echo "   ID: $POST_ID"
  echo "   Status: $POST_STATUS"
  echo "   Link: $POST_LINK"
  echo ""
else
  echo "❌ Failed to publish:"
  echo "$RESPONSE" | jq '.'
  exit 1
fi
