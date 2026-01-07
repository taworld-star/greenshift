<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EducationalContent; 
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ContentController extends Controller
{
    // 1.Mengambil Semua Data (Public) 
    public function index(Request $request)
    {
        $query = EducationalContent::query();

        // Fitur Filter Kategori (Misal: ?category=organik)
        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        // Fitur Pencarian Judul 
        if ($request->has('search')) {
            $query->where('title', 'like', '%' . $request->search . '%');
        }

        // Ambil data terbaru, paginasi 10 per halaman
        $contents = $query->latest()->paginate(10);

        return response()->json([
            'success' => true,
            'data' => $contents
        ], 200);
    }

    //  2. SHOW: Mengambil Detail 1 Konten (Public) 
    public function show($id)
    {
        $content = EducationalContent::find($id);

        if (!$content) {
            return response()->json([
                'success' => false,
                'message' => 'Konten tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $content
        ], 200);
    }

    // 3. STORE: Menambah Konten Baru + Gambar (Admin) 
    public function store(Request $request)
    {
        // Validasi Input
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'category' => 'required|in:organik,anorganik,b3', 
            'image' => 'nullable|image|mimes:jpeg,png,jpg,heic, heif|max:5120', // Max 5MB
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // Proses Upload Gambar
        $imageUrl = null;
        if ($request->hasFile('image')) {
            // Menyimpan ke folder 'storage/app/public/contents'
            $path = $request->file('image')->store('contents', 'public');
            // URL agar bisa diakses dari luar
            $imageUrl = asset('storage/' . $path);
        }

        // Menyimpan ke Database
        $content = EducationalContent::create([
            'title' => $request->title,
            'content' => $request->content,
            'category' => $request->category,
            'image' => $imageUrl,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Konten berhasil ditambahkan',
            'data' => $content
        ], 201);
    }

    // 4. UPDATE: Edit Konten (Admin) 
    public function update(Request $request, $id)
    {
        $content = EducationalContent::find($id);

        if (!$content) {
            return response()->json(['success' => false, 'message' => 'Konten tidak ditemukan'], 404);
        }

        // Validasi opsional
        $validator = Validator::make($request->all(), [
            'title' => 'sometimes|string|max:255',
            'content' => 'sometimes|string',
            'category' => 'sometimes|in:organik,anorganik,b3',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,heic, heif|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        // Cek upload gambar baru
        if ($request->hasFile('image')) {
            // Menghapus gambar lama jika ada
            if ($content->image_url) {
                // Mengambil path relatif dari URL lengkap
                $oldPath = str_replace(asset('storage/'), '', $content->image_url);
                Storage::disk('public')->delete($oldPath);
            }

            // Upload gambar baru
            $path = $request->file('image')->store('contents', 'public');
            $content->image_url = asset('storage/' . $path);
        }

        // Update data teks
        $content->update($request->only(['title', 'content', 'category']));
        $content->save();

        return response()->json([
            'success' => true,
            'message' => 'Konten berhasil diperbarui',
            'data' => $content
        ], 200);
    }

    // 5. DESTROY: Hapus Konten (Admin)
    public function destroy($id)
    {
        $content = EducationalContent::find($id);

        if (!$content) {
            return response()->json(['success' => false, 'message' => 'Konten tidak ditemukan'], 404);
        }

        // Menghapus file gambar dari folder penyimpanan
        if ($content->image_url) {
            $path = str_replace(asset('storage/'), '', $content->image_url);
            Storage::disk('public')->delete($path);
        }

        // Menghapus data dari database
        $content->delete();

        return response()->json([
            'success' => true,
            'message' => 'Konten berhasil dihapus'
        ], 200);
    }
}