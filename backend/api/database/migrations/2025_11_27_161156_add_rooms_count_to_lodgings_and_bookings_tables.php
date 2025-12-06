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
        Schema::table('lodgings', function (Blueprint $table) {
            $table->integer('total_rooms')->default(1)->after('max_guests');
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->integer('rooms_count')->default(1)->after('guests_count');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('lodgings', function (Blueprint $table) {
            $table->dropColumn('total_rooms');
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->dropColumn('rooms_count');
        });
    }
};
