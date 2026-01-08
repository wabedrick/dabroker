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
        Schema::create('auctions', function (Blueprint $table) {
            $table->id();
            $table->uuid('public_id')->unique();
            $table->foreignId('property_id')->constrained()->cascadeOnDelete();
            $table->foreignId('seller_id')->constrained('users'); // The bank or user selling
            $table->dateTime('start_time');
            $table->dateTime('end_time');
            $table->decimal('starting_price', 15, 2);
            $table->decimal('reserve_price', 15, 2)->nullable();
            $table->decimal('current_price', 15, 2)->nullable(); // Cache current highest bid
            $table->string('status')->default('scheduled'); // scheduled, active, ended, cancelled
            $table->timestamps();
            $table->softDeletes();
            
            $table->index(['status', 'end_time']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('auctions');
    }
};
