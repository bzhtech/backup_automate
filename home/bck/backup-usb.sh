#!/bin/bash
mkdir -p /home/usb

blkid | grep -q "SAVE.*ntfs"
if [ "$?" -eq "0" ];
then
   echo "montage de la partition $partition_externe_backup de backup"
   partition_externe_backup=$(blkid | grep "SAVE.*ntfs" | cut -d":" -f1)
   mount $partition_externe_backup /home/usb
   echo "montage de la partition de backup vers /home/usb OK"

   echo "lancement du backup"
   backup=$(date +"%Y%m%d")
   ocs-sr -batch -q2 -j2 -z1p -sfsck -scs -senc -or /home/usb -p true savedisk $backup sda
fi
