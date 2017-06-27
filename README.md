# Docker Debian with Apache, ssl and php7.1

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


    $ docker run --name debian-php7.1 -v $(pwd):/var/www/html -p 80:80 -p 443:443 --net=bridge -d dflourusso/debian-apache-ssl-php
