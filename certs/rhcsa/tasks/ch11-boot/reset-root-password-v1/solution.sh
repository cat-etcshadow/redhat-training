#!/usr/bin/env bash
# Real exam procedure (interactive — cannot be automated):
#   1. Reboot: press 'e' at the GRUB menu to edit the boot entry
#   2. On the 'linux' kernel line, append: rd.break
#   3. Press Ctrl-X to boot with that parameter
#   4. At the emergency shell:
#        mount -o remount,rw /sysroot
#        chroot /sysroot
#        echo 'RedHat123!' | passwd --stdin root
#        touch /.autorelabel
#        exit
#        exit
#   5. The system reboots, SELinux relabels all files, then boots normally
#
# Lab shortcut (already have root via incus exec):
echo 'root:RedHat123!' | chpasswd
