#
# Dockerfile
#
# Copyright (C) 2020 frnmst (Franco Masotti) <franco.masotti@live.com>
#
# This file is part of django-futils.
#
# django-futils is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# django-futils is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with django-futils.  If not, see <http://www.gnu.org/licenses/>.
#

FROM python:3.8.5-buster AS base

# Unbuffered output.
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
COPY ./poll_postgres.sh /code/

RUN apt-get update \
    && apt-get install -y --no-install-recommends graphviz libgraphviz-dev postgis gettext postgresql-client \
    && rm -rf /var/cache/apt /var/lib/apt/lists/*

