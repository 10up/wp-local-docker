# Enabling VSCode and Xdebug inside Docker

PHP-FPM will be running inside a container, therefore your localhost IP will not work.

## Configuring Docker and Xdebug
After getting your docker running, run `ifconfig en1` (MacOS/Linux) or `ipconfig en1` (Windows) and retrieve your machine's IP.
Write it down on the `docker-php-ext-xdebug.ini` file (in the correct placeholder).

## launch.json
"pathMappings": {
    "/var/www/html": "/Users/{YOUR_USERNAME}/{THE_GIT_FOLDER}/wordpress",
}

