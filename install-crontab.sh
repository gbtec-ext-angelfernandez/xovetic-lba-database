#!/bin/bash
# exit immediately if a command fails
set -e

backup_job="/var/lib/postgresql/backup.sh"

write_crontab_line() {
    local separator="   "
    local arg_line="$*"
    if [ -n "$arg_line" ]; then
        # We just read the first 5 arguments (i.e. time and date fields) of the given crontab line and ignore the command, if provided.
        IFS=' ' read -r -a crontab_fields <<<"$arg_line"
        local crontab_line="${crontab_fields[0]}$separator"
        crontab_line="$crontab_line${crontab_fields[1]}$separator"
        crontab_line="$crontab_line${crontab_fields[2]}$separator"
        crontab_line="$crontab_line${crontab_fields[3]}$separator"
        crontab_line="$crontab_line${crontab_fields[4]}$separator$backup_job"
        echo "$crontab_line" >>/startup/crontab
    fi
}

echo "SHELL=/bin/bash" >/startup/crontab

# ensure that environment variables of container are passed to cron
printenv >/startup/container.env
echo "BASH_ENV=/startup/container.env" >>/startup/crontab

write_crontab_line "$CRONTAB_LINE_1"
write_crontab_line "$CRONTAB_LINE_2"
write_crontab_line "$CRONTAB_LINE_3"
write_crontab_line "$CRONTAB_LINE_4"
write_crontab_line "$CRONTAB_LINE_5"
write_crontab_line "$CRONTAB_LINE_6"
write_crontab_line "$CRONTAB_LINE_7"
write_crontab_line "$CRONTAB_LINE_8"
write_crontab_line "$CRONTAB_LINE_9"

crontab -u postgres /startup/crontab
printf "Installed the following cron jobs:\n"
crontab -u postgres -l
