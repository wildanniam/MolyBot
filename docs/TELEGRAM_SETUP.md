# Setup Moltworker ke Telegram

Panduan ini mengikuti [dokumentasi resmi OpenClaw Telegram](https://docs.molt.bot/channels/telegram). Dengan ini, bot Moltbot kamu bisa dipakai lewat Telegram (DM dan grup).

---

## 1. Buat Bot Token di Telegram (BotFather)

1. Buka Telegram, cari **@BotFather** (pastikan handle-nya benar `@BotFather`).
2. Kirim: `/newbot`
3. Ikuti prompt:
   - **Name**: nama tampilan bot (mis. "My Moltbot").
   - **Username**: harus berakhiran `bot` (mis. `my_moltbot_bot`).
4. BotFather akan mengirim **token** (format: `123456789:ABCdefGHI...`). **Simpan token ini** — jangan dibagikan.

**Opsional di BotFather:**
- `/setprivacy` → **Disable** kalau kamu mau bot bisa baca semua pesan di grup (tanpa harus di-mention).
- `/setjoingroups` → pilih **Allow** kalau mau bot bisa diundang ke grup.

---

## 2. Set Secret di Cloudflare

Di laptop, dari folder project:

```bash
cd /Users/wildanniam/development/autonomous-agent/moltworker

# Set token Telegram (paste token dari BotFather saat diminta)
npx wrangler secret put TELEGRAM_BOT_TOKEN
```

**Opsional** — kebijakan DM (siapa yang boleh chat tanpa pairing):

```bash
# Default: "pairing" — user harus approve pairing dulu di dashboard
# Kalau mau siapa saja boleh DM tanpa pairing (kurang aman):
npx wrangler secret put TELEGRAM_DM_POLICY
# Lalu ketik: open
```

---

## 3. Deploy Ulang Worker

Setelah secret di-set, deploy agar container dapat env terbaru:

```bash
npm run deploy
```

---

## 4. Pairing (Akses DM Pertama Kali)

Secara default, **DM ke bot memakai pairing**: user baru harus di-approve dulu.

1. Di Telegram, buka bot kamu (cari lewat username yang tadi dibuat).
2. Kirim pesan apa saja ke bot (mis. "halo" atau `/start`).
3. Bot akan membalas dengan **kode pairing** (8 karakter, mis. `3898T8EK`) dan instruksi.
4. Buka **dashboard admin** Moltworker:
   - URL: `https://moltbot-sandbox.wildanniam4.workers.dev/_admin/`
   - Login lewat Cloudflare Access jika diminta.
5. Di dashboard, scroll ke bagian **"Channel pairing (Telegram / WhatsApp)"**.
6. Pilih channel **Telegram**, paste **kode pairing** dari pesan bot, lalu klik **Approve**.
7. Kembali ke Telegram; kirim lagi. Bot sekarang akan merespons dengan AI.

---

## 5. Grup (Opsional)

- **Tanpa ubah apa-apa**: undang bot ke grup; bot hanya menjawab kalau di-**mention** (`@nama_bot`).
- **Supaya bot baca semua pesan di grup** (tanpa mention):
  1. Di BotFather: `/setprivacy` → **Disable**.
  2. Keluarkan bot dari grup, lalu undang lagi.
  3. Di config Moltbot bisa set `channels.telegram.groups["*"].requireMention: false` (kalau pakai config custom).

Untuk Moltworker, konfigurasi channel Telegram diisi dari env (`TELEGRAM_BOT_TOKEN`, `TELEGRAM_DM_POLICY`) lewat `start-moltbot.sh`; tidak perlu edit file config manual untuk setup dasar.

---

## Ringkasan

| Langkah | Yang dilakukan |
|--------|-----------------|
| 1 | Buat bot di @BotFather, dapat token |
| 2 | `npx wrangler secret put TELEGRAM_BOT_TOKEN` (paste token) |
| 3 | `npm run deploy` |
| 4 | DM bot → dapat kode pairing → Approve di `/_admin/` → chat lagi |

---

## Troubleshooting

- **"Approval may have failed" / approve kode tidak berhasil**  
  Kode pairing **berlaku ~1 jam**. Kalau sudah lama, kirim lagi pesan ke bot di Telegram → bot akan kirim **kode baru** → paste kode baru di form "Channel pairing" dan Approve. Setelah deploy terbaru, pesan error asli dari CLI (mis. "code expired") akan tampil di bawah tombol Approve.

- **Bot tidak jawab di DM**  
  Pastikan pairing sudah di-approve (form "Channel pairing (Telegram / WhatsApp)" di `/_admin/`). Channel "Configured: Yes" dan "Running: Yes" di dashboard gateway hanya berarti bot terhubung ke Telegram; **tanpa approve pairing**, pesan DM tidak diproses.

- **"Unsupported schema node. Use Raw mode" di Channels**  
  Itu masalah tampilan UI dashboard gateway saja, bukan penyebab bot diam. Abaikan; yang penting pairing sudah di-approve.

- **"Channel config schema unavailable" di dashboard**  
  Itu masalah tampilan UI channel di dashboard; **koneksi Telegram tetap jalan** selama `TELEGRAM_BOT_TOKEN` sudah di-set dan deploy ulang sudah dilakukan.

- **Bot tidak jawab di grup**  
  Pastikan kamu **mention** bot (`@username_bot`), atau nonaktifkan Privacy Mode di BotFather dan set `requireMention: false` di config grup.

- **Log error ke `api.telegram.org`**  
  Container Cloudflare Sandbox harus bisa akses internet; kalau ada proxy/firewall, pastikan outbound HTTPS ke `api.telegram.org` diizinkan.

---

## Referensi

- [OpenClaw – Telegram channel](https://docs.molt.bot/channels/telegram)
- [OpenClaw – Channel troubleshooting](https://docs.molt.bot/channels/troubleshooting)
