# docker-debian-postgis-django

An image to be used for the first stage of Django projects that use PostGIS and Debian.

## Table of contents

<!--TOC-->

- [docker-debian-postgis-django](#docker-debian-postgis-django)
  - [Table of contents](#table-of-contents)
  - [Description](#description)
  - [Import in another project](#import-in-another-project)
    - [Build the image directly](#build-the-image-directly)
    - [Build via git](#build-via-git)
  - [Dependencies](#dependencies)
  - [License](#license)
  - [Trusted source](#trusted-source)

<!--TOC-->

## Description

This repository contains a dockerfile and a compose file used to install some basic
system dependencies for Django, PostgreSQL and PostGIS.

The image used in other project for PostgreSQL,
along this one, is [kartoza/postgis](https://hub.docker.com/r/kartoza/postgis/)

## Import in another project

### Build the image directly

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

### Build via git

1. add this to the docker compose file of your project:

```
services:

    dependencies:
        image: docker_debian_postgis_django
        build:
            context: https://github.com/frnmst/docker-debian-postgis-django.git
            dockerfile: Dockerfile

    # The main service of you project.
    main:

        ...

        depends_on:
            - dependencies
            - ...
```

## Dependencies

| Dependency name      | Purpose                                | Build type |
| ---------------------|----------------------------------------|------------|
| gettext              | translations                           | dev, prod  |
| graphviz             | database schema                        | dev        |
| libgraphviz-dev      | database schema                        | dev        |
| postgis              | postgres extension                     | dev, prod  |
| postgresql-client    | poll database availability with `psql` | dev, prod  |


## License

Copyright (C) 2020 frnmst (Franco Masotti) <franco.masotti@live.com>

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
