#!/usr/bin/env bash
groupadd -g 50001 developers
useradd -u 2003 -G developers carol
echo 'RedHat9!' | passwd --stdin carol
chage -M 30 -W 7 -I 5 carol
useradd -u 2004 -G developers -s /bin/sh dave
echo 'RedHat9!' | passwd --stdin dave
passwd -l dave
