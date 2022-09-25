#!/bin/bash
dest="clonezilla"
mkdir $dest
tmp=$$
wget https://freefr.dl.sourceforge.net/project/clonezilla/clonezilla_live_stable/3.0.1-8/clonezilla-live-3.0.1-8-amd64.iso
sudo mkdir /mnt/iso
sudo mount clonezilla-live-3.0.1-8-amd64.iso /mnt/iso
cp /mnt/iso/live/initrd.img $dest/
cp /mnt/iso/live/vmlinuz $dest/
sudo unsquashfs -f -d $tmp /mnt/iso/live/filesystem.squashfs
sudo umount /mnt/iso
sudo rm -f $dest/filesystem.squashfs clonezilla*.iso
sudo mkdir -p $tmp/root/.ssh
sudo cp ssh/* $tmp/root/.ssh
sudo chown root:root $tmp/root/.ssh
sudo chmod 700 $tmp/root/.ssh
sudo chmod 600 $tmp/root/.ssh/id_rsa
sudo chmod 644 $tmp/root/.ssh/id_rsa.pub
sudo mksquashfs $tmp $dest/filesystem.squashfs -b 1024k -comp xz -Xbcj x86 -e boot
sudo rm -rf $tmp
