<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ScanHistory extends Model
{
    use HasFactory;

    // Sesuaikan dengan migrasi Anda
    protected $fillable = [
        'user_id',
        'image_path',           
        'classification_result', 
        'confidence_score',     
        'description'          
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}