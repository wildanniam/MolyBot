#!/bin/bash
# Force restart Moltbot container with new config

echo "🔄 Restarting Moltbot Container"
echo "================================"
echo ""

echo "📝 This will:"
echo "  1. Kill existing Moltbot gateway process"
echo "  2. Container will auto-restart with new config"
echo "  3. Wait 2 minutes for cold start"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled"
    exit 1
fi

echo "🌐 Opening admin UI for process restart..."
echo ""
echo "Manual Steps:"
echo "1. Go to: https://moltbot-sandbox.wildanniam4.workers.dev/_admin/"
echo "2. Login via Cloudflare Access"
echo "3. Click 'Restart Gateway' button"
echo "4. Wait 1-2 minutes for restart"
echo "5. Refresh Control UI page"
echo ""
echo "✅ After restart, approve your device in Devices tab!"
