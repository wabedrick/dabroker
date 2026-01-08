<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('professional_profiles', function (Blueprint $table) {
            $table->integer('experience_years')->nullable()->after('hourly_rate');
            $table->json('languages')->nullable()->after('specialties');
            $table->json('education')->nullable()->after('languages'); // Array of {institution, degree, year}
            $table->json('certifications')->nullable()->after('education'); // Array of {name, issuer, year}
            $table->json('social_links')->nullable()->after('certifications'); // {linkedin, website, twitter}
        });

        Schema::create('professional_portfolios', function (Blueprint $table) {
            $table->id();
            $table->foreignId('professional_profile_id')->constrained()->cascadeOnDelete();
            $table->string('title');
            $table->text('description')->nullable();
            $table->date('project_date')->nullable();
            $table->string('url')->nullable(); // External link to project
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('professional_portfolios');
        Schema::table('professional_profiles', function (Blueprint $table) {
            $table->dropColumn(['experience_years', 'languages', 'education', 'certifications', 'social_links']);
        });
    }
};
