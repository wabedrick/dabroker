<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('lodging_availability', function (Blueprint $table) {
            $table->id();
            $table->foreignId('lodging_id')->constrained()->cascadeOnDelete();
            $table->date('date');
            $table->boolean('is_available')->default(true);
            $table->decimal('price_override', 10, 2)->nullable();
            $table->timestamps();
            
            $table->unique(['lodging_id', 'date']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lodging_availability');
    }
};
