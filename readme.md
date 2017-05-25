# WordPress Docker Development Environment

This is a Docker based local development environment for WordPress.

## What's Inside

This project is based on [docker-compose](https://docs.docker.com/compose/). By default, the following containers are started: PHP-FPM, MariaDB, Elasticsearch, nginx, and Memcached. The `/wordpress` directory is the web root which is mapped to the nginx container.

You can directly edit PHP, nginx, and Elasticsearch configuration files from within the repo as they are mapped to the correct locations in containers.

A `Dockerfile` is included for PHP-FPM (`/dockerfiles/php-fpm/Dockerfile`). This adds a few extra things to the PHP-FPM image.

The `/config/elasticsearch/plugins` folder is mapped to the plugins folder in the Elasticsearch container. You can drop Elasticsearch plugins in this folder to have them installed within the container.

## Requirements

* [Docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

## Setup a Docker Container

1. `git clone git@github.com:10up/wp-docker.git <my-project-name>`
1. `cd <my-project-name>`
1. `docker-compose up`

## Setup WordPress
You will need to run a setup script to download WordPress and create a `wp-config.php` file. 
1. With Docker running, open a new terminal window and CD into `<my-project-name>`
	1. On Linux / Unix / OSX, run ```bash sh bin/setup.sh```
	2. On Windows, run ```bash ./bin/setup```
1. Navigate to `http://localhost` in a browser to finish WordPress setup.

Default MySQL connection information (from within PHP-FPM container):

```
Database: wordpress
Username: wordpress
Password: password
Host: mysql
```

Default Elasticsearch connection information (from within PHP-FPM container):

```Host: http://elasticsearch:9200```

The Elasticsearch container is configured for a maximum heap size of 750MB to prevent out of memory crashes when using the default 2GB memory limit enforced by Docker for Mac and Docker for Windows installations or for Linux installations limited to less than 2GB. If you require additional memory for Elasticsearch override the value in a `docker-compose.override.yml` file as described below.

## Docker Compose Overrides File

Adding a `docker-compose.override.yml` file alongside the `docker-compose.yml` file, with contents similar to
the following, allows you to change the domain associated with the cluster while retaining the ability to pull in changes from the repo.

```
version: '2'
services:
  phpfpm:
    extra_hosts:
      - "dashboard.dev:172.18.0.1"
  elasticsearch:
    environment:
      ES_JAVA_OPTS: "-Xms2g -Xmx2g"
```

## WP-CLI

Add this alias to `~/.bash_profile` to easily run WP-CLI command.

```
alias dcwp='docker-compose exec --user www-data phpfpm wp'
```

Instead of running a command like `wp plugin install` you instead run `dcwp plugin install` from anywhere inside the
`<my-project-name>` directory, and it runs the command inside of the php container.

There is also a script in the `/bin` directory that will allow you to execute WP CLI from the project directory directly: `./bin/wp plugin install`.

## SSH Access

You can easily access the WordPress/PHP container with `docker-compose exec`. Here's a simple alias to add to your `~/.bash_profile`:

```
alias dcbash='docker-compose exec --user root phpfpm bash'
```

This alias lets you run `dcbash` to SSH into the PHP/WordPress container.

Alternatively, there is a script in the `/bin` directory that allows you to SSH in to the environment from the project directory directly: `./bin/ssh`.

## Credits

This project is our own flavor of an environment created by John Bloch.
