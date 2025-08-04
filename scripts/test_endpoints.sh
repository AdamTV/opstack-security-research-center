#!/bin/bash

echo "🧪 Testing Security Research Dashboard Endpoints"
echo "================================================"

BASE_URL="http://localhost:5000"

# Test basic endpoints
echo "Testing basic connectivity..."
curl -s "$BASE_URL/status" > /dev/null && echo "✅ Status endpoint working" || echo "❌ Status endpoint failed"

echo ""
echo "Testing API endpoints..."
curl -s "$BASE_URL/api/blocks" > /dev/null && echo "✅ Blocks API working" || echo "❌ Blocks API failed"
curl -s "$BASE_URL/api/transactions" > /dev/null && echo "✅ Transactions API working" || echo "❌ Transactions API failed"

echo ""
echo "Testing security tools..."
curl -s "$BASE_URL/run/slither" > /dev/null && echo "✅ Slither endpoint working" || echo "❌ Slither endpoint failed"
curl -s "$BASE_URL/scan/reentrancy" > /dev/null && echo "✅ Reentrancy scanner working" || echo "❌ Reentrancy scanner failed"

echo ""
echo "Testing metrics..."
curl -s "$BASE_URL/metrics" > /dev/null && echo "✅ Metrics endpoint working" || echo "❌ Metrics endpoint failed"

echo ""
echo "🎉 Endpoint testing complete!"
echo "Visit http://localhost:5000 to use the dashboard"
