FROM ubuntu:12.04

RUN apt-get update
RUN apt-get install -y apache2
RUN a2enmod rewrite
RUN a2enmod actions

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]