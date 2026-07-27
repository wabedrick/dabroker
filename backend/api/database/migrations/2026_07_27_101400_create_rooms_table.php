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
        Schema::create('rooms', function (Blueprint $table) {
            $table->id();
            $table->uuid('public_id')->unique();
            $table->foreignId('property_id')->constrained('properties')->cascadeOnDelete();
            $table->string('name');
            $table->decimal('price', 15, 2);
            $table->string('currency', 3)->default('USD');
            $table->json('features')->nullable();
            $table->boolean('is_available')->default(true);
            $table->text('description')->nullable();
            $table->timestamps();

            $table->index('property_id');
            $table->index('is_available');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rooms');
    }
};
