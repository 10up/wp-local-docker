# WordPress Docker Development Environment

This is a Docker based local development environment for WordPress.

## What's Inside

This project is based on [docker-compose](https://docs.docker.com/compose/). By default, the following containers are started: PHP-FPM, MariaDB, Elasticsearch, nginx, and Memcached. The `/wordpress` directory is the web root which is mapped to the nginx container.

You can directly edit PHP, nginx, and Elasticsearch configuration files from within the repo as they are mapped to the correct locations in containers.

A [custom phpfpm image](https://github.com/10up/phpfpm-image) is used for this environment that adds a few extra things to the PHP-FPM image.

The `/config/elasticsearch/plugins` folder is mapped to the plugins folder in the Elasticsearch container. You can drop Elasticsearch plugins in this folder to have them installed within the container.

## Requirements

* [Docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

## Setup

1. `git clone https://github.com/10up/wp-local-docker.git <my-project-name>`
1. `cd <my-project-name>`
1. `docker-compose up`
1. Run setup to download WordPress and create a `wp-config.php` file.
	1. On Linux / Unix / OSX, run `sh bin/setup.sh`.
	2. On Windows, run `./bin/setup`.
1. Navigate to `http://localhost` in a browser to finish WordPress setup.
	1. If you want to use a domain other than `http://localhost`, you'll need to add an entry to your hosts file. Ex: `127.0.0.1 docker.dev`

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

MailCatcher runs a simple local SMTP server which catches any message sent to it, and displays it in its built-in web interface. All emails sent by WordPress will be intercepted by MailCatcher. To view emails in the MailCatcher web interface, navigate to `http://localhost:1080` in your web browser of choice.

## WP Snapshots

[WP Snapshots](https://github.com/10up/wpsnapshots) is a project sharing tool for WordPress empowering developers to easily push snapshots of projects into the cloud for sharing with team members. Team members can pull snapshots such that everyhing "just works".  WP Local Docker comes bundled with WP Snapshots and comes with a bin script to proxy commands from the host to the docker containers.  To use WP Snapshots with WP Local Docker, follow the [configuration instructions](https://github.com/10up/wpsnapshots#configure), substituting `./bin/wpsnapshots.sh` for `wpsnapshots` in the CLI.

Example:

```sh
./bin/wpsnapshots configure 10up
```

Once configured, you can use all of the WP Snapshots commands, again substituting `./bin/wpsnapshots.sh` for `wpsnapshots` in the CLI.

Examples:

```sh
./bin/wpsnapshots.sh push
./bin/wpsnapshots.sh pull <snapshot-id>
./bin/wpsnapshots.sh search <search-text>
```

## Credits

This project is our own flavor of an environment created by John Bloch.
