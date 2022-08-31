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

backup=$(date +"%Y%m%d")
ocs-sr -batch -q2 -j2 -z1p -sfsck -scs -senc -p true savedisk $backup sda
