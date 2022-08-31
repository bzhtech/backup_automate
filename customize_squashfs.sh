#!/bin/bash
dest="tftp/clonezilla"
mkdir $dest
tmp=$$
wget https://freefr.dl.sourceforge.net/project/clonezilla/clonezilla_live_stable/3.0.1-8/clonezilla-live-3.0.1-8-amd64.iso
sudo mkdir /mnt/iso
sudo mount clonezilla-live-3.0.1-8-amd64.iso /mnt/iso
cp /mnt/iso/live/filesystem.squashfs ./
cp /mnt/iso/live/initrd.img $dest/
cp /mnt/iso/live/vmlinuz $dest/
sudo umount /mnt/iso
sudo unsquashfs -f -d $tmp filesystem.squashfs
sudo rm filesystem.squashfs
sudo mkdir $tmp/root/.ssh
sudo cp ssh/* $tmp/root/.ssh
sudo chown root:root $tmp/root/.ssh
sudo mksquashfs $tmp $dest/filesystem.squashfs -b 1024k -comp xz -Xbcj x86 -e boot
sudo rm -rf $tmp
