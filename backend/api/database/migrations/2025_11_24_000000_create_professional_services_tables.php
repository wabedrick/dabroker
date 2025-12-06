<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('professional_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('license_number')->nullable();
            $table->json('specialties')->nullable();
            $table->text('bio')->nullable();
            $table->decimal('hourly_rate', 10, 2)->nullable();
            $table->string('verification_status')->default('pending'); // pending, verified, rejected
            $table->timestamps();
        });

        Schema::create('consultations', function (Blueprint $table) {
            $table->id();
            $table->uuid('public_id')->unique();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete(); // The client
            $table->foreignId('professional_id')->constrained('users')->cascadeOnDelete(); // The professional
            $table->dateTime('scheduled_at');
            $table->string('status')->default('pending'); // pending, confirmed, completed, cancelled, rejected
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('consultations');
        Schema::dropIfExists('professional_profiles');
    }
};
