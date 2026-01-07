<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ContentController;

// Route untuk Register (Daftar Akun Baru)
Route::post('/register', [AuthController::class, 'register']);

// Route untuk Login (Masuk)
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);

    // ADMIN ROUTES
    Route::middleware('admin')->group(function () {
        // CRUD Konten
        Route::post('/admin/contents', [ContentController::class, 'store']);
        Route::post('/admin/contents/{id}', [ContentController::class, 'update']); 
        Route::delete('/admin/contents/{id}', [ContentController::class, 'destroy']);
        
        // Test Route 
        Route::get('/test-admin', function () {
            return response()->json(['message' => 'Admin Access Granted']);
        });
    });
});