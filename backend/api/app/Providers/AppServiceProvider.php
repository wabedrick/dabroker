<?php

namespace App\Providers;

use App\Contracts\OtpChannel;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use InvalidArgumentException;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(OtpChannel::class, function ($app) {
            $driver = config('otp.driver', 'log');
            $channelConfig = config("otp.channels.{$driver}", []);
            $class = $channelConfig['class'] ?? null;

            if (! $class) {
                throw new InvalidArgumentException("Unsupported OTP driver [{$driver}]");
            }

            return $app->make($class, ['config' => $channelConfig]);
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Dynamically set APP_URL and storage URL based on request in local environment
        // This ensures images work regardless of the IP address used to access the API
        if ($this->app->environment('local') && request()->server->has('HTTP_HOST')) {
            $host = request()->getSchemeAndHttpHost();
            config(['app.url' => $host]);
            config(['filesystems.disks.public.url' => $host . '/storage']);
        }

        if (config('app.force_https')) {
            URL::forceScheme('https');
        }

        $isProduction = $this->app->environment('production');

        Model::preventLazyLoading(! $isProduction);
        Model::preventSilentlyDiscardingAttributes(! $isProduction);
        Model::preventAccessingMissingAttributes(! $isProduction);
        Model::shouldBeStrict(! $isProduction);

        // Register SQLite math functions for distance calculations
        try {
            if (\Illuminate\Support\Facades\DB::connection()->getDriverName() === 'sqlite') {
                $pdo = \Illuminate\Support\Facades\DB::connection()->getPdo();
                $pdo->sqliteCreateFunction('acos', 'acos', 1);
                $pdo->sqliteCreateFunction('cos', 'cos', 1);
                $pdo->sqliteCreateFunction('radians', 'deg2rad', 1);
                $pdo->sqliteCreateFunction('sin', 'sin', 1);
            }
        } catch (\Exception $e) {
            // Ignore if database connection fails
        }
    }
}
