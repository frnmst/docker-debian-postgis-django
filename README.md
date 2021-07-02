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
    - [Other files](#other-files)
      - [Makefile](#makefile)
      - [uwsgi.ini](#uwsgiini)
      - [Variables](#variables)
  - [Dependencies](#dependencies)
    - [Dockerfile](#dockerfile-1)
      - [Version pinning](#version-pinning)
    - [ci.sh](#cish)
    - [ci.sh download script](#cish-download-script)
    - [Makefile.dist download script](#makefiledist-download-script)
  - [License](#license)
  - [Trusted source](#trusted-source)
  - [Crypto donations](#crypto-donations)

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

    curl https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/master/ci.sh --output ci.sh && [ "$(sha512sum ci.sh | awk '{print $1}')" = 'c6eab9296e83a547bbb997e5399e01cac409f7d1debedfe3a21ea31a33390b226e1093baadfaf48f190b1ef3f3fd61e226cca5c9fddc35f8d760774d2fc31108' ] && chmod 700 ./ci.sh && env --ignore-environment ENV="development" PATH=$PATH bash --noprofile --norc -c './ci.sh "https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/dev/Makefile.dist" "debade1b990821c02064c49b0f767b59ac024779435235c21a40478849498c29d96477826a0a2af32b0b9a1f68fb9eec4e92bc780ef06bd3da64928d010e9b92"'

    curl https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/master/ci.sh --output ci.sh && [ "$(sha512sum ci.sh | awk '{print $1}')" = 'c6eab9296e83a547bbb997e5399e01cac409f7d1debedfe3a21ea31a33390b226e1093baadfaf48f190b1ef3f3fd61e226cca5c9fddc35f8d760774d2fc31108' ] && chmod 700 ./ci.sh && env --ignore-environment ENV="production" PATH=$PATH bash --noprofile --norc -c './ci.sh "https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/dev/Makefile.dist" "262eaed350bc6766a1505745e2663bf5a61906aaf8702a3a5812d98e9de148c447e4744ed0ea70ef8e6fbcc04749c9bcc596d669cb3cb6df2bf74235704af7bf"'

You can use `Jenkins <https://jenkins.io>`_ for these tasks.
In this case place the command under the *Build* -> *Execute shell* section of the project's configuration.

Warning: The `SECRET_SETTINGS.py` file is replaced by `SECRET_SETTINGS.dist.py` file once you run the script.

See also https://stackoverflow.com/a/49669361

### Other files

You can import these files in a project to:

- use all setup operations without typing them manually
- run uwsgi

[django-futils](https://software.franco.net.eu.org/frnmst/django-futils) for example uses this method.

Run these manually or create a download script called in your project:

#### Makefile

```
curl https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/master/Makefile.dist --output Makefile \
    && [ "$(sha512sum Makefile | awk '{print $1}')" = 'debade1b990821c02064c49b0f767b59ac024779435235c21a40478849498c29d96477826a0a2af32b0b9a1f68fb9eec4e92bc780ef06bd3da64928d010e9b92' ] && echo "OK" || rm Makefile
```

#### uwsgi.ini

```
curl https://software.franco.net.eu.org/frnmst/docker-debian-postgis-django/raw/branch/master/uwsgi.ini.dist --output uwsgi.ini \
    && [ "$(sha512sum uwsgi.ini | awk '{print $1}')" = '435c1346a0f7c8a622b0825801cea33f243fafd692c0ec3b3f2a2affd57b49ef520484b84784d918095cf4123d087d66cb159efd331b3978290263dcdb5e82d1' ] && echo "OK" || rm uwsgi.ini
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

These dependencies are installed with the `RUN` command so there is no need to install them manually.

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

## Crypto donations

- Bitcoin: bc1qnkflazapw3hjupawj0lm39dh9xt88s7zal5mwu
- Monero: 84KHWDTd9hbPyGwikk33Qp5GW7o7zRwPb8kJ6u93zs4sNMpDSnM5ZTWVnUp2cudRYNT6rNqctnMQ9NbUewbj7MzCBUcrQEY
- Dogecoin: DMB5h2GhHiTNW7EcmDnqkYpKs6Da2wK3zP
- Vertcoin: vtc1qd8n3jvkd2vwrr6cpejkd9wavp4ld6xfu9hkhh0
