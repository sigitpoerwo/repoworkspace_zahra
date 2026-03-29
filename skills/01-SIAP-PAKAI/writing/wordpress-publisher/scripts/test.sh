#!/bin/bash

# Test WordPress Connection
# Usage: ./test.sh

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

echo "🔍 Testing WordPress connection..."
echo "   URL: $WP_URL"
echo "   User: $WP_USER"
echo ""

# Test REST API endpoint
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
  "${WP_URL}/wp-json/wp/v2/posts" \
  -u "${WP_USER}:${WP_PASS}")

if [ "$RESPONSE" = "200" ]; then
    echo "✅ Connection successful!"
    echo "   HTTP Status: $RESPONSE"
    echo ""
    echo "WordPress REST API is working correctly."
    echo "You can now publish posts using publish.sh"
else
    echo "❌ Connection failed"
    echo "   HTTP Status: $RESPONSE"
    echo ""
    echo "Troubleshooting:"
    echo "  - Check WordPress URL is correct"
    echo "  - Verify application password is valid"
    echo "  - Ensure REST API is enabled"
    echo "  - Check user has proper permissions"
    exit 1
fi
