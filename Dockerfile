# Use PHP with Apache
FROM php:8.0-apache

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    curl \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli zip

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache mod_rewrite for SEO-friendly URLs and other features
RUN a2enmod rewrite

# Set the working directory for the application inside the container
WORKDIR /var/www/html

# Copy the source code into the container (assuming it's in the same directory as the Dockerfile)
COPY . /var/www/html

# Clear Composer cache before installing dependencies to ensure clean install
RUN composer clear-cache

# Install all dependencies including development dependencies
RUN composer install --optimize-autoloader --prefer-dist --no-interaction -vvv

# Set proper permissions for the web server user (Apache)
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 for web traffic
EXPOSE 80

# Start Apache service in the foreground
CMD ["apache2-foreground"]
