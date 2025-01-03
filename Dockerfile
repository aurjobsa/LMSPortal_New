# Use the official PHP image with Apache
FROM php:8.1-apache

# Install system packages and PHP extensions
RUN apt-get update && \
    apt-get install -y \
    libpq-dev \
    unzip \
    git \
    curl \
    libicu-dev \
    && docker-php-ext-install pdo_pgsql intl && \
    apt-get clean

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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

# Set proper permissions for the working directory
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Install PHP dependencies using Composer (with debug mode)
RUN composer install --no-dev --optimize-autoloader --verbose --prefer-dist --no-interaction

# Set proper permissions for the web server
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 80 to access the service
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
