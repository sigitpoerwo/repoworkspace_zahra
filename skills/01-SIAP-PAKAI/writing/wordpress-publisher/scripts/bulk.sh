#!/bin/bash

# Bulk Publish WordPress Posts
# Usage: ./bulk.sh posts.json

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

# Get JSON file
JSON_FILE="$1"

if [ -z "$JSON_FILE" ]; then
    echo "❌ JSON file is required"
    echo "Usage: $0 posts.json"
    echo ""
    echo "JSON format:"
    echo '[{"title": "Post 1", "content": "Content 1"}, ...]'
    exit 1
fi

if [ ! -f "$JSON_FILE" ]; then
    echo "❌ File not found: $JSON_FILE"
    exit 1
fi

# Read config
RATE_LIMIT=$(jq -r '.security.rate_limit // 10' "$CONFIG_FILE")
RATE_WINDOW=$(jq -r '.security.rate_limit_window // 60' "$CONFIG_FILE")

# Calculate delay between requests
DELAY=$(echo "scale=2; $RATE_WINDOW / $RATE_LIMIT" | bc)

echo "📦 Bulk publishing posts from $JSON_FILE"
echo "   Rate limit: $RATE_LIMIT posts per $RATE_WINDOW seconds"
echo "   Delay: ${DELAY}s between posts"
echo ""

# Count total posts
TOTAL=$(jq '. | length' "$JSON_FILE")
echo "Total posts to publish: $TOTAL"
echo ""

# Process each post
COUNT=0
SUCCESS=0
FAILED=0

jq -c '.[]' "$JSON_FILE" | while read -r post; do
    COUNT=$((COUNT + 1))
    TITLE=$(echo "$post" | jq -r '.title')
    CONTENT=$(echo "$post" | jq -r '.content')
    STATUS=$(echo "$post" | jq -r '.status // "draft"')
    
    echo "[$COUNT/$TOTAL] Publishing: $TITLE"
    
    # Call publish.sh
    if bash "$SCRIPT_DIR/publish.sh" "$TITLE" "$CONTENT" "$STATUS" > /dev/null 2>&1; then
        SUCCESS=$((SUCCESS + 1))
        echo "   ✅ Success"
    else
        FAILED=$((FAILED + 1))
        echo "   ❌ Failed"
    fi
    
    # Rate limiting delay
    if [ $COUNT -lt $TOTAL ]; then
        echo "   ⏳ Waiting ${DELAY}s..."
        sleep "$DELAY"
    fi
    
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Bulk publish complete!"
echo "   Total: $TOTAL"
echo "   Success: $SUCCESS"
echo "   Failed: $FAILED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
