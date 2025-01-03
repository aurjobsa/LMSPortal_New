# Use the official PHP image with Apache
FROM php:8.1-apache

# Install system packages and PHP extensions
RUN apt-get update && \
    apt-get install -y \
    libpq-dev \
    unzip \
    git \
    && docker-php-ext-install pdo_pgsql

# Enable Apache modules
RUN a2enmod rewrite

# Set the document root to the public directory
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Update the Apache configuration to use the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Set working directory
WORKDIR /var/www/html

# Clone Chamilo LMS repository
RUN git clone https://github.com/chamilo/chamilo-lms.git .

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
