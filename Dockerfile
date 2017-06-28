FROM debian:9.0

MAINTAINER Daniel Fernando Lourusso <daniel@dflourusso.com.br>

LABEL Description="A Simple apache-sll/php image using debian 9.0"

RUN apt-get update && apt-get -y install wget curl vim apt-transport-https lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list
RUN apt-get update && apt-get -y install php7.1 php7.1-mysql \
    php7.1-curl php7.1-json php7.1-gd php7.1-mcrypt php7.1-msgpack php7.1-memcached php7.1-intl \
    php7.1-mbstring php7.1-xml php7.1-zip

RUN sed -i "s#short_open_tag = Off#short_open_tag = On#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#short_open_tag = Off#short_open_tag = On#" /etc/php/7.1/apache2/php.ini
RUN printf "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i "s#DirectoryIndex.*#DirectoryIndex\ index.php\ index.html\ index.xhtml\ index.htm#" /etc/apache2/mods-enabled/dir.conf

RUN mkdir -p /etc/apache2/ssl
ADD ssl/* /etc/apache2/ssl/

RUN sed -i "s#DocumentRoot.*#DocumentRoot /var/www/html/public#" /etc/apache2/sites-available/000-default.conf \
    && sed -i "s#</VirtualHost>##" /etc/apache2/sites-available/000-default.conf \
    && printf "\t<Directory /var/www/html/public>\n\t\tOptions Indexes FollowSymLinks\n\t\tAllowOverride All\n\t\tRequire all granted\n\t</Directory>\n</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf \

    && sed -i "s#DocumentRoot.*#DocumentRoot /var/www/html/public#" /etc/apache2/sites-available/default-ssl.conf \
    && sed -i "s#</IfModule>##" /etc/apache2/sites-available/default-ssl.conf \
    && sed -i "s#</VirtualHost>##" /etc/apache2/sites-available/default-ssl.conf \
    && printf "\t\t<Directory /var/www/html/public>\n\t\t\tOptions Indexes FollowSymLinks\n\t\t\tAllowOverride All\n\t\t\tRequire all granted\n\t\t</Directory>\n\t</VirtualHost>\n</IfModule>" >> /etc/apache2/sites-available/default-ssl.conf \

    && sed -i "s#SSLCertificateFile.*#SSLCertificateFile\ /etc/apache2/ssl/apache.crt#g" /etc/apache2/sites-available/default-ssl.conf \
    && sed -i "s#SSLCertificateKeyFile.*#SSLCertificateKeyFile\ /etc/apache2/ssl/apache.key#" /etc/apache2/sites-available/default-ssl.conf \
    && a2enmod ssl headers rewrite && a2ensite default-ssl

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
EXPOSE 443

ADD start.sh /opt/utils/
RUN chmod +x /opt/utils/start.sh

ENTRYPOINT /opt/utils/start.sh
