<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ScanHistory;
use App\Models\UserProfile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ScanController extends Controller
{
    // 1. Hitung Skor Hijau dari Scan History
    public function dashboard(Request $request)
    {
        $user = $request->user();
        $scans = ScanHistory::where('user_id', $user->id)->get();
        $organicCount = $scans->where('classification_result', 'organik')->count();
        $anorganicCount = $scans->where('classification_result', 'anorganik')->count();
        $b3Count = $scans->where('classification_result', 'b3')->count();

        $totalScans = $scans->count();
        $greenScore = 0;

        // Logic Skor Hijau
        if ($totalScans > 0) {
            $goodTrash = $organicCount + $anorganicCount;
            $greenScore = round(($goodTrash / $totalScans) * 100);
        }

        // Mengambil 5 item terbaru
        $recentItems = ScanHistory::where('user_id', $user->id)
                        ->latest()
                        ->take(5)
                        ->get()
                        ->map(function($item) {
                            return [
                                'id' => $item->id,
                                'category' => $item->classification_result, 
                                'label' => ucfirst($item->classification_result),
                                'date' => $item->created_at->diffForHumans(),
                                'confidence' => round($item->confidence_score * 100) . '%', 
                                'image' => $item->image_path 
                            ];
                        });

        return response()->json([
            'success' => true,
            'data' => [
                'user_name' => $user->name,
                'green_score' => $greenScore,
                'stats' => [
                    'organik' => $organicCount,
                    'daur_ulang' => $anorganicCount,
                    'berbahaya' => $b3Count
                ],
                'recent_items' => $recentItems
            ]
        ]);
    }

    // Menyimpan Hasil Scan ---
    public function store(Request $request)
    {
        // Validasi
        $validator = Validator::make($request->all(), [
            'classification_result' => 'required|in:organik,anorganik,b3', 
            'image' => 'required|image|max:5120',
            'confidence' => 'numeric|min:0|max:100', 
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        // Upload Gambar
        $imageUrl = null;
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('scans', 'public');
            $imageUrl = asset('storage/' . $path);
        }

        $confScore = ($request->confidence ?? 0) / 100;

        // Simpan
        ScanHistory::create([
            'user_id' => $request->user()->id,
            'classification_result' => $request->classification_result, 
            'confidence_score' => $confScore, 
            'image_path' => $imageUrl, 
            'description' => $request->description ?? null, 
        ]);

        // Update user_profiles: total_scans dan points (green score)
        $userId = $request->user()->id;
        $allScans = ScanHistory::where('user_id', $userId)->get();
        $totalScans = $allScans->count();
        
        // Hitung green score: (organik + anorganik) / total * 100
        $organikCount = $allScans->where('classification_result', 'organik')->count();
        $anorganikCount = $allScans->where('classification_result', 'anorganik')->count();
        $goodTrash = $organikCount + $anorganikCount;
        $greenScore = $totalScans > 0 ? round(($goodTrash / $totalScans) * 100) : 0;
        
        // Update atau create profile
        UserProfile::updateOrCreate(
            ['user_id' => $userId],
            ['total_scans' => $totalScans, 'points' => $greenScore]
        );

        return response()->json([
            'success' => true,
            'message' => 'Scan berhasil disimpan'
        ], 201);
    }
}