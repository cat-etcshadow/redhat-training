#!/usr/bin/env bash
# investigate:
# lsblk
# vgs; lvs
# mount -a
vgchange -ay rhtr_dbvg
mount -a
