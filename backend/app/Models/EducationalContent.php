<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EducationalContent extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'content',
        'category',
        'image',
        'created_by_admin_id',
    ];

    // Relationship dengan User 
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by_admin_id');
    }
}