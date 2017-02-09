# Template for Docker Development Environments

## Setup
1. `git clone git@github.com:cmmarslender/docker-template.git <my-project-name>`
1. `cd <my-project-name>`
1. `docker-compose up`
1. Run `bash setup.sh` to download WordPress and create a `wp-config.php` file.

## Docker Compose Overrides File

I typically add a `docker-compose.override.yml` file alongside the docker-compose.yml file, with contents similar to
the following to change the domain associated with the cluster while retaining ability to pull in changes from the repo.

```
version: '2'
services:
  phpfpm:
    extra_hosts:
      - "dashboard.dev:172.18.0.1"
```

## WP-CLI

I like WP-CLI, so wanted to figure out how to run wp-cli commands without loading bash inside one of the containers. Again,
many thanks to John Bloch on this, I have this alias configured in my `~/.bash_profile`. 

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

This is pretty much based on work from John Bloch. Credit where credit is due. 
