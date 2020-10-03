#!/bin/bash
log_file=/var/lib/postgresql/backup.log
BACKUP_DIR=/var/lib/postgresql/backup

_validate() {
    local validatee="$1"
    local validateeName="$2"
    if [ -z "$validatee" ]; then
        printf "%s not set. Exiting backup script without backup.\n" "$validateeName"
        exit 1
    fi
}

_main() {
    _validate "$POSTGRES_HOST" "POSTGRES_HOST"
    _validate "$POSTGRES_PORT" "POSTGRES_PORT"
    _validate "$POSTGRES_DB" "POSTGRES_DB"
    _validate "$POSTGRES_PASSWORD" "POSTGRES_PASSWORD"
    _validate "$POSTGRES_USER" "POSTGRES_USER"
    _validate "$RETENTION_TIME_IN_SECONDS" "RETENTION_TIME_IN_SECONDS"

    printf "Starting backup: %s\n" "$(date)"
    printf "Backups will be saved into directory '%s'\n" "$BACKUP_DIR"

    # Backup the database
    local filename
    filename=$BACKUP_DIR/db_backup_"$(date +'%s')".sql
    if ! PGPASSWORD="$POSTGRES_PASSWORD" pg_dump --username=$POSTGRES_USER --host=$POSTGRES_HOST --port=$POSTGRES_PORT --dbname=$POSTGRES_DB --no-password --format=c --blobs >$filename; then
        printf "Backup failed.\n"
        exit 1
    else
        # Delete older backups
        local threshold=$(($(date +'%s') - $RETENTION_TIME_IN_SECONDS)) # calculate retention
        printf "Deleting backups older than %s seconds...\n" "$RETENTION_TIME_IN_SECONDS"
        for file in $BACKUP_DIR/*.sql; do
            lastModified=$(date -r "$file" +'%s')
            if [[ "$lastModified" -lt "$threshold" ]]; then
                printf "Deleting...... %s\n" "$file"
                rm "$file"
            fi
        done
    fi

    printf "Backup procedure finished.\n"
}

_main | tee -a "$log_file"
