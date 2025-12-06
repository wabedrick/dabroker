<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('property_favorites', function (Blueprint $table): void {
            $table->uuid('public_id')->nullable()->after('id')->unique();
        });

        DB::table('property_favorites')->select(['id'])->chunkById(100, function ($favorites): void {
            foreach ($favorites as $favorite) {
                DB::table('property_favorites')
                    ->where('id', $favorite->id)
                    ->update(['public_id' => (string) Str::uuid()]);
            }
        });

        Schema::table('property_favorites', function (Blueprint $table): void {
            $table->uuid('public_id')->nullable(false)->change();
        });
    }

    public function down(): void
    {
        Schema::table('property_favorites', function (Blueprint $table): void {
            $table->dropUnique(['public_id']);
            $table->dropColumn('public_id');
        });
    }
};
