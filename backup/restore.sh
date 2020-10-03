#!/bin/sh

restore() {
    PGPASSWORD="$POSTGRES_PASSWORD" pg_restore --username=$POSTGRES_USER --host=$POSTGRES_HOST --port=$POSTGRES_PORT --dbname=$POSTGRES_DB --format=c "$1"
}

usage() {
    cat <<EOF
Restore given dump into database "$POSTGRES_DB" located on $POSTGRES_HOST:$POSTGRES_PORT
Usage:
    restore          -- this help
    restore filename -- restore given filename
EOF
    exit 1
}

_main() {
    _restore_filename="$1"
    if [ $# -eq 1 ] && [ -f "$_restore_filename" ]; then
        restore "$_restore_filename"
    elif [ $# -eq 1 ]; then
        echo "Error: File '$_restore_filename' does not exist."
        exit 1
    else
        usage
    fi
}

_main "$@"
