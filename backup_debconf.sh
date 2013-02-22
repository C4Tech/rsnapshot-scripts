#!/bin/bash
# Version 1.0
##############################################################################
# backup_debconf.sh
#
# by http://www.c4tech.com/
#
# This script simply backs up debconf, i.e. most of the choices made using apt
# Naturally, this only works on Debian based system.
#
# This script simply needs to dump a file into the current working directory.
# rsnapshot handles everything else.
##############################################################################

source /usr/local/bin/libC4Rsnapshot.sh

FILENAME=debconf_selections_$1
COMMAND="/usr/bin/debconf-get-selections"

runThis $1 "DEBCONF Backup" $FILENAME $COMMAND
