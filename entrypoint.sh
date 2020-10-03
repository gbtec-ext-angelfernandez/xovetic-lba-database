#!/bin/sh
# exit immediately if a command fails
set -e

if [ "$1" = "backup-only" ]; then
    echo "Installing cronjobs as postgres..."
    /bin/bash -c /startup/install-crontab.sh
    echo "Starting cron as root..."
    cron -f
else
    echo "Installing cronjobs as postgres..."
    /bin/bash -c /startup/install-crontab.sh
    echo "Starting cron as root..."
    cron
    echo "Starting postgres as postgres..."
    /docker-entrypoint.sh postgres -c max_connections=$POSTGRES_MAX_CONNECTIONS -c shared_buffers=$POSTGRES_SHARED_BUFFERS
fi
