FROM serversideup/php:8.2-fpm-nginx

# Switch to root to install PHP extensions and set permissions
USER root
RUN install-php-extensions pdo_mysql zip bcmath exif

# Configure the web document root
ENV WEB_DOCUMENT_ROOT=/var/www/html/public
ENV PHP_OPCACHE_ENABLE=1

# Copy application files (as root so we can chmod next)
COPY --chown=www-data:www-data . /var/www/html

# Explicitly set the entrypoint script executable INSIDE the image.
# This is required because Git on Windows strips the executable bit,
# which causes DigitalOcean App Platform to throw "run command not executable".
RUN chmod +x /var/www/html/docker-entrypoint.sh

# Switch back to www-data for security
USER www-data

# Install Composer dependencies for production
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Use our entrypoint script which runs migrations and starts the server.
# Optimization (config:cache, route:cache) happens at runtime so that
# DigitalOcean's runtime environment variables are picked up correctly.
CMD ["/var/www/html/docker-entrypoint.sh"]