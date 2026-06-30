#!/usr/bin/env bash
VG_NAMES=(research data_vg)
LV_NAMES=(appdata webdata dbdata)
SIZES=(500m 800m 1g)
FS_TYPES=(xfs ext4)
MOUNT_POINTS=(/mnt/app /mnt/web /srv/storage)
PLAYBOOKS=(lvm-mount.yml persistent-storage.yml lvm-fstab.yml)

vgidx=$(( RANDOM % ${#VG_NAMES[@]} ))
lvidx=$(( RANDOM % ${#LV_NAMES[@]} ))
sidx=$(( RANDOM % ${#SIZES[@]} ))
fsidx=$(( RANDOM % ${#FS_TYPES[@]} ))
midx=$(( RANDOM % ${#MOUNT_POINTS[@]} ))
pidx=$(( RANDOM % ${#PLAYBOOKS[@]} ))

echo "ANSIBLE_DIR=/home/student/ansible"
echo "PLAYBOOK_FILE=/home/student/ansible/${PLAYBOOKS[$pidx]}"
echo "VG_NAME=${VG_NAMES[$vgidx]}"
echo "LV_NAME=${LV_NAMES[$lvidx]}"
echo "LV_SIZE=${SIZES[$sidx]}"
echo "FS_TYPE=${FS_TYPES[$fsidx]}"
echo "MOUNT_POINT=${MOUNT_POINTS[$midx]}"
