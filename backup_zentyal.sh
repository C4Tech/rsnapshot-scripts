#!/bin/bash
# Version 1.1

LOG="/var/log/rsnapshot.log"
DEBUG=0


date2stamp () {
        date --utc --date "$1" +%s
}

stamp2date () {
        date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T" 
}

dateDiff (){
    case $1 in
        -s)   sec=1;      shift;;
        -m)   sec=60;     shift;;
        -h)   sec=3600;   shift;;
        -d)   sec=86400;  shift;;
        *)    sec=86400;;
    esac
    dte1=$(date2stamp $1)
    dte2=$(date2stamp $2)
    diffSec=$((dte2-dte1))
    if ((diffSec < 0)); then abs=3; else abs=1; fi
    echo $((diffSec/sec*abs))
}

function logThis {
        HOST="$1"
        mod="$2"
        output="$3"
        DATE=`date +%d/%b/%Y:%H:%M:%S`
        echo "[$DATE] $HOST - $mod: $output" >> $LOG
        if [ $DEBUG ]; then echo "[$DATE] $HOST - $mod: $output"; fi
        }

function runThis {
        HOST=$1
        MOD="$2"
        FILENAME="zentyal_backup.tar"
#       COMMAND="/usr/share/ebox/ebox-make-backup --config-backup; 'mv /var/lib/ebox/conf/backups/* ./zentyal_backup.tar"

        logThis $HOST $MOD "Starting Backup"
        if [ "localhost" = "$HOST" ]; then
                ERROR=$( { /usr/share/ebox/ebox-make-backup --config-backup; } 2>&1 )
                EXITCODE="$?"
                if [ "$EXITCODE" -gt 0 ]; then
                        logThis $HOST $MOD "Error was: $ERROR. "
                        RETURN=$EXITCODE
                fi

                ERROR=$( { mv /var/lib/ebox/conf/backups/* .; } 2>&1 )
                EXITCODE="$?"
                if [ "$EXITCODE" -gt 0 ]; then
                        logThis $HOST $MOD "Error was: $ERROR. "
                        RETURN=$EXITCODE
                fi
        else
                ERROR=$( { ssh $HOST "/usr/share/ebox/ebox-make-backup --config-backup"; } 2>&1 )
                EXITCODE="$?"
                if [ "$EXITCODE" -gt 0 ]; then
                        logThis $HOST $MOD "Error was: $ERROR. "
                        RETURN="$EXITCODE"
                fi
                ERROR=$( { scp $HOST /var/lib/ebox/conf/backups/* . ; } 2>&1 )
                EXITCODE="$?"
                if [ "$EXITCODE" -gt 0 ]; then
                        logThis $HOST $MOD "Error was: $ERROR. "
                        RETURN="$EXITCODE"
                fi

        fi

        if [ $RETURN ]; then
                logThis $HOST $MOD "ERROR command returned $RETURN"
        fi

        logThis $HOST $MOD "Finished"
        chmod 600 *
}

runThis $1 "Zentyal_Backup"

exit $RETURN
