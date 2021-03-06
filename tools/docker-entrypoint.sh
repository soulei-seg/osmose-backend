#!/bin/bash

set -x

# It can take a bit to start the DB inside the container. Wait for it to be ready...
TIMER="5"
until pg_isready --host=$DB_HOST; do
  >&2 echo "PostgrSQL not yet available. Sleeping for $TIMER seconds..."
  sleep $TIMER
done

if  [ -v POSTGRESQL_POSTCREATION ]; then
  psql -h $DB_HOST osmose postgres -c "$POSTGRESQL_POSTCREATION"
fi

# workaround: when mounting docker with tmpfs on data it fails to set a proper mode on already existing paths, even it ending up as tmpfs
#chown -R osmose /data

#sudo -E -u osmose $@
$@
