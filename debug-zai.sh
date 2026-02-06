#!/bin/bash
# Debug script untuk test z.ai API connection

echo "🔍 Debugging z.ai GLM Connection"
echo "================================"
echo ""

# Get API key from wrangler secret (you'll need to enter it manually)
echo "📝 Paste your z.ai API key:"
read -s ZAI_API_KEY
echo ""

# Test endpoints
GENERAL_ENDPOINT="https://api.z.ai/api/paas/v4"
CODING_ENDPOINT="https://api.z.ai/api/coding/paas/v4"

echo "🧪 Test 1: Check models endpoint (General)"
echo "Endpoint: $GENERAL_ENDPOINT/models"
curl -s -H "Authorization: Bearer $ZAI_API_KEY" \
  "$GENERAL_ENDPOINT/models" | jq '.' 2>/dev/null || echo "❌ Failed or no jq"
echo ""

echo "🧪 Test 2: Check models endpoint (Coding)"
echo "Endpoint: $CODING_ENDPOINT/models"
curl -s -H "Authorization: Bearer $ZAI_API_KEY" \
  "$CODING_ENDPOINT/models" | jq '.' 2>/dev/null || echo "❌ Failed or no jq"
echo ""

echo "🧪 Test 3: Send test completion request (General)"
echo "Endpoint: $GENERAL_ENDPOINT/chat/completions"
curl -s -X POST "$GENERAL_ENDPOINT/chat/completions" \
  -H "Authorization: Bearer $ZAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "glm-4.7-flash",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 50
  }' | jq '.' 2>/dev/null || echo "❌ Failed"
echo ""

echo "🧪 Test 4: Send test completion request (Coding)"
echo "Endpoint: $CODING_ENDPOINT/chat/completions"
curl -s -X POST "$CODING_ENDPOINT/chat/completions" \
  -H "Authorization: Bearer $ZAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "glm-4.7-flash",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 50
  }' | jq '.' 2>/dev/null || echo "❌ Failed"
echo ""

echo "🧪 Test 5: Try alternative model names"
for model in "glm-4-flash" "glm4-flash" "glm-4.7" "glm-4" "glm-flash"; do
  echo "Testing model: $model"
  response=$(curl -s -X POST "$GENERAL_ENDPOINT/chat/completions" \
    -H "Authorization: Bearer $ZAI_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
      \"model\": \"$model\",
      \"messages\": [{\"role\": \"user\", \"content\": \"Hi\"}],
      \"max_tokens\": 10
    }")
  
  if echo "$response" | grep -q "error"; then
    echo "  ❌ Failed: $(echo $response | jq -r '.error.message' 2>/dev/null || echo 'Unknown error')"
  elif echo "$response" | grep -q "choices"; then
    echo "  ✅ SUCCESS! Model '$model' works!"
    echo "  Response: $(echo $response | jq -r '.choices[0].message.content' 2>/dev/null)"
  else
    echo "  ⚠️  Unexpected response"
  fi
  echo ""
done

echo "✅ Debug completed!"
