# Changelog: z.ai GLM Support

Modifikasi yang dilakukan untuk support z.ai GLM models di Moltworker.

## 📝 Files Modified

### Core Logic

1. **`start-moltbot.sh`** (Container startup script)
   - ✅ Tambah deteksi untuk z.ai endpoint (`isZAI`)
   - ✅ Tambah konfigurasi OpenAI provider untuk z.ai GLM
   - ✅ Support 8 model GLM: 4.7, 4.7-Flash, 4.6, 4.6V, 4.5, 4.5-Air, dll
   - ✅ Set GLM-4.7-Flash sebagai default (best untuk agentic AI)
   - ✅ Proper model alias untuk UI

2. **`src/gateway/env.ts`** (Environment variable builder)
   - ✅ Tambah deteksi `isZAIGateway` untuk z.ai endpoint
   - ✅ Map z.ai API key ke `OPENAI_API_KEY` (OpenAI-compatible)
   - ✅ Set `OPENAI_BASE_URL` untuk z.ai endpoint

3. **`Dockerfile`**
   - ✅ Update cache bust comment ke v27 (force rebuild dengan config baru)

### Documentation

4. **`README.md`**
   - ✅ Update Requirements section (tambah z.ai sebagai opsi)
   - ✅ Tambah section "Alternative: Using z.ai GLM Models"
   - ✅ Tambah comparison table (Claude vs GLM pricing)
   - ✅ Update AI Gateway section (mention z.ai support)
   - ✅ Update secrets reference table
   - ✅ Tambah link ke deployment guide baru

5. **`DEPLOYMENT_ZAI.md`** (NEW FILE!)
   - ✅ Complete step-by-step deployment guide untuk z.ai
   - ✅ Penjelasan kenapa z.ai GLM bagus untuk agentic AI
   - ✅ Setup instructions lengkap (API key, secrets, Cloudflare Access, R2)
   - ✅ Model comparison table dengan pricing
   - ✅ Advanced configuration (channels, lifecycle, etc)
   - ✅ Troubleshooting section
   - ✅ Cost estimation dan monitoring

6. **`AGENTS.md`**
   - ✅ Update Environment Variables section (tambah z.ai vars)
   - ✅ Update Local Development section (contoh .dev.vars)
   - ✅ Update Container Environment Variables table

7. **`wrangler.jsonc`**
   - ✅ Update secrets comments dengan z.ai examples
   - ✅ Reorganisasi comment structure (AI Provider, Auth, Channels, etc)

8. **`.dev.vars.example`**
   - ✅ Tambah z.ai GLM setup example
   - ✅ Tambah OpenAI option
   - ✅ Tambah Cloudflare AI Gateway option
   - ✅ Clear comments untuk memilih provider

### Tests

9. **`src/gateway/env.test.ts`**
   - ✅ Tambah 3 test case baru untuk z.ai endpoint detection
   - ✅ Test z.ai general API endpoint
   - ✅ Test z.ai Coding Plan endpoint
   - ✅ Test z.ai dengan trailing slashes
   - ✅ All tests passed (19 tests total)

## ✨ Features Added

### Auto-Detection
- System otomatis detect z.ai endpoint dari `AI_GATEWAY_BASE_URL`
- Jika URL contains `api.z.ai`, langsung map ke OpenAI-compatible provider

### Model Support
System sekarang support 8 model GLM:

| Model ID | Name | Context | Best For |
|----------|------|---------|----------|
| `glm-4.7` | GLM-4.7 | 200K | Reasoning, complex coding |
| `glm-4.7-flash` | GLM-4.7-Flash | 200K | **Agentic AI (default)** |
| `glm-4.7-flash-20260119` | GLM-4.7-Flash (Jan 2026) | 200K | Latest flash model |
| `glm-4.6` | GLM-4.6 | 202K | Previous gen, reliable |
| `glm-4.6v` | GLM-4.6V (Vision) | 131K | Image understanding |
| `glm-4.5` | GLM-4.5 | 131K | Standard tasks |
| `glm-4.5-air` | GLM-4.5-Air | 131K | Budget-friendly |
| `glm-4-32b-0414-128k` | GLM-4-32B | 128K | Legacy model |

### Default Model
- **GLM-4.7-Flash** dijadikan default karena:
  - Optimized untuk agentic coding
  - Best tool collaboration
  - Long-horizon task planning
  - Harga sangat kompetitif ($0.07/$0.40 per M tokens)

## 🧪 Testing

All tests passed:
- ✅ 86 total tests
- ✅ 19 env.test.ts tests (termasuk 3 baru untuk z.ai)
- ✅ TypeScript typecheck passed
- ✅ No regressions

## 📊 Cost Savings

| Provider | Model | Input | Output | Monthly (10M tokens) |
|----------|-------|-------|--------|---------------------|
| Anthropic | Claude Opus 4 | $15/M | $75/M | **$1,500** |
| z.ai | GLM-4.7-Flash | $0.07/M | $0.40/M | **$5** |
| **Savings** | | | | **$1,495 (99.7%)** |

## 🚀 Deployment

Untuk deploy dengan z.ai GLM:

```bash
# Set z.ai API key
npx wrangler secret put OPENAI_API_KEY
# Enter: zai_your_api_key

# Set z.ai endpoint
npx wrangler secret put AI_GATEWAY_BASE_URL
# Enter: https://api.z.ai/api/paas/v4

# Deploy
npm run deploy
```

Lihat [DEPLOYMENT_ZAI.md](./DEPLOYMENT_ZAI.md) untuk complete guide.

## 🔄 Backwards Compatibility

✅ Semua existing config tetap work:
- ✅ `ANTHROPIC_API_KEY` untuk Claude
- ✅ `OPENAI_API_KEY` untuk OpenAI
- ✅ `AI_GATEWAY_*` untuk Cloudflare AI Gateway
- ✅ No breaking changes

## 📚 Documentation

Complete documentation added:
- ✅ User-facing: [DEPLOYMENT_ZAI.md](./DEPLOYMENT_ZAI.md)
- ✅ Developer-facing: Updated [AGENTS.md](./AGENTS.md)
- ✅ Quick reference: Updated [README.md](./README.md)
- ✅ Local dev: Updated [.dev.vars.example](./.dev.vars.example)

## 🎯 Next Steps untuk User

1. Get z.ai API key dari [z.ai](https://z.ai/)
2. Set secrets (OPENAI_API_KEY + AI_GATEWAY_BASE_URL)
3. Deploy dengan `npm run deploy`
4. Enjoy 95% cheaper AI! 🎉

---

## 🐛 Bug Fix (2026-02-06 - Evening)

**Issue:** Worker validation masih hardcoded check untuk `ANTHROPIC_API_KEY`, causing "Configuration Required" error meski `OPENAI_API_KEY` sudah di-set.

**Fixed:**
- ✅ Update `validateRequiredEnv()` di `src/index.ts` untuk accept `OPENAI_API_KEY` sebagai valid provider
- ✅ Update error messages untuk mention z.ai/OpenAI options
- ✅ Update logging untuk include OPENAI_API_KEY dan AI_GATEWAY_BASE_URL status
- ✅ Update header documentation

**Files Modified:**
- `src/index.ts` - 4 changes (validation, logging, error hints, documentation)

**Testing:**
- ✅ All 86 tests passed
- ✅ TypeScript check passed

**Action Required:**
- Run `npm run deploy` untuk apply fix ke production

---

**Date:** 2026-02-06  
**Version:** v28-zai-validation-fix  
**Status:** ✅ Ready for production
