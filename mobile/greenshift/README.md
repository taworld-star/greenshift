# GreenShift - Mobile App

Aplikasi mobile Flutter untuk klasifikasi sampah dengan AI.

## Fitur

- Scan sampah menggunakan kamera
- Pilih gambar dari galeri
- Hasil klasifikasi dengan tingkat keyakinan
- Tips pembuangan sampah
- Dashboard statistik scan
- Konten edukasi pengelolaan sampah
- Login dan registrasi

## Prasyarat

- Flutter 3.x
- Android Studio / VS Code
- Android SDK / Xcode (untuk iOS)

## Instalasi

```bash
cd mobile/greenshift
flutter pub get
```

## Konfigurasi

Sebelum menjalankan, ubah IP address server di file `lib/data/service/httpservice.dart`:

```dart
// Ganti dengan IP komputer Anda
static const String _laravelBaseUrl = 'http://192.168.x.x:8000/api';
static const String _pythonBaseUrl = 'http://192.168.x.x:5000';
```

Untuk menemukan IP:
- Windows: `ipconfig`
- Linux/Mac: `ifconfig` atau `ip addr`

## Menjalankan

```bash
flutter run
```

## Struktur Folder

```
lib/
├── main.dart                 # Entry point
├── data/
│   ├── model/               # Data models
│   ├── repository/          # API repositories
│   ├── service/             # HTTP service
│   └── usecase/             # Request/Response models
└── presentation/
    ├── admin/               # Admin dashboard
    ├── auth/                # Login & Register
    ├── education/           # Konten edukasi
    ├── home/                # Halaman utama
    ├── profile/             # Profil user
    ├── scan/                # Fitur scan AI
    └── widgets/             # Widget reusable
```

## Dependencies Utama

- `camera` - Akses kamera
- `image_picker` - Pilih gambar
- `dio` & `http` - HTTP client
- `provider` - State management
- `google_fonts` - Typography
- `shared_preferences` - Local storage
