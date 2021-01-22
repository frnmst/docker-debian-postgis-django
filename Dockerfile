#
# Dockerfile
#
# Copyright (C) 2020 frnmst (Franco Masotti) <franco.masotti@live.com>
#
# This file is part of docker-debian-postgis-django.
#
# docker-debian-postgis-django is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# docker-debian-postgis-django is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with docker-debian-postgis-django.  If not, see <http://www.gnu.org/licenses/>.
#

FROM python:3.9.0-buster AS base

# Unbuffered output.
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
COPY ./poll_postgres.sh /code/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        graphviz=2.40.1-6 \
        libgraphviz-dev=2.40.1-6 \
        gettext=0.19.8.1-9 \
        postgresql-client=11+200+deb10u4 \
        postgis=2.5.1+dfsg-1 \
    && rm -rf /var/cache/apt /var/lib/apt/lists/*
