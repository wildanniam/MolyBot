#!/bin/bash
# Test semua model z.ai GLM yang tersedia
# Pakai coding plan endpoint - macOS compatible

ENDPOINT="https://api.z.ai/api/coding/paas/v4"

echo "🔍 Testing z.ai GLM Models (Coding Plan)"
echo "=========================================="
echo "Endpoint: $ENDPOINT"
echo ""

echo "📝 Paste your z.ai API key:"
read -s ZAI_API_KEY
echo ""

if [ -z "$ZAI_API_KEY" ]; then
    echo "❌ API key kosong!"
    exit 1
fi

test_model() {
    local model="$1"
    echo "📌 Testing: $model"

    body=$(curl -s -X POST "$ENDPOINT/chat/completions" \
        -H "Authorization: Bearer $ZAI_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{\"role\": \"user\", \"content\": \"Say hello in one word\"}],
            \"max_tokens\": 100
        }" 2>&1)

    # Check for content in response
    if echo "$body" | jq -e '.choices[0].message' > /dev/null 2>&1; then
        content=$(echo "$body" | jq -r '.choices[0].message.content // "(empty)"')
        reasoning=$(echo "$body" | jq -r '.choices[0].message.reasoning_content // empty')
        usage_in=$(echo "$body" | jq -r '.usage.prompt_tokens // "?"')
        usage_out=$(echo "$body" | jq -r '.usage.completion_tokens // "?"')
        model_used=$(echo "$body" | jq -r '.model // "?"')
        echo "  ✅ SUCCESS"
        echo "  Model used: $model_used"
        echo "  Content: ${content:0:120}"
        if [ -n "$reasoning" ]; then
            echo "  Has reasoning: yes (${#reasoning} chars)"
        fi
        echo "  Tokens: in=$usage_in out=$usage_out"
        return 0
    elif echo "$body" | jq -e '.error' > /dev/null 2>&1; then
        error_msg=$(echo "$body" | jq -r '.error.message // .error // "Unknown"')
        echo "  ❌ FAILED: $error_msg"
        return 1
    else
        echo "  ❌ FAILED: Unexpected response"
        echo "  Raw: ${body:0:200}"
        return 1
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Step 1: List semua model yang tersedia"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

models_response=$(curl -s -H "Authorization: Bearer $ZAI_API_KEY" "$ENDPOINT/models")
echo "$models_response" | jq -r '.data[] | "  - \(.id) (owned by: \(.owned_by))"' 2>/dev/null
model_ids=$(echo "$models_response" | jq -r '.data[].id' 2>/dev/null)
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Step 2: Test model dari /models list"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

success_models=""
fail_models=""

for model in $model_ids; do
    if test_model "$model"; then
        success_models="$success_models $model"
    else
        fail_models="$fail_models $model"
    fi
    echo ""
    sleep 1
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Step 3: Test model tambahan"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

extra_models="glm-4.7-flash glm-4.6v glm-4.5-air glm-z1-flash"

for model in $extra_models; do
    if echo "$model_ids" | grep -q "^${model}$"; then
        continue
    fi
    if test_model "$model"; then
        success_models="$success_models $model"
    else
        fail_models="$fail_models $model"
    fi
    echo ""
    sleep 1
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RINGKASAN"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Models yang WORKS:"
for m in $success_models; do
    echo "  - $m"
done
echo ""
echo "❌ Models yang GAGAL:"
for m in $fail_models; do
    echo "  - $m"
done
echo ""
echo "Done!"
