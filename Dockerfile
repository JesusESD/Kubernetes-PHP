FROM php:8.1-apache
RUN apt-get update && docker-php-ext-install mysqli pdo && docker-php-ext-enable mysqli pdo
RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf
COPY . /var/www/html/

