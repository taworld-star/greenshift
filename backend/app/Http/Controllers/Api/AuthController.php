<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // Daftar Akun Baru
    public function register(Request $request)
    {
        // 1. Validasi Input
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // 2. User Baru
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password), // Password di-enkripsi
            'role' => 'user', // Default role adalah user biasa
        ]);

        // 3. Profil User 
        UserProfile::create([
            'user_id' => $user->id,
            'total_scans' => 0,
            'points' => 0,
        ]);

        // 4. Token Akses (Tiket masuk)
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'User registered successfully',
            'user' => $user,
            'token' => $token
        ], 201);
    }

    // FUNGSI 2: LOGIN (Masuk Aplikasi)
    public function login(Request $request)
    {
        // 1. Validasi Input
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // 2. User berdasarkan Email
        $user = User::where('email', $request->email)->first();

        // 3. Password
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau Password salah'
            ], 401);
        }

        // 4. Token Baru
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
            ],
            'token' => $token
        ], 200);
    }

    // FUNGSI 3: LOGOUT (Keluar Aplikasi)
    public function logout(Request $request)
    {
        // Hapus token yang sedang dipakai (agar tidak bisa dipakai lagi)
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully'
        ], 200);
    }

    // FUNGSI 4: USER (Cek Data Diri Sendiri)
    public function user(Request $request)
    {
        $user = $request->user();
        // Ambil data profil tambahan (poin & scan)
        $profile = UserProfile::where('user_id', $user->id)->first();

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'total_scans' => $profile->total_scans ?? 0,
                'points' => $profile->points ?? 0,
            ]
        ], 200);
    }
}