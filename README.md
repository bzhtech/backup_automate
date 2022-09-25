# backup_automate

- download last clonezilla amd64 iso && ubuntu 22.04 server iso
  clonezilla ISO : 
     https://sourceforge.net/projects/clonezilla/files/latest/download
  ubuntu 22 ISO : 
     http://ubuntu.mirrors.ovh.net/ubuntu-releases/jammy/ubuntu-22.04.1-live-server-amd64.iso

- create bootable usb drive with the iso downloaded

on the ubuntu server :
- install ubuntu ( create bck/bck user ) with the usb drive
- install services : isc-dhcp-server && tftpd-hpa.service on ubuntu server
- scp all files from the git repo to the server with the same path as the git hierarchy ( verify file permissions of the existing ones, before replacing them )
- update /etc/netplan/00-installer-config.yaml network interface configuration
and  "netplan apply" , to apply the new configuration
- update /etc/dhcpd/dhcpd.conf to match network subnet
- update /srv/tftp/grub.cfg to match  your own server ip ( exposing a dhcp and tftp service at this address W.X.Y.Z )
#- generate grubx64.efi with good tftp ip W.X.Y.Z
#     grub-mkimage --format=x86_64-efi -o /srv/tftp/grubx64.efi --prefix='(tftp,W.X.Y.Z)/' efinet tftp
- update filesystem.squashfs clonezilla original file with ssh customisations ( id_rsa and config )
cd /srv/tftp/
./customize_squashfs.sh
- install grub pxe x86_64-efi mod files (add amd64 archi, and apt download grub-efi-amd64-bin:amd64 and extract content :
./install-grub-amd64-files.sh

- verify the find the root@backup key in /home/bck/.ssh/authorized_keys ( used to mount custom scripts backup & restore via sshfs in /home/partimag/ )
     this key as been added the squashfs for automounting sshfs and gaining access to /home/bck on the server to the pxe clients
- format the external usb partition with SAVE label ( the clonezilla backup scripts search this label to know if external drive is present ) :
     mkfs.ntfs -f -L SAVE -s 4096 /dev/sdX1

in clients Bios :
-disable fastboot in the bios.
-enable network lan bios/pxe boot
-enable WOL and configure it, to boot from pxe ( the server will wake on lan the clients, to autosave theirs drives )
-in the boot order, enable pxe boot, but, set it just after the system drive ( this way, the restoration action, could be launched by the user himself ).
œ

in clients  operating system :
  - Linux : change the network WakeonLan parameters with ethtool
  - Windows, enable the network card device, to allow the computer to be wake up from it

