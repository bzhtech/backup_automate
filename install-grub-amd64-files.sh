#!/bin/bash
# correction archi des fichiers grubs
tmp=$$
cp etc/apt/sources.list /etc/apt/
dpkg --add-architecture amd64
apt update
cd /root
apt download grub-efi-amd64-bin:amd64
mkdir /tmp/$tmp
dpkg-deb -x grub-efi-amd64-bin*.deb /tmp/$tmp
cp -rf /tmp/$tmp/usr/lib/grub/x86_64-efi /srv/tftp
rm -rf /tmp/$tmp
