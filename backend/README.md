# GreenShift - Backend API

REST API backend untuk aplikasi GreenShift menggunakan Laravel dengan autentikasi Sanctum.

## Teknologi

- Laravel 11.x
- SQLite (default) / MySQL
- Laravel Sanctum - API Authentication

## Prasyarat

- PHP 8.2+
- Composer 2.x

## Instalasi

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
```

## Konfigurasi

Edit file `.env` untuk mengubah konfigurasi database:

```env
# SQLite (default)
DB_CONNECTION=sqlite

# MySQL (opsional)
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=greenshift
DB_USERNAME=root
DB_PASSWORD=
```

## Menjalankan

```bash
php artisan serve
```
Server berjalan di `http://localhost:8000`

## API Endpoints

### Authentication

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/register` | Registrasi user baru |
| POST | `/api/login` | Login user |
| POST | `/api/logout` | Logout (auth required) |
| GET | `/api/user` | Get user info (auth required) |

### Scan (Auth Required)

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/scan` | Simpan hasil scan |
| GET | `/api/scan/dashboard` | Statistik scan user |

### Content

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/contents` | List semua konten |
| GET | `/api/contents/{id}` | Detail konten |

### Admin (Admin Only)

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/admin/contents` | Buat konten baru |
| PUT | `/api/admin/contents/{id}` | Update konten |
| DELETE | `/api/admin/contents/{id}` | Hapus konten |
