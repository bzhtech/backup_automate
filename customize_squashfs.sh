#!/bin/bash
dest="clonezilla"
mkdir $dest


function create_user_sshfs_clonezilla()
{
  sudo adduser --group --system --quiet bck
  sudo cp -rf home/bck/* /home/bck/
  sudo chmod +x /home/bck/*.sh
  sudo chown -R bck:bck /home/bck
  sudo chmod 700 /home/bck/.ssh
  sudo chmod 664 /home/bck/.ssh/authorized_keys
}

if [ ! -e /home/bck/backup.sh ];
then
   create_user_sshfs_clonezilla()
fi

if [ ! -e clonezilla-live-3.0.1-8-amd64.iso ];
then
   wget https://freefr.dl.sourceforge.net/project/clonezilla/clonezilla_live_stable/3.0.1-8/clonezilla-live-3.0.1-8-amd64.iso -o clonezilla-live-3.0.1-8-amd64.iso
fi


# mount iso file to /mnt/iso
sudo mkdir /mnt/iso
sudo mount clonezilla-live-3.0.1-8-amd64.iso /mnt/iso

# grep kernel and initrd from iso
cp /mnt/iso/live/initrd.img $dest/
cp /mnt/iso/live/vmlinuz $dest/

tmp=$$
# unsquashfs to tmp folder to patch it
sudo unsquashfs -f -d $tmp /mnt/iso/live/filesystem.squashfs

# unmount iso file
sudo umount /mnt/iso

# remove old squashfs file to avoid merging issues
sudo rm -f $dest/filesystem.squashfs

# patch root .ssh ssh private key file and autotrust fingerprints new hosts connections for sshfs
sudo mkdir -p $tmp/root/.ssh
sudo cp ssh/* $tmp/root/.ssh
sudo chown root:root $tmp/root/.ssh
sudo chmod 700 $tmp/root/.ssh
sudo chmod 600 $tmp/root/.ssh/id_rsa
sudo chmod 644 $tmp/root/.ssh/id_rsa.pub
sudo chmod 644 $tmp/root/.ssh/config

# recreate squashfs
sudo mksquashfs $tmp $dest/filesystem.squashfs -b 1024k -comp xz -Xbcj x86 -e boot

sudo rm -rf $tmp
