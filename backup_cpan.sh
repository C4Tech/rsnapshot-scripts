#!/bin/bash
# Version 1.0
##############################################################################
# backup_cpan.sh
#
# Original written by Nathan Rosenquist <nathan@rsnapshot.org>
# http://www.rsnapshot.org/
# Modified by C4 Tech and Design
# http://www.c4tech.com
#
# This script simply backs up a list of which cpan modules are installed.
#
# This script simply needs to dump a file into the current working directory.
# rsnapshot handles everything else.
#
# usage backup_cpan.sh localhost or backup_cpan.sh IP or HOSTNAME
# Of course you should exchange keys with host to login without a password
##############################################################################

source /usr/local/bin/libC4Rsnapshot.sh

HOST=$1
FILENAME=cpan_installed_mods_$HOST
SSH=/usr/bin/ssh
SCP=/usr/bin/scp
COMMAND=/usr/local/bin/cpan_backup.pl

runThis $HOST "CPAN Backup" $FILENAME $COMMAND
