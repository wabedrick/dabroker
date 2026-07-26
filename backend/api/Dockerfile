FROM serversideup/php:8.2-fpm-nginx

# Switch to root to install PHP extensions
USER root
RUN install-php-extensions pdo_mysql zip bcmath

# Configure the web document root
ENV WEB_DOCUMENT_ROOT=/var/www/html/public
ENV PHP_OPCACHE_ENABLE=1

# Switch back to www-data for security
USER www-data

# Copy application files
COPY --chown=www-data:www-data . /var/www/html

# Install Composer dependencies for production
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Optimize Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache