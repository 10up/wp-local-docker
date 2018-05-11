# WordPress Docker Development Environment

This is a fork of the [10up's](https://github.com/10up/wp-local-docker) Docker based local development environment for WordPress.
The purpose of this fork was to add some characteristics similar to the Vagrant development environment that is used at log.

## What's Inside

This project is based on [docker-compose](https://docs.docker.com/compose/). By default, the following containers are started: PHP-FPM, MariaDB, Elasticsearch, nginx, Memcached and phpmyadmin. The `/wordpress` directory is the web root which is mapped to the nginx container.

You can directly edit PHP, nginx, and Elasticsearch configuration files from within the repo as they are mapped to the correct locations in containers.

A [custom phpfpm image](https://github.com/10up/phpfpm-image) is used for this environment that adds a few extra things to the PHP-FPM image.

The `/config/elasticsearch/plugins` folder is mapped to the plugins folder in the Elasticsearch container. You can drop Elasticsearch plugins in this folder to have them installed within the container.

## Requirements

* [Docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

## Setup

1. Add a custom URL to your hosts file.
    1. On Linux / Unix / OSX, the file is found at `/private/etc/hosts`
    2. `127.0.0.1  docker.local`
2. `git clone git@github.com:log-oscon/WP-Docker-Construct.git <my-project-name>`
3. `cd <my-project-name>`
4. `docker-compose up`
5. Edit `setup.sh` to declare single or multisite install
    1. `SINGLE_SITE=0` (single site)
    2. `SINGLE_SITE=1` (multisite site)
6. Edit `setup.sh` if you want to add this docker image to another project
    1. `TITLE="Your Project Name"`
    2. `REPOSITORY="projectgiturl"`
7. Run setup to download WordPress and create a `wp-config.php` file.
	1. On Linux / Unix / OSX, run `sh bin/setup.sh`.

Default MySQL connection information (from within PHP-FPM container):

```
Database: `wordpress`
Username: `wordpress`
Password: `password`
Host: `mysql`
```

Default access to PHPMyAdmin:

```
Host: [YOUR LOCAL DEVELOPMENT HOST]:8181
Username: `wordpress` or `root`
Password: `password`
```

Default Elasticsearch connection information (from within PHP-FPM container):

```Host: http://elasticsearch:9200```

The Elasticsearch container is configured for a maximum heap size of 750MB to prevent out of memory crashes when using the default 2GB memory limit enforced by Docker for Mac and Docker for Windows installations or for Linux installations limited to less than 2GB. If you require additional memory for Elasticsearch override the value in a `docker-compose.override.yml` file as described below.

## Docker Compose Overrides File

Adding a `docker-compose.override.yml` file alongside the `docker-compose.yml` file, with contents similar to
the following, allows you to change the domain associated with the cluster while retaining the ability to pull in changes from the repo.

```
version: '3'
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

## MailCatcher

MailCatcher runs a simple local SMTP server which catches any message sent to it, and displays it in it's built-in web interface. All emails sent by WordPress will be intercepted by MailCatcher. To view emails in the MailCatcher web interface, navigate to `http://localhost:1080` in your web browser of choice.

## Credits

Kudos to [10up](https://github.com/10up/wp-local-docker).

## Roadmap

| Setup/Build                         | Status |  Notes  |
|-------------------------------------|:------:|---------|
| Initial Fork                        |    X   |         |
| Add phpmyadmin image                |    X   |         |
| Add xdebug instructions to vscode   |    X   |         |
| Add Custom URLs support             |    X   |         |
| Add WordPress Multisite install     |    X   |         |
| Run Composer dependencies           |    X   |         |
| Run NPM dependencies                |    X   |         |
| Add Genesis Starter-Theme           |    X   |   [1]   |
| Add editorconfig file               |    X   |         |
| Add eslint configurations           |    X   |         |
| Add phpcslint configuration         |    X   |         |
| Get a SQL content seed with WP-CLI  |        |   [2]   |
| Choose Node version                 |        |         |
| Activate WP plugins after building  |        |         |

[1] There is an issue while trying to run the `npm run build` script.
[2] https://make.wordpress.org/cli/handbook/running-commands-remotely/#aliases

| Deploy                              | Status |  Notes  |
|-------------------------------------|:------:|---------|
| As a container                      |        |         |
| Without Docker Environment          |        |         |
