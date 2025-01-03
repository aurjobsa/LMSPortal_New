# Step 1: Use the official PHP image with Apache web server
FROM php:8.0-apache

# Step 2: Install required PHP extensions for Chamilo
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql

# Step 3: Enable Apache mod_rewrite for Chamilo URL rewriting
RUN a2enmod rewrite

# Step 4: Set the working directory inside the container
WORKDIR /var/www/html

# Step 5: Copy the Chamilo source code from your local machine to the container
COPY . /var/www/html

# Step 6: Set up permissions for the web server to work correctly
RUN chown -R www-data:www-data /var/www/html

# Step 7: Expose the web server on port 80
EXPOSE 80

# Step 8: Set the default command to run Apache in the foreground
CMD ["apache2-foreground"]
