#!/usr/bin/env bash
groupadd -g 50000 sysmgrs
useradd -u 2001 -G sysmgrs alice
useradd -u 2002 -G sysmgrs bob
echo 'RedHat9!' | passwd --stdin alice
echo 'RedHat9!' | passwd --stdin bob
echo 'alice ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/alice
chmod 0440 /etc/sudoers.d/alice
