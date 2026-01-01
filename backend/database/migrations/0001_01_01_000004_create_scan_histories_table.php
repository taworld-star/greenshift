<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
         Schema::create('scan_histories', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->onDelete('cascade');
            $table->string('image_path');
            $table->enum('classification_result', ['organik', 'anorganik', 'b3']);
            $table->decimal('confidence_score', 5, 4); // 0.9999
            $table->text('description')->nullable();
            $table->timestamps();

            // Index untuk performa query
            $table->index('user_id');
            $table->index('classification_result');
            $table->index('created_at');
         });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('scan_histories');
    }
};
