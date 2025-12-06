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
        Schema::table('users', function (Blueprint $table) {
            $table->string('phone')->nullable()->after('email');
            $table->string('country_code', 8)->nullable()->after('phone');
            $table->string('status')->default('pending')->after('password');
            $table->string('preferred_role')->nullable()->after('status');
            $table->timestamp('phone_verified_at')->nullable()->after('email_verified_at');
            $table->timestamp('last_login_at')->nullable()->after('remember_token');
            $table->text('bio')->nullable()->after('preferred_role');
            $table->json('metadata')->nullable()->after('bio');

            $table->unique('phone');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropUnique(['phone']);

            $table->dropColumn([
                'phone',
                'country_code',
                'status',
                'preferred_role',
                'phone_verified_at',
                'last_login_at',
                'bio',
                'metadata',
            ]);
        });
    }
};
