#!/bin/sh
#
# poll_postgres.sh
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

# Check the status of postgres before running Django.
#
# Insipired by
# https://docs.docker.com/compose/startup-order/

set -u

# Get the variables from the docker-compose files.
POSTGRES_USER="${1}"
POSTGRES_PASS="${2}"
POSTGRES_GUEST_PORT="${3}"

available='False'
while [ "${available}" = 'False' ]; do
    export PGPASSWORD="${POSTGRES_PASS}"
    psql --host db --user "${POSTGRES_USER}" --port "${POSTGRES_GUEST_PORT}" --command='\q'
    retval=${?}
    unset PGPASSWORD
    if [ ${retval} -eq 0 ]; then
        available='True'
    else
        printf "%s\n" 'waiting for postgres to finish startup...'
        sleep 1
    fi
done
