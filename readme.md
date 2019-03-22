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
* [Git Bash](https://git-scm.com/download/win) (**win10 users**)

## Setup

2. Clone the project
	
	`$ git clone git@github.com:log-oscon/WP-Docker-Construct.git <my-project-name>`
3. change to project directory 
	
	`$ cd <my-project-name>`
4. **Windows only**: setup proper compose file:

	`cp  docker-compose-win.yml docker-compose.yml`
4. ** run docker-compose: 
	
	`$ docker-compose up`
	(**windows only**: It's going to ask to create a volume, just do it.)
5. Open a new bash, and Run WP-Docker-Construct setup script:
	
	`$ sh bin/setup.sh`.
6. The script will ask you some questions and guide you through the installation process:
	1. *Write your domain | default: localhost |:* demo.localhost
	2. *Write your admin email:* demo@localhost
	3. *Write your project repository URL (empty for a clean install):* git@github.com:demo/demo.git
	4. *Install Wordpress core? (y/n)? default y:* y
	5. *is Multisite (y/n)?* n
	6. *Update Wordpress? (y/n)? default y:* y
	7. *Write URL: demo.local on hosts (y/n)? default n:* y <sup>**(1)**</sup>
	8. *All done!*

**Notes:**

<sup>(1)</sup> Windows: this step will not work properly. You'll have to add the line to hosts file manually. With administrator previleges, just edit *c:\Windows\System32\Drivers\etc\hosts* and add a line like: 	`$ demo.localhost 127.0.0.1`.

**Default MySQL connection information (from within PHP-FPM container):**

```
Database: `wordpress`
Username: `wordpress`
Password: `password`
Host: `mysql`
```

**Default access to PHPMyAdmin:**

```
Host: [YOUR LOCAL DEVELOPMENT HOST]:8181
Username: `wordpress` or `root`
Password: `password`
```

**Default Elasticsearch connection information (from within PHP-FPM container):**

```Host: http://elasticsearch:9200```

The Elasticsearch container is configured for a maximum heap size of 750MB to prevent out of memory crashes when using the default 2GB memory limit enforced by Docker for Mac and Docker for Windows installations or for Linux installations limited to less than 2GB. If you require additional memory for Elasticsearch override the value in a `docker-compose.override.yml` file as described below.

## docker-sync setup (optional)

[docker-sync](http://docker-sync.io/) allows you to "run your application at full speed while syncing your code for development".
To run docker-sync do as following: 

1. Install docker-sync: `gem install docker-sync`
2. Configure docker-sync: 
	4. Included `docker-sync.yml` has a default sync that matches a volume in `docker-compose-dev.yml`
	3. Included `docker-compose-dev.yml` should be identical to `docker-compose.yml` plus the sync information parameters 
4. Run docker-sync (it might take a while in the first run) ` docker stop $(docker ps -a -q) && docker-sync-stack start`


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
| Add docker-sync                     |    X   |         |

[1] There is an issue while trying to run the `npm run build` script.
[2] https://make.wordpress.org/cli/handbook/running-commands-remotely/#aliases

| Deploy                              | Status |  Notes  |
|-------------------------------------|:------:|---------|
| As a container                      |        |         |
| Without Docker Environment          |        |         |
