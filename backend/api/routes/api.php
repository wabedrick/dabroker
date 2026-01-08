<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\FavoriteNotificationController;
use App\Http\Controllers\API\FavoritePropertyController;
use App\Http\Controllers\API\InterestedBuyerController;
use App\Http\Controllers\API\OwnerDashboardController;
use App\Http\Controllers\API\NotificationCounterController;
use App\Http\Controllers\API\NotificationPreferenceController;
use App\Http\Controllers\API\OwnerPropertyController;
use App\Http\Controllers\API\OwnerPropertyMediaController;
use App\Http\Controllers\API\OwnerPropertyInquiryController;
use App\Http\Controllers\API\PropertyApprovalController;
use App\Http\Controllers\API\PropertyBrowseController;
use App\Http\Controllers\API\PropertyInquiryMessageController;
use App\Http\Controllers\API\PropertyInquiryController;
use App\Models\Property;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    Route::get('properties', [PropertyBrowseController::class, 'index']);
    Route::get('properties/{property:public_id}', [PropertyBrowseController::class, 'show']);

    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/resend-otp', [AuthController::class, 'resendOtp']);
    Route::post('auth/verify-otp', [AuthController::class, 'verifyOtp']);
    Route::post('auth/login', [AuthController::class, 'login']);
    Route::post('auth/password/forgot', [AuthController::class, 'forgotPassword']);
    Route::post('auth/password/reset', [AuthController::class, 'resetPassword']);

    // Public lodging routes
    Route::get('lodgings', [App\Http\Controllers\API\LodgingBrowseController::class, 'index']);
    Route::get('lodgings/{lodging:public_id}', [App\Http\Controllers\API\LodgingBrowseController::class, 'show']);
    Route::get('lodgings/{lodging:public_id}/availability', [App\Http\Controllers\API\LodgingAvailabilityController::class, 'index']);

    // Public professionals routes
    Route::get('professionals', [App\Http\Controllers\API\ProfessionalController::class, 'index']);
    Route::get('professionals/{user}', [App\Http\Controllers\API\ProfessionalController::class, 'show']);

    Route::get('ratings', [App\Http\Controllers\API\RatingController::class, 'index']);

    // Public auction routes
    Route::get('auctions', [App\Http\Controllers\AuctionController::class, 'index']);
    Route::get('auctions/{auction:public_id}', [App\Http\Controllers\AuctionController::class, 'show']);

    Route::middleware('auth:sanctum')->group(function (): void {
        Route::post('professionals/{user}/contact', [App\Http\Controllers\API\ProfessionalController::class, 'contact'])
            ->middleware('throttle:5,1');
        Route::post('auth/logout', [AuthController::class, 'logout']);
        Route::get('profile', [AuthController::class, 'me']);

        Route::prefix('notifications')->group(function (): void {
            Route::get('preferences', [NotificationPreferenceController::class, 'show']);
            Route::put('preferences', [NotificationPreferenceController::class, 'update']);
            Route::get('counters', NotificationCounterController::class);
            Route::post('favorites/acknowledge', [FavoriteNotificationController::class, 'acknowledge']);
        });

        Route::post('properties/{property:public_id}/contact', [PropertyInquiryController::class, 'store'])
            ->middleware('throttle:5,1');

        Route::post('ratings', [App\Http\Controllers\API\RatingController::class, 'store']);
        Route::apiResource('consultations', App\Http\Controllers\API\ConsultationController::class);

        Route::get('inquiries', [PropertyInquiryController::class, 'index']);
        Route::get('inquiries/{inquiry:public_id}', [PropertyInquiryController::class, 'show']);
        Route::post('inquiries/{inquiry:public_id}/messages', [PropertyInquiryMessageController::class, 'store']);
        Route::post('inquiries/{inquiry:public_id}/read', [PropertyInquiryMessageController::class, 'markRead']);

        Route::prefix('professional')->group(function (): void {
            Route::post('profile', [App\Http\Controllers\API\ProfessionalController::class, 'store']);
            Route::match(['put', 'patch'], 'profile', [App\Http\Controllers\API\ProfessionalController::class, 'update']);

            Route::get('portfolio', [App\Http\Controllers\API\ProfessionalPortfolioController::class, 'index']);
            Route::post('portfolio', [App\Http\Controllers\API\ProfessionalPortfolioController::class, 'store']);
            Route::match(['put', 'patch'], 'portfolio/{id}', [App\Http\Controllers\API\ProfessionalPortfolioController::class, 'update']);
            Route::delete('portfolio/{id}', [App\Http\Controllers\API\ProfessionalPortfolioController::class, 'destroy']);
        });

        Route::prefix('host')->group(function (): void {
            Route::get('lodgings', [App\Http\Controllers\API\HostLodgingController::class, 'index']);
            Route::post('lodgings', [App\Http\Controllers\API\HostLodgingController::class, 'store']);
            Route::match(['put', 'patch'], 'lodgings/{lodging:public_id}', [App\Http\Controllers\API\HostLodgingController::class, 'update']);
            Route::delete('lodgings/{lodging:public_id}', [App\Http\Controllers\API\HostLodgingController::class, 'destroy']);

            Route::post('lodgings/{lodging:public_id}/media', [App\Http\Controllers\API\HostLodgingMediaController::class, 'store']);
            Route::delete('lodgings/{lodging:public_id}/media/{media}', [App\Http\Controllers\API\HostLodgingMediaController::class, 'destroy']);
        });

        Route::prefix('owner')->group(function (): void {
            Route::get('dashboard', OwnerDashboardController::class);

            Route::get('properties', [OwnerPropertyController::class, 'index']);
            Route::post('properties', [OwnerPropertyController::class, 'store']);
            Route::match(['put', 'patch'], 'properties/{property:public_id}', [OwnerPropertyController::class, 'update']);
            Route::delete('properties/{property:public_id}', [OwnerPropertyController::class, 'destroy']);

            Route::post('properties/{property:public_id}/media', [OwnerPropertyMediaController::class, 'store']);
            Route::delete('properties/{property:public_id}/media/{media}', [OwnerPropertyMediaController::class, 'destroy']);

            Route::get('inquiries', [OwnerPropertyInquiryController::class, 'index']);
            Route::get('inquiries/{inquiry:public_id}', [OwnerPropertyInquiryController::class, 'show']);
            Route::post('inquiries/{inquiry:public_id}/read', [PropertyInquiryMessageController::class, 'markRead']);

            Route::get('interested-buyers', [InterestedBuyerController::class, 'index']);
            Route::post('interested-buyers/{favorite:public_id}/read', [InterestedBuyerController::class, 'markRead']);
        });

        Route::prefix('admin')
            ->middleware('can:properties.approve')
            ->group(function (): void {
                Route::get('dashboard/stats', [App\Http\Controllers\API\Admin\AdminDashboardController::class, 'stats']);
                Route::get('dashboard/analytics', [App\Http\Controllers\API\Admin\AdminDashboardController::class, 'analytics']);

                Route::middleware('can:admin.manage_users')->group(function (): void {
                    Route::apiResource('users', App\Http\Controllers\API\Admin\AdminUserController::class)
                        ->only(['index', 'show', 'destroy']);
                    Route::match(['put', 'patch'], 'users/{user}', [App\Http\Controllers\API\Admin\AdminUserController::class, 'update']);
                    Route::post('users/{user}/ban', [App\Http\Controllers\API\Admin\AdminUserController::class, 'ban']);
                    Route::post('users/{user}/activate', [App\Http\Controllers\API\Admin\AdminUserController::class, 'activate']);
                });

                Route::apiResource('properties', App\Http\Controllers\API\Admin\AdminPropertyController::class)->only(['index', 'show']);
                Route::post('properties/{property:public_id}/approve', [PropertyApprovalController::class, 'approve']);
                Route::post('properties/{property:public_id}/reject', [PropertyApprovalController::class, 'reject']);

                Route::apiResource('lodgings', App\Http\Controllers\API\Admin\AdminLodgingController::class)->only(['index', 'show']);
                Route::post('lodgings/{lodging:public_id}/approve', [App\Http\Controllers\API\Admin\LodgingApprovalController::class, 'approve']);
                Route::post('lodgings/{lodging:public_id}/reject', [App\Http\Controllers\API\Admin\LodgingApprovalController::class, 'reject']);

                Route::get('moderation-logs', [App\Http\Controllers\API\Admin\AdminModerationLogController::class, 'index']);
            });

        Route::prefix('favorites')
            ->group(function (): void {
                Route::get('properties', [FavoritePropertyController::class, 'index']);
                Route::post('properties/{property:public_id}', [FavoritePropertyController::class, 'store']);
                Route::delete('properties/{property:public_id}', [FavoritePropertyController::class, 'destroy']);
            });

        // Professional application (authenticated)
        Route::post('professionals/apply', [App\Http\Controllers\API\ProfessionalController::class, 'store']);
        Route::match(['put', 'patch'], 'professionals/profile', [App\Http\Controllers\API\ProfessionalController::class, 'update']);

        Route::get('consultations', [App\Http\Controllers\API\ConsultationController::class, 'index']);
        Route::post('consultations', [App\Http\Controllers\API\ConsultationController::class, 'store']);
        Route::patch('consultations/{consultation:public_id}', [App\Http\Controllers\API\ConsultationController::class, 'update']);

        // Lodging routes (authenticated)
        Route::prefix('host')->group(function (): void {
            Route::apiResource('lodgings', App\Http\Controllers\API\HostLodgingController::class)->except(['show']);
            Route::get('lodgings/{lodging:public_id}/availability', [App\Http\Controllers\API\HostLodgingAvailabilityController::class, 'index']);
            Route::put('lodgings/{lodging:public_id}/availability', [App\Http\Controllers\API\HostLodgingAvailabilityController::class, 'update']);

            // Host Bookings
            Route::get('bookings', [App\Http\Controllers\API\HostBookingController::class, 'index']);
            Route::post('bookings/{booking:public_id}/approve', [App\Http\Controllers\API\HostBookingController::class, 'approve']);
            Route::post('bookings/{booking:public_id}/reject', [App\Http\Controllers\API\HostBookingController::class, 'reject']);
        });

        // Booking routes
        Route::get('bookings/{booking:public_id}/inquiry', [App\Http\Controllers\API\BookingInquiryController::class, 'show']);
        Route::apiResource('bookings', App\Http\Controllers\API\BookingController::class)->except(['destroy']);

        // Auction routes
        Route::post('auctions', [App\Http\Controllers\AuctionController::class, 'store']);
        Route::post('auctions/{auction:public_id}/bid', [App\Http\Controllers\AuctionController::class, 'placeBid']);
    });
});
