#!/usr/bin/env bash
sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=${TIMEOUT_VAL}/" /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg
