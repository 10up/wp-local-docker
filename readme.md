# WordPress Docker Development Environment

This is a Docker based local development environment for WordPress.

## What's Inside

This project is based on [docker-compose](https://docs.docker.com/compose/). By default, the following containers are started: PHP-FPM, MariaDB, Elasticsearch, nginx, and Memcached. Additionally, to support using [WP Gears](https://github.com/10up/wp-gears), two additional containers are started - a gearman queue and a worker. The `/wordpress` directory is the web root which is mapped to the nginx, php, and worker containers.

You can directly edit PHP, nginx, and Elasticsearch configuration files from within the repo as they are mapped to the correct locations in containers.

A `Dockerfile` is included for PHP-FPM (`/dockerfiles/php-fpm/Dockerfile`). This adds a few extra things to the PHP-FPM image.

The `/config/elasticsearch/plugins` folder is mapped to the plugins folder in the Elasticsearch container. You can drop Elasticsearch plugins in this folder to have them installed within the container.

## Requirements

* [Docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

## Setup

1. `git clone git@github.com:cmmarslender/docker-template.git <my-project-name>`
1. `cd <my-project-name>`
1. `docker-compose up`
1. Run `bash setup.sh` to download WordPress and create a `wp-config.php` file.
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

### WP Gears Setup

It's easy to set up WP Gears using this docker configuration - just run the following commands from the `wordpress` folder.

1. Clone the WP Gears plugin to the plugins directory - `git clone https://github.com/10up/WP-Gears.git wp-content/plugins/wp-gears`
2. Symlink the worker file to the web root - `ln -s wp-content/plugins/wp-gears/wp-gears-runner.php .`
3. Add the following to `config/wp-gears-worker/conf.d/wp-gears.ini`

    ```
    [program:wp-gears]
    command=/usr/local/bin/php /var/www/html/wp-gears-runner.php
    process_name=%(program_name)s-%(process_num)02d
    numprocs=2
    directory=/var/www/html
    autostart=true
    autorestart=true
    killasgroup=true
    user=www-data
    startsecs=0
    ```
    
4. Add the following to your `wp-config.php` file

    ```
    global $gearman_servers;
    $gearman_servers = array(
      'gearman:4730',
    );
    define( 'WP_ASYNC_TASK_SALT', 'wp-docker-1' );
    ```

## Docker Compose Overrides File

Adding a `docker-compose.override.yml` file alongside the `docker-compose.yml` file, with contents similar to
the following, allows you to change the domain associated with the cluster while retaining the ability to pull in changes from the repo.

```
version: '2'
services:
  phpfpm:
    extra_hosts:
      - "dashboard.dev:172.18.0.1"
```

## WP-CLI

Add this alias to `~/.bash_profile` to easily run WP-CLI command. 

```
alias dcwp='docker-compose exec --user www-data phpfpm wp'
```

Instead of running a command like `wp plugin install` you instead run `dcwp plugin install` from anywhere inside the 
`<my-project-name>` directory, and it runs the command inside of the php container.

## SSH Access

You can easily access the WordPress/PHP container with `docker-compose exec`. Here's a simple alias to add to your `~/.bash_profile`:

```
alias dcbash='docker-compose exec --user root phpfpm bash'
```

This alias lets you run `dcbash` to SSH into the PHP/WordPress container.

## Credits

This project is our own flavor of an environment created by John Bloch.
