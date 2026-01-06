<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;

// Route untuk Register (Daftar Akun Baru)
Route::post('/register', [AuthController::class, 'register']);

// Route untuk Login (Masuk)
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    // (Hapus Token)
    Route::post('/logout', [AuthController::class, 'logout']);
    // Cek Profil User
    Route::get('/user', [AuthController::class, 'user']);
});