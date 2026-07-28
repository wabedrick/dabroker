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
        Schema::dropIfExists('consultations');
        Schema::dropIfExists('professional_portfolios');
        Schema::dropIfExists('professional_profiles');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Not implementing down() since we are removing the feature entirely
    }
};
