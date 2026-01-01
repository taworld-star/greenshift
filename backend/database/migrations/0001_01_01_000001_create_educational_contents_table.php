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
        Schema::create('educational_contents', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('content');
            $table->enum('category', ['organik', 'anorganik', 'b3']);
            $table->string('img_url')->nullable();
             $table->foreignId('created_by_admin_id')
                  ->constrained('users')
                  ->onDelete('cascade');
            $table->timestamps();

            //Index untuk performa query
            $table->index('category');
            $table->index('created_by_admin_id');
        });

    }
    
    public function down(): void
    {
        Schema::dropIfExists('educational_contents');
    }
};
