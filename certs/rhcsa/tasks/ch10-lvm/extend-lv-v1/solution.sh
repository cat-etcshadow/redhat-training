#!/usr/bin/env bash
lvextend -L +300M /dev/vg_app/lv_app
xfs_growfs /mnt/app
