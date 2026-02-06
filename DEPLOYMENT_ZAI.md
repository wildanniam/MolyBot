# Deployment Guide: Moltworker dengan z.ai GLM

Guide lengkap untuk deploy Moltworker ke Cloudflare Workers menggunakan model GLM dari z.ai (95% lebih murah dari Claude!).

## 🎯 Kenapa z.ai GLM?

| Provider | Model | Input | Output | Context | Use Case |
|----------|-------|-------|--------|---------|----------|
| **Anthropic** | Claude Opus 4 | $15/M | $75/M | 200K | Premium AI |
| **z.ai** | GLM-4.7-Flash | $0.07/M | $0.40/M | 200K | **Agentic AI (BEST!)** |
| **z.ai** | GLM-4.7 | $0.40/M | $1.50/M | 200K | Complex reasoning |
| **z.ai** | GLM-4.5-Air | $0.05/M | $0.22/M | 131K | Budget-friendly |

**Penghematan: ~95%!** 💰

## 📋 Prerequisites

1. [Cloudflare Workers Paid Plan](https://dash.cloudflare.com) ($5/bulan)
2. [z.ai Account](https://z.ai/) + API Key
3. Node.js 18+ dan npm
4. Git

## 🚀 Step-by-Step Deployment

### 1. Clone & Setup Repository

```bash
git clone https://github.com/cloudflare/moltworker.git
cd moltworker
npm install
```

### 2. Dapatkan z.ai API Key

1. Kunjungi [z.ai](https://z.ai/)
2. Sign up / Login
3. Buka [API Keys page](https://z.ai/console/api-keys)
4. Klik "Create new API key"
5. Copy API key Anda (format: `zai_...`)

### 3. Set Secrets untuk z.ai GLM

```bash
# Set z.ai API key sebagai OPENAI_API_KEY
npx wrangler secret put OPENAI_API_KEY
# Paste: zai_your_api_key_here

# Set z.ai base URL
npx wrangler secret put AI_GATEWAY_BASE_URL
# Paste: https://api.z.ai/api/paas/v4
# Atau untuk coding plan: https://api.z.ai/api/coding/paas/v4

# Generate dan set gateway token (WAJIB!)
export MOLTBOT_GATEWAY_TOKEN=$(openssl rand -hex 32)
echo "🔑 Gateway Token Anda: $MOLTBOT_GATEWAY_TOKEN"
echo "⚠️  SIMPAN TOKEN INI - Anda akan butuh untuk akses Control UI!"
echo "$MOLTBOT_GATEWAY_TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN
```

### 4. Setup Cloudflare Access (untuk Admin UI)

#### 4a. Enable Cloudflare Access

1. Buka [Workers & Pages Dashboard](https://dash.cloudflare.com)
2. Pilih Worker Anda (atau akan dibuat saat deploy)
3. Di **Settings** → **Domains & Routes**, di row `workers.dev`, klik menu `...`
4. Klik **Enable Cloudflare Access**
5. Klik **Manage Cloudflare Access** untuk konfigurasi:
   - Tambahkan email Anda ke allowlist
   - Atau configure identity provider (Google, GitHub, dll)
6. Copy **Application Audience (AUD)** tag

#### 4b. Set Access Secrets

```bash
# Team domain (contoh: "myteam.cloudflareaccess.com")
npx wrangler secret put CF_ACCESS_TEAM_DOMAIN
# Paste: myteam.cloudflareaccess.com (TANPA https://)

# Application Audience dari step sebelumnya
npx wrangler secret put CF_ACCESS_AUD
# Paste: your-application-audience-tag
```

### 5. (Opsional) Setup R2 untuk Persistent Storage

Tanpa R2, data akan hilang saat container restart. Untuk persistent storage:

#### 5a. Buat R2 API Token

1. Buka [R2 Dashboard](https://dash.cloudflare.com/?to=/:account/r2/overview)
2. Klik **Manage R2 API Tokens**
3. Buat token baru dengan **Object Read & Write** permission
4. Pilih bucket `moltbot-data` (akan dibuat otomatis)
5. Copy **Access Key ID** dan **Secret Access Key**

#### 5b. Set R2 Secrets

```bash
# R2 Access Key ID
npx wrangler secret put R2_ACCESS_KEY_ID
# Paste: access_key_id_dari_step_sebelumnya

# R2 Secret Access Key
npx wrangler secret put R2_SECRET_ACCESS_KEY
# Paste: secret_access_key_dari_step_sebelumnya

# Cloudflare Account ID
npx wrangler secret put CF_ACCOUNT_ID
# Paste: account_id_anda (bisa dilihat di dashboard CF)
```

### 6. Deploy! 🚀

```bash
npm run deploy
```

**Note:** Deploy pertama butuh 3-5 menit untuk build container + upload image.

### 7. Akses Control UI

Setelah deploy selesai:

```bash
# URL format:
https://moltbot-sandbox.YOUR_SUBDOMAIN.workers.dev/?token=YOUR_GATEWAY_TOKEN
```

Ganti:
- `YOUR_SUBDOMAIN` dengan subdomain Cloudflare Anda
- `YOUR_GATEWAY_TOKEN` dengan token yang Anda generate di step 3

**⚠️ PENTING:** Request pertama butuh 1-2 menit untuk cold start container!

### 8. Device Pairing

1. Buka Control UI dengan token (step 7)
2. Buka `/_admin/` untuk admin UI
3. Login via Cloudflare Access
4. Klik tab **"Devices"**
5. Anda akan lihat pending device (browser Anda)
6. Klik **"Approve"** untuk pair device
7. Refresh Control UI - sekarang sudah bisa chat! 🎉

## 🎨 Model GLM yang Tersedia

Setelah deploy, Anda bisa switch model di Control UI. Model yang tersedia:

### Flagship Models (Best untuk Agentic AI)

- **GLM-4.7-Flash** (default) - $0.07/$0.40 per M tokens
  - Optimized untuk agentic coding, tool collaboration, long-horizon planning
  - Context: 200K tokens
  - **RECOMMENDED untuk Moltbot!**

- **GLM-4.7** - $0.40/$1.50 per M tokens
  - Best reasoning, complex coding, premium performance
  - Context: 200K tokens

### Previous Generation

- **GLM-4.6** - $0.35/$1.50 per M tokens
  - Proven reliability
  - Context: 202K tokens

- **GLM-4.6V** - $0.30/$0.90 per M tokens
  - Vision capabilities (image understanding)
  - Context: 131K tokens

### Budget Options

- **GLM-4.5** - Context: 131K tokens
- **GLM-4.5-Air** - $0.05/$0.22 per M tokens
  - Ultra budget-friendly untuk tasks ringan
  - Context: 131K tokens

## 🔧 Advanced Configuration

### Container Lifecycle

Default: Container never sleeps (recommended untuk production).

Untuk hemat biaya pada deployment jarang dipakai:

```bash
npx wrangler secret put SANDBOX_SLEEP_AFTER
# Enter: 10m (atau 1h, 30m, dll)
```

### Chat Channels (Opsional)

#### Telegram

```bash
npx wrangler secret put TELEGRAM_BOT_TOKEN
# Enter: bot_token_dari_BotFather
npm run deploy
```

#### Discord

```bash
npx wrangler secret put DISCORD_BOT_TOKEN
# Enter: bot_token_dari_Discord_Developer_Portal
npm run deploy
```

### Ganti ke Coding Plan Endpoint

Kalau mau fokus ke coding tasks, ganti base URL:

```bash
npx wrangler secret put AI_GATEWAY_BASE_URL
# Enter: https://api.z.ai/api/coding/paas/v4
npm run deploy
```

## 🐛 Troubleshooting

### Container tidak start

```bash
# Cek logs
npx wrangler tail

# Cek secrets
npx wrangler secret list

# Pastikan ada:
# - OPENAI_API_KEY
# - AI_GATEWAY_BASE_URL
# - MOLTBOT_GATEWAY_TOKEN
```

### Device pairing tidak muncul

Device list butuh 10-15 detik untuk load. Tunggu dan refresh halaman.

### Error "Unauthorized"

Pastikan:
1. `CF_ACCESS_TEAM_DOMAIN` dan `CF_ACCESS_AUD` sudah di-set
2. Cloudflare Access sudah enabled untuk worker
3. Email Anda ada di allowlist Cloudflare Access

### Cold start lambat

Request pertama setelah idle memang butuh 1-2 menit. Set `SANDBOX_SLEEP_AFTER=never` untuk keep container alive.

### R2 tidak mounting

R2 hanya work di production, tidak work dengan `wrangler dev` lokal.

Pastikan ketiga secrets ini sudah di-set:
- `R2_ACCESS_KEY_ID`
- `R2_SECRET_ACCESS_KEY`
- `CF_ACCOUNT_ID`

## 📊 Monitoring Biaya

### Estimasi Biaya per Bulan

**Workers Paid Plan:** $5/bulan (fixed)

**z.ai GLM-4.7-Flash usage:**
- 1 juta token input: $0.07
- 1 juta token output: $0.40
- Total untuk 10M tokens: **~$5**

**Total minimal:** ~$10/bulan (Workers + usage ringan)

Bandingkan dengan Claude:
- Claude Opus 4 untuk 10M tokens: **~$1,500/bulan** 💸

**Penghematan:** $1,490/bulan! 🎉

### R2 Storage (Opsional)

- Storage: $0.015/GB-bulan
- Typical moltbot data: < 100MB
- **Biaya: ~$0/bulan** (dalam free tier)

## 🔐 Security Best Practices

1. **JANGAN commit secrets** ke git
2. **SIMPAN gateway token** di password manager
3. **Enable Cloudflare Access** untuk admin routes
4. **Gunakan device pairing** (default, recommended)
5. **Set WORKER_URL** kalau mau pake CDP browser automation

## 🆘 Butuh Bantuan?

- [OpenClaw Documentation](https://docs.openclaw.ai/)
- [z.ai Documentation](https://docs.z.ai/)
- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [GitHub Issues](https://github.com/cloudflare/moltworker/issues)

## 📝 Next Steps

Setelah deploy berhasil:

1. ✅ Test chat di Control UI
2. ✅ Configure chat channels (Telegram/Discord/Slack)
3. ✅ Setup R2 backup untuk persistence
4. ✅ Explore GLM models - coba switch di UI
5. ✅ Monitor usage di [z.ai Console](https://z.ai/console)

**Selamat! Anda sekarang punya personal AI assistant dengan biaya 95% lebih murah!** 🎉
