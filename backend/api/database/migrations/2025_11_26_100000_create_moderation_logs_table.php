<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class() extends Migration
{
    public function up(): void
    {
        Schema::create('moderation_logs', function (Blueprint $table): void {
            $table->id();
            $table->morphs('moderatable');
            $table->string('moderatable_public_id')->nullable()->index();
            $table->foreignId('performed_by')->nullable()->constrained('users')->nullOnDelete();
            $table->string('action');
            $table->string('previous_status')->nullable();
            $table->string('new_status')->nullable();
            $table->text('reason')->nullable();
            $table->json('old_values')->nullable();
            $table->json('new_values')->nullable();
            $table->json('meta')->nullable();
            $table->timestamps();

            $table->index('action');
            $table->index('performed_by');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('moderation_logs');
    }
};
