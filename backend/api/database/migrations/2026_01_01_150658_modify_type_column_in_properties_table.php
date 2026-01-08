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
        Schema::table('properties', function (Blueprint $table) {
            // Change type column to string to support more types like car, etc.
            $table->string('type')->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('properties', function (Blueprint $table) {
            // Revert back to enum if needed, but might be risky if data exists
            // For now, we can leave it as string or try to convert back
            // $table->enum('type', ['land', 'house'])->change();
        });
    }
};
