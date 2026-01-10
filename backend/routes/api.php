<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ContentController;
use App\Http\Controllers\Api\ScanController;

// Route untuk Register (Daftar Akun Baru)
Route::post('/register', [AuthController::class, 'register']);
// Route untuk Login (Masuk)
Route::post('/login', [AuthController::class, 'login']);


// PUBLIC ROUTES
Route::get('/contents', [ContentController::class, 'index']); 
Route::get('/contents/{id}', [ContentController::class, 'show']); 

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);

    // SCAN ROUTES
    Route::get('/scan/dashboard', [ScanController::class, 'dashboard']);
    Route::post('/scan', [ScanController::class, 'store']);

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