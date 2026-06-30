#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Create LVM logical volume with persistent mount
  hosts: prod
  become: true
  tasks:
    - name: Create logical volume $LV_NAME of $LV_SIZE in $VG_NAME
      community.general.lvol:
        vg: $VG_NAME
        lv: $LV_NAME
        size: $LV_SIZE
        state: present

    - name: Format $LV_NAME with $FS_TYPE filesystem
      ansible.builtin.filesystem:
        fstype: $FS_TYPE
        dev: /dev/$VG_NAME/$LV_NAME

    - name: Mount $LV_NAME persistently at $MOUNT_POINT
      ansible.builtin.mount:
        src: /dev/$VG_NAME/$LV_NAME
        path: $MOUNT_POINT
        fstype: $FS_TYPE
        state: mounted
EOF

chown student:student "$PLAYBOOK_FILE"
