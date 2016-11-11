# Template for Docker Development Environments

## Setup
1. `git clone git@github.com:cmmarslender/docker-template.git <my-project-name>`
1. `cd <my-project-name>`
1. `docker-compose up`

The `wordpress` folder is configured as the webroot by default. Download WordPress and anything else you need here.

## Overrides File

I typically add a `docker-compose.override.yml` file alongside the docker-compose.yml file, with contents similar to
the following to change the domain associated with the cluster while retaining ability to pull in changes from the repo.

```
version: '2'
services:
  phpfpm:
    extra_hosts:
      - "dashboard.dev:172.18.0.1"
```

## Credits

This is pretty much based on work from John Bloch. Credit where credit is due. 
