# docker-debian-postgis-django

An image to be used for the first stage of Django projects that use PostGIS and Debian.

## Table of contents

<!--TOC-->

- [docker-debian-postgis-django](#docker-debian-postgis-django)
  - [Table of contents](#table-of-contents)
  - [Description](#description)
    - [Database](#database)
  - [Import in another project](#import-in-another-project)
    - [Build](#build)
      - [Build the image directly](#build-the-image-directly)
      - [Build via git](#build-via-git)
    - [Dockerfile](#dockerfile)
    - [Continuous integration](#continuous-integration)
    - [The Makefile](#the-makefile)
      - [Variables](#variables)
  - [Dependencies](#dependencies)
    - [Dockerfile](#dockerfile-1)
      - [Version pinning](#version-pinning)
    - [ci.sh](#cish)
    - [ci.sh download script](#cish-download-script)
    - [Makefile.dist download script](#makefiledist-download-script)
  - [License](#license)
  - [Trusted source](#trusted-source)

<!--TOC-->

## Description

This repository contains a dockerfile and a compose file used to install some basic
system dependencies for Django, PostgreSQL and PostGIS.

### Database

You have various options here. The only requirement is that you use PostgreSQL with
the PostGIS extension enabled.

These are the tested images:

| Image name | Full image name | Repository | docker-debian-postgis-django versions |
|------------|-----------------|------------|---------------------------------------|
| [kartoza/postgis](https://hub.docker.com/r/kartoza/postgis/) | kartoza/postgis:12.1 | https://github.com/kartoza/docker-postgis | `0.0.1`, `0.0.2` |
| [postgis/postgis](https://hub.docker.com/r/postgis/postgis/) | postgis/postgis:12-3.0-alpine | https://github.com/postgis/docker-postgis | `0.0.1`, `0.0.2` |
| [postgis/postgis](https://hub.docker.com/r/postgis/postgis/) | postgis/postgis:13-3.1 | https://github.com/postgis/docker-postgis | >= `0.0.4` |

## Import in another project

### Build

#### Build the image directly

1. clone this repository
2. run `docker-compose build  --build-arg GID=$(id -g) --build-arg UID=$(id -u)`
3. add this to the docker compose file of your project:

```
services:
    dependencies:
        image: docker_debian_postgis_django

    # The main service of you project.
    main:

        ...

        depends_on:
            - dependencies
            - ...
```

#### Build via git

1. add this to the docker compose file of your project, where `${VERSION}` may correspond to
   a git tag such as `0.0.3`:

```
services:

    dependencies:
        image: docker_debian_postgis_django
        build:
            context: https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django.git#${VERSION}

    # The main service of you project.
    main:

        ...

        depends_on:
            - dependencies
            - ...
```

Note: adding the usual `dockerfile: Dockerfile` key under `build` leads to this error:

    unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /tmp/docker-build-git352150547/https:: no such file or directory
    ERROR: Service 'dependencies' failed to build

### Dockerfile

Add this line as the first instruction in the Dockerfile:

    FROM docker_debian_postgis_django as builder

Add this as the the last `COPY` instruction in the Dockerfile:

    COPY --from=docker_debian_postgis_django /code/utils /code/utils

### Continuous integration

The `./ci.sh` script is intendend to get reproducible build for development and production environments.

Select one of the two environments:

    curl https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/master/ci.sh --output ci.sh && [ "$(sha512sum ci.sh | awk '{print $1}')" = '7cda2f9c3962661a0856e4c86976e3aee57b5b4124070e135df7fb93f616f2ffaa4747dde0918424e505d8bb66064ac7352a005cdfab3c7439bf73da43c2dfbb' ] && chmod 700 ./ci.sh && env --ignore-environment ENV="development" PATH=$PATH bash --noprofile --norc -c './ci.sh "https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/dev/Makefile.dist" "262eaed350bc6766a1505745e2663bf5a61906aaf8702a3a5812d98e9de148c447e4744ed0ea70ef8e6fbcc04749c9bcc596d669cb3cb6df2bf74235704af7bf"'
    curl https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/master/ci.sh --output ci.sh && [ "$(sha512sum ci.sh | awk '{print $1}')" = '7cda2f9c3962661a0856e4c86976e3aee57b5b4124070e135df7fb93f616f2ffaa4747dde0918424e505d8bb66064ac7352a005cdfab3c7439bf73da43c2dfbb' ] && chmod 700 ./ci.sh && env --ignore-environment ENV="production" PATH=$PATH bash --noprofile --norc -c './ci.sh "https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/dev/Makefile.dist" "262eaed350bc6766a1505745e2663bf5a61906aaf8702a3a5812d98e9de148c447e4744ed0ea70ef8e6fbcc04749c9bcc596d669cb3cb6df2bf74235704af7bf"'

You can use `Jenkins <https://jenkins.io>`_ for these tasks.
In this case place the command under the *Build* -> *Execute shell* section of the project's configuration.

Warning: The `SECRET_SETTINGS.py` file is replaced by `SECRET_SETTINGS.dist.py` file once you run the script.

See also https://stackoverflow.com/a/49669361

### The Makefile

You can import `Makefile.dist` in a project to use all setup operations without typing them manually.
[django-futils](https://software.franco.net.eu.org/frnmst/django-futils) for example uses this method.

Run this manually or create a download script called in your project:

```
curl https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/master/Makefile.dist --output Makefile \
    && [ "$(sha512sum Makefile | awk '{print $1}')" = 'af67596cac88c704aea66baeaff1deb833293772d191d0f2ec69b0662dcf0495787d63c5a9eed550850dcee89aa08be27d19da233648ade2b8d9acabdf4f9128' ] && echo "OK" || rm Makefile
```

#### Variables

To be able to call `make` you must create a `.env` file in the project root with these variables (example from [django-futils](https://software.franco.net.eu.org/frnmst/django-futils))

    PACKAGE_NAME=django_futils
    APP_NAME=django_futils
    MODELS=default_models.py
    SERVE_DEV_PORT=3050
    AUTH_MODULE=django.contrib.auth

## Dependencies

### Dockerfile

| Software                                         | Dependency name      | Purpose                                | Build type |
|--------------------------------------------------|----------------------|----------------------------------------|------------|
| [gettext](https://www.gnu.org/software/gettext/) | gettext              | translations                           | dev, prod  |
| [Graphviz](https://www.graphviz.org/)            | graphviz             | database schema                        | dev        |
| [Graphviz](https://www.graphviz.org/)            | libgraphviz-dev      | database schema                        | dev        |
| [Postgis](https://postgis.net/)                  | postgis              | postgres extension                     | dev, prod  |
| [PostgreSQL](https://www.postgresql.org/)        | postgresql-client    | poll database availability with `psql` | dev, prod  |

#### Version pinning

Version pinning should improve reproducibility. Since version `0.0.3` the Dockerfile in this project
uses pinned Debian packages.

If you have a Debian installation you can run `# apt-get update && apt policy ${package_name}` to find
out the current software versions of the dependencies.

### ci.sh

| Software                                                 | Build type |
|----------------------------------------------------------|------------|
| [cURL](https://curl.se/)                                 | dev, prod  |
| [docker-compose](https://docs.docker.com/compose/)       | dev, prod  |
| [GNU awk](https://www.gnu.org/software/gawk/)            | dev, prod  |
| [GNU Bash](https://www.gnu.org/software/bash/)           | dev, prod  |
| [GNU Coreutils](https://www.gnu.org/software/coreutils/) | dev, prod  |
| [GNU Make](https://www.gnu.org/software/make/)           | dev, prod  |
| [Python 3](https://www.python.org/)                      | dev, prod  |

### ci.sh download script

| Software                                                 |
|----------------------------------------------------------|
| [cURL](https://curl.se/)                                 |
| [GNU awk](https://www.gnu.org/software/gawk/)            |
| [GNU Coreutils](https://www.gnu.org/software/coreutils/) |
| [GNU Bash](https://www.gnu.org/software/bash/)           |

### Makefile.dist download script

| Software                                                 |
|----------------------------------------------------------|
| [cURL](https://curl.se/)                                 |
| [GNU Bash](https://www.gnu.org/software/bash/)           |
| [GNU Coreutils](https://www.gnu.org/software/coreutils/) |

## License

Copyright (C) 2020-2021 frnmst (Franco Masotti) <franco.masotti@live.com>

docker-debian-postgis-django is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

docker-debian-postgis-django is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with docker-debian-postgis-django.  If not, see <http://www.gnu.org/licenses/>.

## Trusted source

You can check the authenticity of new releases using my public key.

Instructions, sources and keys can be found at [blog.franco.net.eu.org/software](https://blog.franco.net.eu.org/software/).
