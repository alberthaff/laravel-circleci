FROM library/php:7.3.11-cli-stretch

ARG DOCKERIZE_VERSION=v0.3.0

# Install required tools
RUN apt update && apt install -y wget libxml2-dev libzip-dev --allow-remove-essential libpng-dev
# Add reqired PHP extensions
RUN docker-php-ext-install pdo pdo_mysql gd
RUN pecl install xdebug mailparse redis zip
# Enable required PHP extensions
RUN docker-php-ext-enable xdebug mailparse redis zip pdo_mysql gd
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Install Dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
# Install required CircleCI packages
RUN apt install git ssh tar gzip ca-certificates -y --allow-remove-essential
