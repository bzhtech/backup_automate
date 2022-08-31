#!/bin/bash
# Begin of the scripts:
# Load DRBL setting and functions

DRBL_SCRIPT_PATH="/usr/share/drbl"
. $DRBL_SCRIPT_PATH/sbin/drbl-conf-functions
. /etc/drbl/drbl-ocs.conf
. $DRBL_SCRIPT_PATH/sbin/ocs-functions

# load the setting for clonezilla live.
[ -e /etc/ocs/ocs-live.conf ] && . /etc/ocs/ocs-live.conf

# Load language files. For English, use "en_US.UTF-8".
ask_and_load_lang_set en_US.UTF-8

decalage_jour=$1
date_restauration=$(date --date "${decalage_jour} days ago" +"%Y%m%d")
ocs-sr -batch -g auto -e1 auto -e2 -r -j2 -scr -p reboot restoredisk $date_restauration sda
