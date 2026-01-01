<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\EducationalContent;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Create Admin User
        $admin = User::create([
            'name' => 'Admin GreenShift',
            'email' => 'admin@greenshift.com',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);

        // Create Regular User
        $user = User::create([
            'name' => 'User Demo',
            'email' => 'user@greenshift.com',
            'password' => Hash::make('user123'),
            'role' => 'user',
        ]);

        // Create Sample Educational Contents
        EducationalContent::create([
            'title' => 'Apa itu Sampah Organik?',
            'content' => 'Sampah organik adalah sampah yang berasal dari makhluk hidup dan dapat terurai secara alami. Contoh: sisa makanan, kulit buah, daun, dll.',
            'category' => 'organik',
            'image_url' => 'https://via.placeholder.com/400x300?text=Sampah+Organik',
            'created_by_admin_id' => $admin->id,
        ]);

        EducationalContent::create([
            'title' => 'Mengenal Sampah Anorganik',
            'content' => 'Sampah anorganik adalah sampah yang tidak dapat terurai secara alami. Contoh: plastik, botol kaca, kaleng, dll. Sampah ini harus didaur ulang.',
            'category' => 'anorganik',
            'image_url' => 'https://via.placeholder.com/400x300?text=Sampah+Anorganik',
            'created_by_admin_id' => $admin->id,
        ]);

        EducationalContent::create([
            'title' => 'Bahaya Sampah B3',
            'content' => 'Sampah B3 (Bahan Berbahaya dan Beracun) adalah limbah yang mengandung zat berbahaya. Contoh: baterai, obat kedaluwarsa, hairspray, cat, dll. JANGAN dibuang sembarangan!',
            'category' => 'b3',
            'image_url' => 'https://via.placeholder.com/400x300?text=Sampah+B3',
            'created_by_admin_id' => $admin->id,
        ]);
    }
}