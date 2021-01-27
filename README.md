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
  - [Dependencies](#dependencies)
    - [Dockerfile](#dockerfile-1)
      - [Version pinning](#version-pinning)
    - [CI commands](#ci-commands)
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
| [postgis/postgis](https://hub.docker.com/r/postgis/postgis/) | postgis/postgis:13-3.1 | https://github.com/postgis/docker-postgis | `0.0.4` `1.0.0` |

## Import in another project

### Build

#### Build the image directly

1. clone this repository
2. run `docker-compose build`
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
            context: https://github.com/frnmst/docker-debian-postgis-django.git#${VERSION}

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

    curl https://raw.githubusercontent.com/frnmst/docker-debian-postgis-django/master/ci.sh --output ci.sh && [ "$(sha512sum ci.sh | awk '{print $1}')" = '762e4436bd3816e62a41a7ce202493d71a4ca25ee557f7799ea43b780567ea57aa9edfdbd13bacd09ba1e86cb1a81d235735481de0179c870994df08e686a771' ] && chmod 700 ./ci.sh && env --ignore-environment ENV="development" PATH=$PATH bash --noprofile --norc -c './ci.sh'
    curl https://raw.githubusercontent.com/frnmst/docker-debian-postgis-django/master/ci.sh --output ci.sh && [ "$(sha512sum ci.sh | awk '{print $1}')" = '762e4436bd3816e62a41a7ce202493d71a4ca25ee557f7799ea43b780567ea57aa9edfdbd13bacd09ba1e86cb1a81d235735481de0179c870994df08e686a771' ] && chmod 700 ./ci.sh && env --ignore-environment ENV="production" PATH=$PATH bash --noprofile --norc -c './ci.sh'

You can use `Jenkins <https://jenkins.io>`_ for these tasks.
In this case place the command under the *Build* -> *Execute shell* section of the project's configuration.

Warning: The `SECRET_SETTINGS.py` file is replaced by `SECRET_SETTINGS.dist.py` file once you run the script.

See also https://stackoverflow.com/a/49669361

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

### CI commands

| Software                                                 | Build type |
|----------------------------------------------------------|------------|
| [cURL](https://curl.se/)                                 | dev, prod  |
| [GNU Coreutils](https://www.gnu.org/software/coreutils/) | dev, prod  |
| [GNU Bash](https://www.gnu.org/software/bash/)           | dev, prod  |

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

Instructions, sources and keys can be found at [frnmst.gitlab.io/software](https://frnmst.gitlab.io/software/).
