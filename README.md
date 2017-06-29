# Docker Debian with php7.1, Apache and ssl

> Apache will search an *index.php* in *./public*

Folder structure example:

    .
    ├── ...
    ├── src
    │   ├── App.php
    │   └── ...
    ├── public
    │   └── index.php
    └── ...


Docker Run Command

    $ docker run --name debian-php7.1 -v $(pwd):/var/www/html -p 80:80 -p 443:443 --net=bridge -d dflourusso/debian-apache-ssl-php

Custom Document Root

    $ docker run --name debian-php7.1 -e "DOCUMENT_ROOT=/var/www/html/public2" -v $(pwd):/var/www/html -p 80:80 -p 443:443 --net=bridge -d dflourusso/debian-apache-ssl-php
