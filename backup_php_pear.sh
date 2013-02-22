#!/bin/bash
# Version 1.0
##############################################################################
# backup_php_pear.sh
#
# by Jeffrey Brite <jeff@c4tech.com>
# http://www.c4tech.com/
#
# This script simply backs up a list of installed pear mods.
#
# Please note that if some pear modules were installed by another packaging 
# system (i.e. apt-get) then they may show up here as well.
#
# This script simply needs to dump a file into the current working directory.
# rsnapshot handles everything else.
#
##############################################################################

HOST=$1
FILENAME=pear_mods_$HOST
COMMAND="/usr/bin/pear list"
SSH=/usr/bin/ssh
CHMOD=/bin/chmod

if [ "localhost" = "$HOST" ]; then
        ERROR=$( { $COMMAND > $FILENAME; } 2>&1 )
else
        ERROR=$( {    $SSH $HOST $COMMAND > $FILENAME;  } 2>&1 )
fi
# make the backup readable only by root
$CHMOD 600 $FILENAME
