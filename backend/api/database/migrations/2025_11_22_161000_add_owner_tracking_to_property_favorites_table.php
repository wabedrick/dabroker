<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('property_favorites', function (Blueprint $table): void {
            $table->foreignId('owner_id')
                ->nullable()
                ->after('property_id')
                ->constrained('users')
                ->cascadeOnDelete();
            $table->timestamp('owner_read_at')->nullable()->after('owner_id')->index();
        });

        DB::table('property_favorites')->select(['id', 'property_id'])->chunkById(100, function ($favorites): void {
            foreach ($favorites as $favorite) {
                $ownerId = DB::table('properties')->where('id', $favorite->property_id)->value('owner_id');

                DB::table('property_favorites')
                    ->where('id', $favorite->id)
                    ->update(['owner_id' => $ownerId]);
            }
        });
    }

    public function down(): void
    {
        Schema::table('property_favorites', function (Blueprint $table): void {
            $table->dropIndex(['owner_read_at']);
            $table->dropConstrainedForeignId('owner_id');
            $table->dropColumn('owner_read_at');
        });
    }
};
