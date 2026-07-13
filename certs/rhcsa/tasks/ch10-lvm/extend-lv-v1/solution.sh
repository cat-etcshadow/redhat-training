#!/usr/bin/env bash
lvextend -L "+$EXTEND_BY" "/dev/$VG_NAME/$LV_NAME"
xfs_growfs "$MOUNT_POINT"
