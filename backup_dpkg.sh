#!/bin/bash
# Version 1.0
##############################################################################
# backup_dpkg.sh
#
# Original written by Nathan Rosenquist <nathan@rsnapshot.org>
# http://www.rsnapshot.org/
# Modified by C4 Tech & Design http://www.c4tech.com
#
# This script simply backs up a list of which Debian packages are installed.
# Naturally, this only works on a Debian system.
#
# Usage backup_dpkg.sh localhost or backup_dpkg.sh IP or HOSTNAME
# Of course you should exchange keys with host to login without a password
#
# This script simply needs to dump a file into the current working directory.
# rsnapshot handles everything else.
#
##############################################################################

source /usr/local/bin/libC4Rsnapshot.sh
FILENAME=dpkg_selections_$1
COMMAND="/usr/bin/dpkg --get-selections"
runThis $1 "DPKG Backup" "$FILENAME" "$COMMAND"
