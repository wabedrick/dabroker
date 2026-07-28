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
        Schema::table('rooms', function (Blueprint $table) {
            $table->integer('capacity')->nullable()->after('is_available');
            $table->integer('quantity')->default(1)->after('capacity');
            $table->string('room_type')->nullable()->after('quantity');
            $table->string('bed_type')->nullable()->after('room_type');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('rooms', function (Blueprint $table) {
            $table->dropColumn(['capacity', 'quantity', 'room_type', 'bed_type']);
        });
    }
};
