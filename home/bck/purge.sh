#!/bin/bash
montage=/home/partimag
retention=7

cd $montage
nombre_fichier=$(ls -ltd 2* | wc -l)
if [ "$nombre_fichier" -gt "$retention" ];
then
   dossier_a_supprimer=$(ls -ltd 2* | tail -n 1 | awk '{print $9}')
   rm -rf $dossier_a_supprimer
   echo "$(date +"%Y%m%d") - $montage - suppression du $dossier_a_supprimer" >> /home/partimage/purge.log
else
   echo "$(date +"%Y%m%d") - $montage - pas de purge" >> /home/partimage/purge.log
fi

# on cherche un disque usb
blkid | grep -q "SAVE.*ntfs"
if [ "$?" -eq "0" ];
then
   montage=/home/usb
   cd $montage
   nombre_fichier=$(ls -ltd 2* | wc -l)
   if [ "$nombre_fichier" -gt "$retention" ];
   then
      dossier_a_supprimer=$(ls -ltd 2* | tail -n 1 | awk '{print $9}')
      rm -rf $dossier_a_supprimer
      echo "$(date +"%Y%m%d") - $montage - suppression du $dossier_a_supprimer" >> /home/partimage/purge.log
   else
      echo "$(date +"%Y%m%d") - $montage - pas de purge" >> /home/partimage/purge.log
   fi

   echo "demontage de la partition $partition_externe_backup de backup usb"
   umount /home/usb
   echo "demontage ok"
fi

# on eteint le pc
echo "reboot du pc"
poweroff
