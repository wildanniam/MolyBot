# Whitepaper: Bittensor Decentralized Medical Imaging Review

**Version:** 1.0
**Date:** 11 Februari 2026
**Author:** Wildan Syukri Niam

---

## 1. INTRODUCTION

Bittensor Decentralized Medical Imaging Review adalah subnet di Bittensor yang memungkinkan crowdsourced review dokumen MRI/CT scan oleh dokter di seluruh dunia. Subnet ini dirancang untuk mempercepat review medis, mengurangi biaya, dan meningkatkan akurasi dengan sistem reward yang transparan dan validasi oleh senior doctor.

---

## 2. URGENCY: PROBLEM YANG INGIN DI-SOLVE

### 2.1. Problem Utama

**Problem 1: Pasien Butuh Review Medis Cepat**
- MRI/CT scan butuh review dalam 24-48 jam.
- Di rumah sakit, review dilakukan oleh 1-2 senior doctor.
- Lama, mahal, sulit skalabilitas.

**Problem 2: Review Medis Mahal**
- Senior doctor tarif: Rp 2.000.000 - Rp 5.000.000 per scan.
- Hospital terbatas kapasitas (hanya 1-2 senior doctor).
- Pasien harus menunggu lama.

**Problem 3: Manual Review Sulit Skalabilitas**
- Tidak bisa menangani volume scan besar.
- Kualitas review bergantung pada ketersediaan senior doctor.
- Sulit menjamin akurasi konsisten.

**Problem 4: Kurang Transparan**
- Diagnosis tersembunyi (banyak dokter tidak tahu review siapa).
- Sulit audit kualitas review.
- Tidak ada incentive yang jelas untuk dokter yang review.

---

### 2.2. Dampak Negatif

1. **Pasien**
   - Menunggu lama untuk hasil diagnosis.
   - Biaya review mahal.
   - Kualitas review bergantung pada senior doctor yang tersedia.

2. **Hospital**
   - Kapasitas terbatas.
   - Biaya tinggi untuk gaji senior doctor.
   - Sulit skalabilitas (tidak bisa menangani banyak scan sekaligus).

3. **Dokter**
   - Tidak ada incentive yang jelas untuk review.
   - Banyak dokter tidak tahu mereka bisa review dan dapat reward.
   - Kualitas review bergantung pada frekuensi senior doctor review.

---

## 3. SOLUTION: CROWD-SOURCED REVIEW MEDIS DI BITTENSOR

### 3.1. Konsep

Kami membuat platform di Bittensor yang memungkinkan:

- **Miner (Dokter)**: Review MRI/CT scan dan mendapat reward TAO.
- **Validator (Senior Doctor)**: Score kualitas review miner dan mendapat reward TAO.
- **User (Hospital)**: Mendapatkan review medis cepat, murah, dan akurat.

### 3.2. Alur Kerja

```
1. Pasien/Medical Staff Upload MRI/CT scan ke Platform.
2. Platform mengirimkan scan ke Bittensor Miners.
3. Miners review scan dan submit diagnosis.
4. Validators score kualitas review miner.
5. Miner yang akurat mendapat TAO.
6. Hospital mendapatkan diagnosa terbaik dari miner dengan score tertinggi.
```

### 3.3. Keunggulan

**A. Cepat**
- Crowd-sourced: banyak dokter review sekaligus.
- Hasil dalam 24-48 jam (bukan 1-2 minggu).

**B. Murah**
- Reward-based: dokter yang bagus dapat TAO, bukan fixed salary.
- Biaya lebih rendah dari fixed salary senior doctor.

**C. Akurat**
- Validated oleh senior doctor.
- Konsensus dari banyak dokter.

**D. Transparan**
- Diagnosis terbuka di blockchain.
- Reward jelas dan transparan.

**E. Skalabel**
- Bisa menangani volume scan besar.
- Kapasitas tidak terbatas.

---

## 4. SUBNET DESIGN

### 4.1. Miner Design

#### 4.1.1. Miner Tasks

**Input:**
- MRI/CT scan image (JPEG/PNG format).
- Diagnosis (label diagnosis atau isi manual).

**Output:**
- Diagnosis (label + confidence score).
- Metadata (timestamp, miner ID).

#### 4.1.2. Performance Dimensions

1. **Accuracy (Akurasi)**
   - Seberapa sering diagnosa benar.
   - Dihitung dari feedback validator.

2. **Consistency (Konsistensi)**
   - Seberapa sering hasil diagnosa sama dengan dokter lain.
   - Dihitung dari consensus review.

3. **Speed (Kecepatan)**
   - Seberapa cepat review (dalam menit).
   - Target: review <30 menit.

#### 4.1.3. Reward Structure

```
Base Reward = 100 TAO
Accuracy Bonus = (+10-50 TAO) kalau diagnosa akurat
Consistency Bonus = (+5-20 TAO) kalau hasil konsisten
Speed Bonus = (+5-10 TAO) kalau cepat (<30 menit)
Total Reward = 100-180 TAO per review
```

**Penalty:**
- Spam diagnosis = -50 TAO
- Tidak valid (no diagnosis) = -10 TAO

#### 4.1.4. Miner Requirements

1. **Kualifikasi:**
   - Dokter radiologist/kader medis.
   - Med student (dengan senior doctor supervisor).
   - Verified medical license.

2. **Tools:**
   - Next.js application (upload review).
   - Bittensor integration (miner API).
   - R2 bucket storage (commit-reveal).

3. **Incentive:**
   - TAO (token Bittensor).
   - Subnet token.
   - Reputation (kalau diagnosa akurat).

---

### 4.2. Validator Design

#### 4.2.1. Validator Tasks

**Input:**
- Miner diagnosis + MRI scan.
- Miner metadata.

**Output:**
- Score accuracy (0-100).
- Score consistency (0-100).
- Feedback (1 sentence).

#### 4.2.2. Scoring Methodology

1. **Accuracy Score (0-100)**
   - Dihitung dari seberapa sering diagnosa miner sama dengan consensus validator.
   - Contoh: 70% consensus = 70 score.

2. **Consistency Score (0-100)**
   - Dihitung dari seberapa sering validator memberi skor konsisten dengan validator lain.
   - Contoh: 80% validator memberi skor 80-90 = 80-90 score.

3. **Feedback Loop**
   - Validator memberi feedback ke miner.
   - Miner dengan feedback negatif terus-terusan = dipunishing.

#### 4.2.3. Reward Structure

```
Review Reward = 5-10 TAO per scan
Accuracy Bonus = (+10-30 TAO) kalau score tinggi
Consistency Bonus = (+5-15 TAO) kalau score konsisten
Total Reward = 20-55 TAO per review
```

**Penalty:**
- Review tidak valid (no score) = -5 TAO
- Bias/kecurangan = -50 TAO

#### 4.2.4. Validator Requirements

1. **Kualifikasi:**
   - Senior radiologist (10+ tahun pengalaman).
   - Verified medical license.
   - Reputation score >70.

2. **Tools:**
   - Next.js application (score review).
   - Bittensor integration (validator API).
   - R2 bucket storage (commit-reveal).

3. **Incentive:**
   - TAO (token Bittensor).
   - Reputation (kalau score validator tinggi).
   - Enterprise subscription (kalau terpilih validator terbaik).

---

### 4.3. Incentive & Mechanism Design

#### 4.3.1. Emission and Reward Logic

**Emission:**
- TAO token Bittensor di-emitted setiap epoch (sekitar 12 jam).
- Emission di-distribute ke miners dan validators berdasarkan kualitas kontribusi.

**Reward Distribution:**
- 70% emission: Miner reward (base + bonus).
- 20% emission: Validator reward (review + bonus).
- 10% emission: Reserve fund (emergency, anti-cheat mechanism).

**Example:**
```
Epoch emission = 100,000 TAO
Miner reward = 70,000 TAO
Validator reward = 20,000 TAO
Reserve fund = 10,000 TAO
```

#### 4.3.2. Incentive Alignment

**Miner Incentive:**
- Base reward = 100 TAO per review (pasti dapat).
- Bonus = +10-50 TAO kalau diagnosa akurat.
- Penalty = -50 TAO kalau spam diagnosis.

**Validator Incentive:**
- Review reward = 5-10 TAO per scan (pasti dapat).
- Bonus = +10-30 TAO kalau score validator tinggi.
- Penalty = -50 TAO kalau bias/kecurangan.

**User Incentive:**
- Hospital dapat review cepat, murah, dan akurat.
- Platform fee = 5-10% dari TAO reward.

#### 4.3.3. Anti-Cheat Mechanism

**1. Commit-Reveal**
- Miner commit diagnosis (hash) dulu.
- Baru reveal diagnosis asli setelah validator review.
- Supaya validator tidak cheating (lihat diagnosis sebelum commit).

**2. Feedback Loop**
- Validator memberi feedback ke miner.
- Miner dengan feedback negatif terus-terusan = dipunishing (reward dikurang).

**3. R2 Bucket Storage**
- Data disimpan di R2, timestamped.
- Supaya tracking sejarah diagnosis.

**4. ZKP (Zero Knowledge Proof)**
- Dokter bisa buktikan diagnosis valid tanpa memberi semua data medis.
- Contoh: dokter buktikan diagnosa sama dengan majority tanpa buka semua data ke validator.

---

### 4.4. How This Design Qualifies as "Proof of Intelligence" or "Proof of Effort"

**Proof of Intelligence (POI):**
- Miner yang akurat (diagnosa benar) dapat lebih banyak TAO.
- Validator yang score tinggi (kualitas review baik) dapat lebih banyak TAO.
- Diagnosis yang valid (terbukti oleh validator) = intelligence yang di-distribute.

**Proof of Effort (POE):**
- Miner yang review cepat dan konsisten dapat bonus.
- Validator yang score konsisten dapat bonus.
- Review yang dilakukan dengan efisien = effort yang di-distribute.

**Why This Qualifies:**
- Miner yang akurat (diagnosa benar) dapat lebih banyak TAO.
- Validator yang score tinggi (kualitas review baik) dapat lebih banyak TAO.
- Diagnosis yang valid (terbukti oleh validator) = intelligence yang di-distribute.

---

### 4.5. High-Level Algorithm

```
# Miner Algorithm
1. Receive MRI scan from platform.
2. Upload diagnosis (label + confidence score) to Bittensor.
3. Commit diagnosis hash (hash diagnosis).
4. Reveal diagnosis asli setelah validator review.
5. Receive reward:
   - Base reward: 100 TAO
   - Accuracy bonus: +10-50 TAO
   - Consistency bonus: +5-20 TAO
   - Speed bonus: +5-10 TAO
   - Penalty: -50 TAO (spam diagnosis), -10 TAO (tidak valid)
6. Update miner reputation score.

# Validator Algorithm
1. Receive diagnosis from miner + MRI scan.
2. Score miner (accuracy + consistency).
3. Provide feedback (1 sentence).
4. Receive reward:
   - Review reward: 5-10 TAO
   - Accuracy bonus: +10-30 TAO
   - Consistency bonus: +5-15 TAO
   - Penalty: -5 TAO (tidak valid), -50 TAO (bias/kecurangan)
5. Update validator reputation score.
```

---

## 5. BUSINESS LOGIC & MARKET RATIONALE

### 5.1. Problem the Subnet Aims to Solve

**Problem 1: Pasien Butuh Review Medis Cepat**
- Pasien butuh hasil diagnosis dalam 24-48 jam.
- Manual review lambat (1-2 senior doctor).

**Problem 2: Review Medis Mahal**
- Senior doctor tarif: Rp 2.000.000 - Rp 5.000.000 per scan.
- Hospital terbatas kapasitas (hanya 1-2 senior doctor).

**Problem 3: Manual Review Sulit Skalabilitas**
- Tidak bisa menangani volume scan besar.
- Kualitas review bergantung pada ketersediaan senior doctor.

**Problem 4: Kurang Transparan**
- Diagnosis tersembunyi (banyak dokter tidak tahu review siapa).
- Sulit audit kualitas review.

### 5.2. Why This Use Case is Well-Suited to a Bittensor Subnet

**A. Decentralized Crowdsourcing**
- Bittensor memungkinkan crowd-sourced task di seluruh dunia.
- Banyak dokter bisa review sekaligus.

**B. Incentive-Based**
- Reward-based (TAO) membuat dokter yang bagus dapat lebih banyak TAO.
- Dokter kualitas rendah dipunishing.

**C. Transparent**
- Diagnosis terbuka di blockchain.
- Reward jelas dan transparan.

**D. Scalable**
- Bisa menangani volume scan besar.
- Kapasitas tidak terbatas.

**E. Validated by Experts**
- Validator (senior doctor) score kualitas review miner.
- Akurasi dijamin.

### 5.3. Competing Solutions

**Closed-Source AI (Google Cloud, OpenAI)**
- Pros: akurat, cepat.
- Cons: mahal, kurang transparan, privat.

**Manual Review (1-2 Senior Doctor)**
- Pros: akurat, terpercaya.
- Cons: lambat, mahal, sulit skalabilitas.

**Why This Subnet?**
- Menggabungkan kelebihan kedua:
  - Crowd-sourced (cepat, murah).
  - Validated (akurat, terpercaya).
- Transparan (blockchain).
- Scalable (bisa menangani volume scan besar).

---

## 6. GO-TO-MARKET STRATEGY

### 6.1. Target Users

**Miners (Dokter)**
- Radiologist.
- Doctor assistant.
- Med student (dengan senior doctor supervisor).

**Validators (Senior Doctor)**
- Senior radiologist (10+ tahun pengalaman).
- Doctor dengan reputation score >70.

**Users (Hospital/Klinik)**
- Hospital/klinik yang butuh review medis cepat.
- Medical imaging center.

### 6.2. Use Cases

**Use Case 1: Hospital/Klinik**
- Upload MRI/CT scan.
- Dapatkan diagnosa dalam 24-48 jam.
- Biaya: 5-10% dari TAO reward.

**Use Case 2: Medical Imaging Center**
- Review banyak scan sekaligus.
- Scalable dan cost-effective.

**Use Case 3: Research Institution**
- Crowd-sourced review untuk research.
- Data terbuka dan transparan.

### 6.3. Early Adopters

**Phase 1 (March 2026): Seeding Testnet**
- **Target:**
  - 5-10 validator (senior doctor dari CITI Lab/klinik partner).
  - 50-100 miners (doctor assistant + med student).

- **Use Case:**
  - Review MRI scan dummy (public dataset).
  - Skor akurasi di-track.

- **Distribution:**
  - Partner dengan hospital/klinik.
  - Post di LinkedIn, Twitter (X) ke medical community.

**Phase 2 (April 2026): Pilot**
- **Target:**
  - 20 validator.
  - 500 miners.

- **Use Case:**
  - Review MRI scan real (signed NDA).
  - Platform testing dengan hospital.

- **Incentives:**
  - Mining awal: reward x2 (bukan fixed salary).
  - Validator: early access ke premium feature.

- **Growth Channels:**
  - LinkedIn (medical community).
  - Twitter (X) (teknologi medis).
  - Community medis (Telegram group med student).

**Phase 3 (May 2026): Full Launch**
- **Target:**
  - 100 validator.
  - 1,000+ miners.
  - 5-10 hospital partners.

- **Use Case:**
  - Review MRI/CT scan real-time.
  - API integration dengan hospital.

- **Monetization:**
  - Platform fee: 5-10% dari TAO reward.
  - Enterprise subscription: 5-10 TAO/month untuk validator.

- **Distribution:**
  - Post di LinkedIn (banyak medical community).
  - Co-marketing dengan hospital/klinik.
  - Webinar + workshop tentang blockchain di medis.

### 6.4. Distribution & Growth Channels

**LinkedIn (Medical Community)**
- Post tentang platform.
- Webinar + workshop.
- Networking dengan senior doctor.

**Twitter (X) (Teknologi Medis)**
- Post tentang platform.
- Share success story (kasus yang berhasil).

**Community Medis (Telegram Group)**
- Telegram group med student.
- Telegram group radiologist.
- Discord server medis.

**Hospital/Klinik Partners**
- Co-marketing.
- Pilot testing.
- API integration.

---

## 7. TECHNICAL ARCHITECTURE

### 7.1. Technology Stack

**Frontend (Next.js)**
- Upload review (miners).
- Score review (validators).
- Dashboard untuk users (hospital).

**Backend (Hono)**
- Bittensor integration (miner/validator API).
- R2 bucket storage (commit-reveal).
- ZKP (Zero Knowledge Proof).

**Blockchain (Bittensor)**
- Subnet integration.
- Reward distribution (TAO).
- Commit-reveal mechanism.

**Database (PostgreSQL + Redis)**
- Store diagnosis, miner/validator info.
- Cache miner reputation score.
- Track feedback loop.

**Cloud Storage (R2)**
- Store MRI/CT scan.
- Commit-reveal storage.
- Timestamped data.

**ZKP (Zero Knowledge Proof)**
- Privacy validation.
- Diagnosis validasi tanpa memberi semua data.

### 7.2. System Diagram

```
+-------------------+        +-------------------+        +-------------------+
|   Frontend (Next) |        |   Backend (Hono)  |        |  Bittensor Subnet |
|                   |        |                   |        |                   |
| - Miner Upload    |<------>| - Bittensor API   |<------>| - Miner Tasks     |
| - Validator Score |------->| - R2 Storage      |------->| - Validator Tasks |
| - Dashboard User  |------->| - Database        |------->| - Reward Logic    |
+-------------------+        +-------------------+        +-------------------+
```

### 7.3. API Endpoints

**Miner API:**
- `POST /api/miner/review` - Submit diagnosis.
- `GET /api/miner/reward` - Check miner reward.
- `GET /api/miner/reputation` - Check miner reputation.

**Validator API:**
- `POST /api/validator/score` - Score miner diagnosis.
- `GET /api/validator/reward` - Check validator reward.
- `GET /api/validator/reputation` - Check validator reputation.

**User API:**
- `POST /api/user/upload` - Upload MRI/CT scan.
- `GET /api/user/diagnosis` - Get diagnosis.
- `GET /api/user/history` - Get review history.

---

## 8. RISK & MITIGATION

### 8.1. Risks

**Risk 1: Data Privacy**
- MRI/CT scan berisi data sensitif.
- Kalau bocor, pasien privacy terganggu.

**Mitigation:**
- ZKP (Zero Knowledge Proof) untuk validasi tanpa memberi semua data.
- NDA (Non-Disclosure Agreement) untuk miners dan validators.
- R2 bucket storage yang aman (encryption).

**Risk 2: Medical Error**
- Miner salah diagnosa.
- Bisa menyebabkan kesalahan medis.

**Mitigation:**
- Validator (senior doctor) score kualitas review miner.
- Diagnosis yang salah dipunishing (reward dikurang).
- Feedback loop untuk mengoreksi miner.

**Risk 3: Cheating (Bucket Copying, Overfitting)**
- Miner copy diagnosis dari validator.
- Miner overfitting (hanya fokus ke dataset tertentu).

**Mitigation:**
- Commit-reveal mechanism.
- Feedback loop.
- Multi-validator scoring.

**Risk 4: Low Adoption**
- Hospital/klinik tidak mau pakai platform.
- Miners/validators tidak mau join.

**Mitigation:**
- Early incentives (reward x2 untuk pilot).
- Co-marketing dengan hospital/klinik.
- Education (workshop + webinar).

---

## 9. ROADMAP

### 9.1. Timeline

**Week 1-2: Testnet Setup**
- Deploy subnet di Bittensor testnet.
- Setup Next.js application (frontend).
- Setup Hono backend (Bittensor integration).
- Setup R2 bucket storage (commit-reveal).
- Setup PostgreSQL + Redis (database).

**Week 3-4: Pilot with CITI Lab**
- Partner dengan CITI Lab untuk pilot.
- Test dengan 5-10 validator (senior doctor).
- Test dengan 50-100 miners (doctor assistant + med student).
- Collect feedback dan improve.

**Week 5-6: Full Launch**
- Launch subnet di Bittensor mainnet (testnet).
- Partner dengan 5-10 hospital/klinik.
- Launch platform (frontend + backend).
- Distribute TAO reward untuk miners dan validators.
- Post di LinkedIn, Twitter (X), Telegram group.

### 9.2. Milestones

**Milestone 1: Testnet Deployment**
- Subnet ter-deploy di Bittensor testnet.
- Next.js application ready.
- Bittensor integration ready.

**Milestone 2: Pilot Testing**
- 5-10 validator aktif.
- 50-100 miners aktif.
- Pilot testing selesai.

**Milestone 3: Full Launch**
- Subnet live di Bittensor mainnet (testnet).
- 5-10 hospital partners.
- Platform launch.

**Milestone 4: 100 Validators & 1,000 Miners**
- 100 validator aktif.
- 1,000 miners aktif.
- Platform sukses.

---

## 10. CONCLUSION

Bittensor Decentralized Medical Imaging Review adalah subnet di Bittensor yang memungkinkan crowdsourced review MRI/CT scan oleh dokter di seluruh dunia. Subnet ini dirancang untuk mempercepat review medis, mengurangi biaya, dan meningkatkan akurasi dengan sistem reward yang transparan dan validasi oleh senior doctor.

### 10.1. Summary

**Problem:**
- Pasien butuh review medis cepat.
- Review medis mahal.
- Manual review sulit skalabilitas.
- Kurang transparan.

**Solution:**
- Crowd-sourced review medis di Bittensor.
- Reward-based: dokter yang bagus dapat TAO.
- Validated oleh senior doctor.

**Benefits:**
- Cepat: hasil dalam 24-48 jam.
- Murah: reward-based, bukan fixed salary.
- Akurat: validasi senior doctor.
- Transparan: diagnosis terbuka di blockchain.
- Skalabel: bisa menangani volume scan besar.

**Incentive Mechanism:**
- Miner: 100-180 TAO per review.
- Validator: 20-55 TAO per review.
- Anti-cheat: commit-reveal, feedback loop, ZKP.

**Go-to-Market:**
- Phase 1: Seeding testnet (March).
- Phase 2: Pilot (April).
- Phase 3: Full launch (May).

---

## 11. APPENDIX

### 11.1. Glossary

- **TAO**: Token Bittensor.
- **Miner**: Dokter yang review MRI/CT scan.
- **Validator**: Senior doctor yang score kualitas review miner.
- **User**: Hospital/klinik yang butuh review medis.
- **Commit-Reveal**: Mechanism di mana diagnosis di-hash dulu, baru reveal setelah validator review.
- **ZKP**: Zero Knowledge Proof, cara buktikan diagnosis valid tanpa memberi semua data medis.
- **Emission**: TAO token di-emitted setiap epoch.
- **Epoch**: Period di mana reward di-distribute (sekitar 12 jam).

### 11.2. Contact Information

**Wildan Syukri Niam**
- Email: wildanniam4@gmail.com
- GitHub: https://github.com/wildanniam
- LinkedIn: (add if available)

---

**End of Whitepaper**
