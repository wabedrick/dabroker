FROM serversideup/php:8.2-fpm-nginx

# Switch to root to install PHP extensions and set permissions
USER root
RUN install-php-extensions pdo_mysql zip bcmath exif

# Configure the web document root
ENV WEB_DOCUMENT_ROOT=/var/www/html/public
ENV PHP_OPCACHE_ENABLE=1

# Copy application files (as root so we can chmod next)
COPY --chown=www-data:www-data . /var/www/html

# Set serversideup autorun vars for migrations
ENV AUTORUN_ENABLED=true
ENV AUTORUN_LARAVEL_MIGRATION=true
ENV AUTORUN_LARAVEL_MIGRATION_FORCE=true

# Switch back to www-data for security
USER www-data

# Install Composer dependencies for production
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Create the storage symlink at build time
RUN php artisan storage:link

# We DO NOT override CMD or ENTRYPOINT.
# serversideup/php uses s6-overlay internally. Overriding CMD breaks it.