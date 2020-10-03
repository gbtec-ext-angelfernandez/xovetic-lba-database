#!/bin/sh

currentDateTime=$(date +%Y-%m-%d-%H-%M)
filename="/var/lib/postgresql/backup/postgres_$BICCLOUD_INSTANCE_NAME-$currentDateTime.dump"

dump_all() {
    PGPASSWORD="$POSTGRES_PASSWORD" pg_dump --username=$POSTGRES_USER --host=$POSTGRES_HOST --port=$POSTGRES_PORT --dbname=$POSTGRES_DB --no-password --format=c --blobs >$filename
}

dump_schemas() {
    local schemas=""
    for i in "$@"; do
        schemas="$schemas --schema=$i"
    done
    PGPASSWORD="$POSTGRES_PASSWORD" pg_dump --username=$POSTGRES_USER --host=$POSTGRES_HOST --port=$POSTGRES_PORT --dbname=$POSTGRES_DB --no-password --format=c --blobs $schemas >$filename
}

usage() {
    cat <<EOF
Dumps database "$POSTGRES_DB" located on $POSTGRES_HOST:$POSTGRES_PORT
Usage:
    dump             -- this help
    dump --help      -- this help
    dump -a          -- dumps complete database. Always use this option for RDS.
    dump schema1 ... -- dumps only given schemas. WARNING: Use it only for docker-postgres.
                        Schema selection does not work on RDS, because Lobs will be ignored.
EOF
    exit 1
}

_main() {
    if [ $# -eq "0" ] || [ "$1" = "--help" ]; then
        usage
    elif [ "$1" = "-a" ]; then
        echo "Dumping complete database to $filename..."
        dump_all
    elif [ $# -gt "0" ]; then
        echo "Dumping schemas $* to $filename..."
        dump_schemas "$@"
    fi
}

_main "$@"
