<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('property_inquiries', function (Blueprint $table): void {
            $table->timestamp('read_at')->nullable()->after('responded_at')->index();
        });
    }

    public function down(): void
    {
        Schema::table('property_inquiries', function (Blueprint $table): void {
            $table->dropIndex(['read_at']);
            $table->dropColumn('read_at');
        });
    }
};
