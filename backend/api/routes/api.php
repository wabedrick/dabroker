<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\BuyerDashboardController;
use App\Http\Controllers\API\FavoriteNotificationController;
use App\Http\Controllers\API\FavoritePropertyController;
use App\Http\Controllers\API\InterestedBuyerController;
use App\Http\Controllers\API\OwnerDashboardController;
use App\Http\Controllers\API\NotificationCounterController;
use App\Http\Controllers\API\NotificationPreferenceController;
use App\Http\Controllers\API\AiPropertySearchController;
use App\Http\Controllers\API\OwnerPropertyController;
use App\Http\Controllers\API\OwnerPropertyMediaController;
use App\Http\Controllers\API\OwnerPropertyRoomController;
use App\Http\Controllers\API\OwnerPropertyInquiryController;
use App\Http\Controllers\API\PropertyApprovalController;
use App\Http\Controllers\API\PropertyBrowseController;
use App\Http\Controllers\API\PropertyInquiryMessageController;
use App\Http\Controllers\API\PropertyInquiryController;
use App\Http\Controllers\API\LodgingBrowseController;
use App\Models\Property;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

Route::get('/debug-env', function () {
    $allKeys = array_keys($_SERVER);
    $awsKeys = array_filter($allKeys, fn($key) => str_contains(strtoupper($key), 'AWS') || str_contains(strtoupper($key), 'R2') || str_contains(strtoupper($key), 'SECRET') || str_contains(strtoupper($key), 'KEY'));
    
    $result = [];
    foreach ($awsKeys as $key) {
        $result[$key] = empty($_SERVER[$key]) ? 'EMPTY' : 'SET (hidden)';
    }

    return response()->json([
        'AWS_ENDPOINT' => env('AWS_ENDPOINT'),
        'AWS_URL' => env('AWS_URL'),
        'AWS_DEFAULT_REGION' => env('AWS_DEFAULT_REGION'),
        'AWS_BUCKET' => env('AWS_BUCKET'),
        'detected_keys' => $result,
    ]);
});

Route::get('/debug-upload', function () {
    try {
        $disk = Storage::disk('s3');
        $filename = 'test-' . Str::uuid() . '.txt';
        $disk->put($filename, 'Hello world');
        $url = $disk->url($filename);
        return response()->json([
            'status' => 'success',
            'filename' => $filename,
            'url' => $url,
            'exists' => $disk->exists($filename),
        ]);
    } catch (\Throwable $e) {
        return response()->json([
            'status' => 'error',
            'message' => $e->getMessage(),
            'previous' => $e->getPrevious() ? $e->getPrevious()->getMessage() : null,
            'trace' => $e->getTraceAsString(),
        ], 500);
    }
});
use Illuminate\Support\Facades\Artisan;
use App\Models\User;

Route::prefix('v1')->group(function (): void {
    Route::get('properties', [PropertyBrowseController::class, 'index']);
    Route::post('properties/ai-search', AiPropertySearchController::class)->middleware('throttle:10,1');
    Route::get('properties/{property:public_id}', [PropertyBrowseController::class, 'show']);

    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/resend-otp', [AuthController::class, 'resendOtp']);
    Route::post('auth/verify-otp', [AuthController::class, 'verifyOtp']);
    Route::post('auth/login', [AuthController::class, 'login']);
    Route::post('auth/password/forgot', [AuthController::class, 'forgotPassword']);
    Route::post('auth/password/reset', [AuthController::class, 'resetPassword']);

    // Public lodging routes
    Route::get('lodgings', [LodgingBrowseController::class, 'index']);
    Route::get('lodgings/{lodging:public_id}', [LodgingBrowseController::class, 'show']);
    Route::get('lodgings/{lodging:public_id}/availability', [App\Http\Controllers\API\LodgingAvailabilityController::class, 'index']);

    
    Route::get('/fix-images', function () {
        // Delete old demo properties so the seeder will regenerate them.
        // The DemoPropertySeeder avoids seeding if properties already exist for the Demo Host.
        $demoHost = User::where('email', 'demo.host@example.com')->first();
        if ($demoHost) {
            Property::where('owner_id', $demoHost->id)->forceDelete();
        }
        
        Artisan::call('db:seed', ['--class' => 'DemoPropertySeeder']);
        return response()->json(['message' => 'Properties re-seeded to S3 successfully!']);
    });



    Route::get('ratings', [App\Http\Controllers\API\RatingController::class, 'index']);

    // Public auction routes
    Route::get('auctions', [App\Http\Controllers\AuctionController::class, 'index']);
    Route::get('auctions/{auction:public_id}', [App\Http\Controllers\AuctionController::class, 'show']);

    Route::middleware('auth:sanctum')->group(function (): void {

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


        Route::get('inquiries', [PropertyInquiryController::class, 'index']);
        Route::get('inquiries/{inquiry:public_id}', [PropertyInquiryController::class, 'show']);
        Route::post('inquiries/{inquiry:public_id}/messages', [PropertyInquiryMessageController::class, 'store']);
        Route::post('inquiries/{inquiry:public_id}/read', [PropertyInquiryMessageController::class, 'markRead']);



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

            Route::get('properties/{property:public_id}/rooms', [OwnerPropertyRoomController::class, 'index']);
            Route::post('properties/{property:public_id}/rooms', [OwnerPropertyRoomController::class, 'store']);
            Route::match(['put', 'patch'], 'properties/{property:public_id}/rooms/{room:public_id}', [OwnerPropertyRoomController::class, 'update']);
            Route::delete('properties/{property:public_id}/rooms/{room:public_id}', [OwnerPropertyRoomController::class, 'destroy']);

            Route::post('properties/{property:public_id}/rooms/{room:public_id}/media', [\App\Http\Controllers\API\OwnerPropertyRoomMediaController::class, 'store']);
            Route::delete('properties/{property:public_id}/rooms/{room:public_id}/media/{media:uuid}', [\App\Http\Controllers\API\OwnerPropertyRoomMediaController::class, 'destroy']);

            Route::get('inquiries', [OwnerPropertyInquiryController::class, 'index']);
            Route::get('inquiries/{inquiry:public_id}', [OwnerPropertyInquiryController::class, 'show']);
            Route::post('inquiries/{inquiry:public_id}/read', [PropertyInquiryMessageController::class, 'markRead']);

            Route::get('interested-buyers', [InterestedBuyerController::class, 'index']);
            Route::post('interested-buyers/{favorite:public_id}/read', [InterestedBuyerController::class, 'markRead']);
        });

        Route::prefix('buyer')->group(function (): void {
            Route::get('dashboard', BuyerDashboardController::class);
        });

        Route::prefix('admin')
            ->middleware('can:properties.approve')
            ->name('admin.')
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



        // Lodging routes (authenticated)
        Route::prefix('host')->group(function (): void {
            Route::apiResource('lodgings', App\Http\Controllers\API\HostLodgingController::class)->except(['show']);
            Route::apiResource('lodgings.rooms', App\Http\Controllers\API\HostLodgingRoomController::class)
                ->scoped(['lodging' => 'public_id', 'room' => 'public_id'])
                ->except(['show', 'edit', 'create']);
            
            Route::post('lodgings/{lodging:public_id}/rooms/{room:public_id}/media', [App\Http\Controllers\API\HostLodgingRoomMediaController::class, 'store']);
            Route::delete('lodgings/{lodging:public_id}/rooms/{room:public_id}/media/{media}', [App\Http\Controllers\API\HostLodgingRoomMediaController::class, 'destroy']);

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
