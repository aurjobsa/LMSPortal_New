# Use the official PHP image with Apache web server
FROM php:8.0-apache

# Install required PHP extensions for Chamilo
RUN apt-get update && apt-get install -y \
    libpq-dev \
    curl \
    git \
    && docker-php-ext-install mysqli pdo pdo_mysql

# Install Composer (dependency manager for PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache mod_rewrite for Chamilo URL rewriting
RUN a2enmod rewrite

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the Chamilo source code from your local machine to the container
COPY . /var/www/html

# Install PHP dependencies using Composer (this will generate the 'vendor' directory)
RUN composer install --no-dev --optimize-autoloader

# Set permissions for the Chamilo directory (allow web server to read/write)
RUN chown -R www-data:www-data /var/www/html

# Update Apache DocumentRoot to point to the /public folder
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Expose port 80 for the web server
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
