# Kampung Wisata Keramik Dinoyo – Mobile App

Aplikasi mobile resmi untuk **Kampung Wisata Keramik Dinoyo**, Kota Malang. Dibangun menggunakan **Flutter** berdasarkan desain antarmuka Figma (10 Mobile Screens).

---

## 📱 Fitur Utama

### 1. Tampilan Pengunjung (Public App)
- **Beranda (Home)**: Banner hero interaktif, ringkasan sejarah, keunggulan kampung keramik, preview pengrajin, dan CTA edukasi workshop.
- **Sejarah & Timeline**: Jelajahi linimasa era sejarah keramik Dinoyo dengan chip navigasi tahun.
- **Direktori Pengrajin**: Katalog lengkap toko & pengrajin keramik dengan filter kategori, pencarian real-time, dan urutan alfabet.
- **Profil Toko**: Detail toko, jam operasional, status workshop edukasi, katalog produk, dan galeri karya keramik.
- **Tentang Kami**: Informasi budaya, profil paguyuban, visi misi, serta fasilitas kampung.
- **Kontak & Navigasi**: Integrasi WhatsApp resmi, Google Maps lokasi pengrajin, dan kontak paguyuban.
- **User Persona**: Halaman khusus profil target pengguna (persona Robbi).

### 2. Panel Admin & Manajemen (CRUD)
- **Login Admin**: Halaman autentikasi khusus pengelola paguyuban.
- **Dashboard Admin**: Ringkasan data pengrajin, status aktif/nonaktif, pencarian, dan filtering toko.
- **Form Tambah / Edit Toko**: Form manajemen toko lengkap dengan validasi input, jam buka, workshop, dan foto.
- **Quick Switch**: Akses cepat antara mode Pengunjung dan mode Admin di bagian header.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: Flutter 3.47+ (Dart 3.13+)
- **Typography**: [Google Fonts (Inter)](https://pub.dev/packages/google_fonts)
- **Integrasi Eksternal**: [url_launcher](https://pub.dev/packages/url_launcher) (WhatsApp & Maps)
- **Desain & UI**: Clean Architecture berbasis Material 3 dengan palet warna earthy terracotta khas keramik Dinoyo.

---

## 🚀 Panduan Menjalankan Aplikasi

1. **Clone repository**:
   ```bash
   git clone https://github.com/Ilfasya2008/Kampung-Wisata-Keramik-Dinoyo-Mobile.git
   cd Kampung-Wisata-Keramik-Dinoyo-Mobile
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**:
   - Di Web (Chrome):
     ```bash
     flutter run -d chrome
     ```
   - Di Android / Emulator:
     ```bash
     flutter run
     ```

---

## 📂 Struktur Proyek

```text
lib/
├── data/          # Dummy data & model data (Shop, Product, History)
├── screens/       # 10 Layar aplikasi (Beranda, Direktori, Profil, Admin, dsb.)
├── theme/         # Design token, warna (terracotta/earthy), tipografi Inter
├── utils/         # Helper external launcher (WhatsApp, Maps, Mail)
├── widgets/       # Reusable components (Bottom Nav, Cards, Form Fields)
└── main.dart      # Entry point aplikasi & route configuration
```
