# Docker Ubuntu Apache with ssl and PHP


    $ docker run --name ubuntu -v $(pwd):/var/www/html -p 80:80 -p 443:443 --link mysql:mysql -d dflourusso/ubuntu-apache-ssl-php
