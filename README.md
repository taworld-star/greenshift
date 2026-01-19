# GreenShift

Aplikasi klasifikasi sampah berbasis AI yang mendukung SDGs Goal 12 (Responsible Consumption and Production). Aplikasi ini membantu pengguna mengidentifikasi jenis sampah (Organik, Anorganik, B3) melalui kamera smartphone.

## Arsitektur Sistem

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Mobile App     │────>│  Laravel API    │────>│  Python ML      │
│  (Flutter)      │<────│  (Backend)      │<────│  (AI Service)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
      :5000                   :8000                   :5000
```

## Prasyarat

| Komponen | Versi Minimum |
|----------|---------------|
| PHP | 8.2+ |
| Composer | 2.x |
| Python | 3.10+ |
| Flutter | 3.x |
| Android Studio / VS Code | Latest |

## Quick Start

### 1. Python ML Service

```bash
cd python_service
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # Linux/Mac
pip install flask flask-cors tf-keras pillow numpy
python app.py
```
Server berjalan di `http://localhost:5000`

### 2. Laravel Backend

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```
Server berjalan di `http://localhost:8000`

### 3. Flutter Mobile

```bash
cd mobile/greenshift
flutter pub get
flutter run
```

> **Penting:** Sebelum menjalankan Flutter, ubah IP address di `lib/data/service/httpservice.dart` sesuai IP komputer Anda.

## Struktur Folder

```
├── backend/           # Laravel REST API
├── mobile/            # Flutter Mobile App
│   └── greenshift/
├── python_service/    # Flask + Keras ML Service
└── README.md
```

## Fitur Utama

- Klasifikasi sampah menggunakan kamera (Organik, Anorganik, B3)
- Tips pembuangan sampah berdasarkan kategori
- Dashboard statistik scan
- Konten edukasi pengelolaan sampah
- Autentikasi pengguna

## Pengembang

| Nama | Peran |
|------|-------|
| Sustri Elina Simamora | Developer |
