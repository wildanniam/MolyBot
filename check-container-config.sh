#!/bin/bash
# Check container configuration

echo "🔍 Checking Moltbot Container Configuration"
echo "=========================================="
echo ""

# Install wrangler if needed
if ! command -v wrangler &> /dev/null; then
    echo "❌ wrangler not found!"
    exit 1
fi

echo "📋 Step 1: Get process list"
echo "Running: npx wrangler tail (watch for 10 seconds)"
echo ""

# This will just show we're ready to check
echo "✅ Ready to check!"
echo ""
echo "📝 Manual Steps:"
echo "1. Keep wrangler tail running in terminal 1"
echo "2. Open browser console (F12)"
echo "3. Send a chat message"
echo "4. Look for WebSocket errors in browser console"
echo "5. Look for [WS] logs in wrangler tail"
echo ""
echo "🔍 Things to check in browser console:"
echo "   - WebSocket connection status"
echo "   - Any error messages"
echo "   - Network tab - filter by 'WS'"
echo ""
echo "🔍 Things to check in wrangler tail:"
echo "   - [WS] Proxying WebSocket connection"
echo "   - Any error messages about API calls"
echo "   - Model configuration logs"
