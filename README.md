# 🌐 App Terjemahan — Penerjemah Cerdas Multi-Bahasa HD

> **Versi 2.0.0 (Pro Final)** | Flutter Android | Developed by **mzkyzak**

Penerjemah suara & teks real-time tingkat lanjut dengan dukungan multi-mesin AI (**Google Free, Google Cloud, DeepL, OpenAI GPT**), pengenal suara native, serta sistem pembacaan teks HD dengan pemilihan gender suara (**Pria Bas / Wanita Merdu**) dan fitur **Live Sound Preview** di Pengaturan.

---

## 📋 Daftar Isi

- [Tentang Aplikasi](#-tentang-aplikasi)
- [Fitur Utama](#-fitur-utama)
- [Cara Penggunaan](#-cara-penggunaan)
- [Sistem Suara & TTS (Pria vs Wanita)](#-sistem-suara--tts-pria-vs-wanita)
- [Speech-to-Text (Mikrofon)](#-speech-to-text-mikrofon)
- [Mesin Terjemahan & API Key](#-mesin-terjemahan--api-key)
- [Pengaturan Lanjutan](#-pengaturan-lanjutan)
- [Riwayat Terjemahan](#-riwayat-terjemahan)
- [Profil Pengguna](#-profil-pengguna)
- [Arsitektur Teknis](#-arsitektur-teknis)
- [Persyaratan & Perizinan](#-persyaratan--perizinan)
- [Troubleshooting](#-troubleshooting)

---

## 📖 Tentang Aplikasi

**App Terjemahan** adalah aplikasi penerjemah canggih berbasis Flutter yang dirancang untuk memberikan pengalaman terjemahan yang cepat, akurat, dan alami di seluruh dunia. Aplikasi ini mendukung alur kerja percakapan penuh:

```
🎙️ Suara Anda (STT)  →  📝 Input Teks  →  🧠 Mesin AI (Translation)  →  🌍 Hasil Terjemahan  →  🔊 Dibacakan (TTS HD)
```

Aplikasi ini mengatasi kebutuhan penerjemahan sehari-hari, komunikasi antar negara, bisnis profesional, hingga pembelajaran bahasa secara interaktif.

---

## ✨ Fitur Utama

| Fitur | Deskripsi | Status |
|-------|-----------|--------|
| 🎙️ **Speech-to-Text (Mic)** | Tangkap pembicaraan langsung jadi teks via Google Speech Recognizer | ✅ Aktif |
| 🌍 **Multi-Engine AI** | Google Translate (Gratis), Google Cloud API, DeepL, & OpenAI GPT-4o-mini | ✅ Aktif |
| 🔊 **Text-to-Speech (Speaker)** | Pembacaan terjemahan alami dengan kualitas audio HD | ✅ Aktif |
| 👨‍🎤 **Presisi Gender Suara** | Pilihan **Suara Pria (Bas Berwibawa)** dan **Suara Wanita (Merdu Jernih)** | ✅ Fixed & Aktif |
| 🔊 **Live Sound Preview** | Dengar contoh suara pria & wanita secara langsung di modal Pengaturan | ✅ Aktif |
| 🔄 **Auto-Detect Bahasa** | Deteksi otomatis bahasa sumber secara cerdas | ✅ Aktif |
| 📜 **Riwayat Terjemahan** | Simpan hingga 100 terjemahan terakhir secara offline | ✅ Aktif |
| 💾 **Persistensi Sesi** | Teks, bahasa, dan konfigurasi tersimpan otomatis | ✅ Aktif |
| 🌙 **Tema Visual Modern** | Tampilan Gelap (Dark Mode), Terang, atau Ikuti Sistem dengan Efek Kaca | ✅ Aktif |
| 📳 **Haptic Feedback** | Umpan balik getaran halus pada setiap interaksi tombol | ✅ Aktif |
| 👤 **Profil Pengguna** | Nama, foto profil, dan statistik penggunaan personal | ✅ Aktif |
| 🔑 **API Key Manager & Tester** | Pengaturan & pengujian koneksi API Key secara real-time | ✅ Aktif |

---

## 🚀 Cara Penggunaan

### 1. Terjemahan Teks (Keyboard)
1. Buka aplikasi.
2. Pilih **bahasa asal** (kiri) dan **bahasa tujuan** (kanan).
3. Ketik kata atau kalimat pada kotak input.
4. Tekan tombol **Terjemahkan** — hasil akan muncul secara instan.
5. Tekan tombol **🔊 Speaker** untuk mendengarkan pelafalan.

### 2. Terjemahan Suara (Mikrofon 🎙️)
1. Tekan tombol **🎙️ Mikrofon** di layar utama.
2. Saat dialog Google Speech muncul, **ucapkan kalimat Anda** dengan jelas.
3. Teks ucapan Anda akan otomatis masuk ke kolom input dan langsung diterjemahkan.
4. Hasil terjemahan otomatis dibacakan oleh pembicara (TTS).

### 3. Mengatur & Menguji Suara (Pria / Wanita)
1. Tekan ikon **⚙️ Pengaturan** di toolbar.
2. Scroll ke bagian **Suara & Bahasa** → pilih **Pilihan Suara (Pria / Wanita)**.
3. Ketuk opsi **Suara Pria (Cowok)** atau **Suara Wanita (Cewek)**.
4. Contoh suara akan langsung **diputar secara otomatis (Live Sound Preview)** agar Anda bisa mencobanya sebelum disimpan.

---

## 🔊 Sistem Suara & TTS (Pria vs Wanita)

Aplikasi dilengkapi dengan engine **Google Neural HD Text-to-Speech** yang telah disesuaikan agar menghasilkan suara yang alami, tidak kaku, dan sesuai dengan gender yang dipilih:

| Gender | Pitch | Speed Rate | Karakteristik Suara |
|--------|-------|------------|---------------------|
| 👨 **Pria (Cowok)** | `0.60` | `0.45` | Bas dalam, berat, tegas, dan berwibawa |
| 👩 **Wanita (Cewek)** | `1.18` | `0.45` | Merdu, jernih, lembut, dan ramah |

> **Strategi Presisi Gender Matching (3-Layer)**:
> 1. **Layer 1 (Explicit Field)**: Memeriksa atribut `gender` pada voice pack sistem Android (`male` vs `female`).
> 2. **Layer 2 (Name Matching)**: Mengidentifikasi pola kode suara Google Neural HD (`-dfz-`, `-sfg-`, `pria`, `male` vs `-a-`, `-c-`, `-e-`, `-f-`, `wanita`, `female`).
> 3. **Layer 3 (Acoustic Pitch Isolation)**: Mengisolasi pitch audio sehingga suara wanita **tidak akan pernah tertukar** menjadi suara pria atau sebaliknya.

---

## 🎙️ Speech-to-Text (Mikrofon)

Pengenalan suara menggunakan **Native Android Speech RecognizerIntent** (Google Speech Engine):

- **Akurasi Tinggi**: Mengenali percakapan dalam berbagai bahasa dan aksen.
- **Hands-Free**: Mengubah suara langsung menjadi teks tanpa perlu mengetik manual.
- **Koneksi Cepat**: Terintegrasi langsung dengan mesin penerjemah.

---

## 🧠 Mesin Terjemahan & API Key

Aplikasi mendukung 4 mesin penerjemah dengan sistem **Hybrid Automatic Fallback**:

```
1. Google Cloud API Key (Jika diatur & valid)
   └─► 2. DeepL / OpenAI API (Jika diatur)
        └─► 3. Google Translate Free Engine (Cadangan Otomatis — Tanpa API Key)
```

| Engine | Kebutuhan API Key | Keunggulan |
|--------|-------------------|------------|
| 🆓 **Google Free** | **Tidak Perlu** (Default) | Cepat, gratis, mendukung 100+ bahasa dunia |
| ☁️ **Google Cloud** | Perlu API Key (`AIza...`) | Performa enterprise, tanpa batas rate-limit |
| 📘 **DeepL API** | Perlu API Key (`...:fx`) | Kualitas terjemahan bahasa Eropa & profesional terbaik |
| 🤖 **OpenAI GPT** | Perlu API Key (`sk-...`) | Terjemahan kontekstual cerdas (`gpt-4o-mini`) |

---

## ⚙️ Pengaturan Lanjutan

Menu Pengaturan menyediakan kontrol penuh terhadap aplikasi:

- **Tema Visual**: Dark Mode (Indera visual nyaman), Light Mode, atau Ikuti Sistem.
- **Haptic Feedback**: Mengatur respons getaran tombol (Aktif / Nonaktif).
- **Auto-Detect Language**: Deteksi otomatis bahasa input saat diketik/diucapkan.
- **API Key Tester**: Uji keabsahan API Key Anda secara langsung dengan menekan **Test Koneksi**.

---

## 📜 Riwayat Terjemahan

- Menyimpan **100 entri terjemahan terakhir** secara offline.
- Dapat diakses dari ikon **📜 Riwayat** di toolbar utama.
- **Tap item** untuk memuat ulang teks & terjemahan ke layar utama.
- Mendukung **Hapus Individual** atau **Bersihkan Semua Riwayat**.

---

## 👤 Profil Pengguna

- **Manajemen Identitas**: Ubah nama pengguna dan email.
- **Foto Profil**: Ambil foto langsung dari **Kamera** atau pilih dari **Galeri**.
- **Statistik Penggunaan**: Menampilkan total terjemahan yang telah dilakukan.

---

## 🏗️ Arsitektur Teknis

```
lib/
├── main.dart                      # State utama, UI utama, & logic TTS
├── models/
│   ├── language.dart              # Model bahasa (100+ BCP-47 languages)
│   └── translation_history.dart  # Model data riwayat terjemahan
├── services/
│   ├── translation_service.dart   # Hybrid multi-engine translation logic
│   ├── language_service.dart      # Kode bahasa & BCP-47 converter
│   ├── settings_service.dart      # Storage preferensi pengguna
│   ├── history_service.dart       # Pengelolaan riwayat lokal
│   ├── native_speech_service.dart # Native Android STT bridge
│   ├── haptic_service.dart        # Kontrol getar (haptics)
│   └── user_profile_service.dart  # Pengelolaan profil pengguna
├── screens/
│   ├── settings_screen.dart       # Layar pengaturan & live audio preview
│   └── profile_screen.dart        # Layar profil pengguna
└── widgets/
    ├── language_bar.dart           # UI Pemilih bahasa
    ├── translation_input.dart      # UI Kotak input teks & mic
    ├── translation_result.dart     # UI Hasil terjemahan & speaker
    ├── history_bottom_sheet.dart   # UI Panel riwayat
    └── star_field.dart             # Animasi visual background
```

---

## 📱 Persyaratan & Perizinan

### Persyaratan Minimum
- **Sistem Operasi**: Android 5.0 (API 21) atau yang lebih baru
- **Perangkat**: Memiliki mikrofon dan speaker aktif
- **Koneksi**: Terhubung ke internet (untuk penerjemahan AI & STT)

### Izin Perangkat (Permissions)
- `RECORD_AUDIO` — Digunakan untuk pengenalan suara mikrofon (Speech-to-Text).
- `INTERNET` — Digunakan untuk mengakses API terjemahan.
- `CAMERA` & `READ_EXTERNAL_STORAGE` — Opsional, untuk mengubah foto profil.

---

## 🔧 Troubleshooting

### ❓ Suara wanita malah terdengar seperti pria?
> **Sudah Diperbaiki di v2.0.0**: Pastikan Anda memperbarui aplikasi ke versi terbaru. Di menu **Pengaturan → Pilihan Suara**, ketuk **Suara Wanita (Cewek)**. Dengarkan contoh suaranya di fitur **Live Sound Preview** untuk memastikan suara sudah feminine & jernih (`pitch 1.18`).

### ❓ Mikrofon tidak menangkap ucapan?
> 1. Pastikan izin **Mikrofon** diatur ke **Izinkan** di Pengaturan Ponsel → Aplikasi → App Terjemahan.
> 2. Pastikan layanan **Speech Services by Google** aktif pada perangkat Android Anda.

---

## 👨‍💻 Pengembang

Dikembangkan oleh **mzkyzak**  
*Built with ❤️ using Flutter, Google Cloud, DeepL & OpenAI*
