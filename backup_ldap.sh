#!/bin/bash
# Veriosn 1.0
##############################################################################
# backup_ldap.sh
#
# Script by C4 Tech and Design http://www.c4tech.com
#
# This is a simple shell script to backup a LDAP database with rsnapshot.
#
# The assumption is that this will be invoked from rsnapshot. Also, since it
# will run unattended.
#
# This script simply needs to dump a file into the current working directory.
# rsnapshot handles everything else.
#
# Usage backup_ldap.sh localhost or backup_ldap.sh ip or hostname
# and use that in rsnapshot configureation
#
# Of course you should exchange keys with host to login without a password
##############################################################################

source /usr/local/bin/libC4Rsnapshot.sh

FILENAME=ldapdump_$1.ldif.gz
COMMAND="/usr/sbin/slapcat"

runThis $1 "LDAP Backup" $FILENAME $COMMAND
