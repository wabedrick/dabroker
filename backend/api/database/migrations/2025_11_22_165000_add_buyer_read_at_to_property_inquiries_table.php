<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('property_inquiries', function (Blueprint $table): void {
            $table->timestamp('buyer_read_at')->nullable()->after('read_at')->index();
        });
    }

    public function down(): void
    {
        Schema::table('property_inquiries', function (Blueprint $table): void {
            $table->dropIndex(['buyer_read_at']);
            $table->dropColumn('buyer_read_at');
        });
    }
};
