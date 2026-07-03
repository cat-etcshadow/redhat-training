#!/usr/bin/env bash
lvextend -l +100%FREE "/dev/$VG_NAME/$LV_NAME"
xfs_growfs "$MOUNT_POINT"
