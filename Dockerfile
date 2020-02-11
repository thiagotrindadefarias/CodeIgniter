FROM php:7.2-apache
WORKDIR /var/www/html
COPY . composer.json

RUN apt-get update && apt-get install -y \
	git \
	unzip \
	zip \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	&& docker-php-ext-install -j$(nproc) iconv \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install pdo_mysql \
	# && docker-php-ext-install gmp \
	&& docker-php-ext-install bcmath

#RUN npm audit --force
RUN a2enmod rewrite

# Instalação do GRPC p/ utilizar junto do Composer
RUN pecl install grpc \
	&& docker-php-ext-enable grpc

# Instalação do Composer
RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer

COPY . ./

RUN php -i | grep php.ini
RUN composer update


EXPOSE 80 443
