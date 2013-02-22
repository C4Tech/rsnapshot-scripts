#!/bin/bash -e
# Veriosn 1.0
###########################################################
# Back up MySQL databases
###########################################################
# This requires the .my.cnf in the home directory of the user the script runs as (root, when being run from rsnapshot).
# As it contains an important password, permissions on this file should be 600 (-rw-------).
# 
# [client]
# user     = root
# password = YOUR_MYSQL_ROOT_PASSWORD

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
PATH="$PATH:/usr/local/mysql/bin"

source /usr/local/bin/libC4Rsnapshot.sh

logThis $HOST $MOD "Starting Backup"

HOST=$1
EXIT_CODE=0

# Get list of all databases
if [ "$HOST" = "localhost" ]; then
        REMOTECOMMAND=""
        DB_LIST=`mysql -Bse "show databases"`
else
        REMOTECOMMAND="ssh $HOST"
        DB_LIST=`$REMOTECOMMAND mysql -Bse \"show databases\"`
fi


for db in $DB_LIST; do
   if [ "$db" != "information_schema" ]; then
        FILENAME=$db.sql.gz
        #ORIGINAL: $REMOTECOMMAND mysqldump $db | gzip -9 > $FILENAME

        if [ "$HOST" = "localhost" ]; then
                        mysqldump $db | gzip -9 > $FILENAME
        else
                $REMOTECOMMAND "mysqldump $db | gzip -9" > $FILENAME
                EXIT_CODE="$?"
                if [ "$EXIT_CODE" -gt "0" ]; then
                        echo "ERROR while backing MYSQL in $HOST"
                fi
        fi
        chmod 600 $FILENAME
   fi
done

logThis $HOST $MOD "Finnished"
exit $EXIT_CODE
