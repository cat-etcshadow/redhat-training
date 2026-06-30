#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Create LVM logical volume with error handling
  hosts: all
  become: true
  tasks:
    - name: Check if VG $VG_NAME exists
      ansible.builtin.command: vgs $VG_NAME
      register: vg_check
      ignore_errors: true
      changed_when: false

    - name: Report missing VG
      ansible.builtin.debug:
        msg: "volume group does not exist"
      when: vg_check.rc != 0

    - name: Create LV with fallback handling
      when: vg_check.rc == 0
      block:
        - name: Create logical volume $LV_NAME of $LV_SIZE
          community.general.lvol:
            vg: $VG_NAME
            lv: $LV_NAME
            size: $LV_SIZE
            state: present

        - name: Create $FS_TYPE filesystem on LV
          ansible.builtin.filesystem:
            fstype: $FS_TYPE
            dev: /dev/$VG_NAME/$LV_NAME

      rescue:
        - name: Print size error message
          ansible.builtin.debug:
            msg: "could not create logical volume of that size"

        - name: Create logical volume with fallback size $FALLBACK_SIZE
          community.general.lvol:
            vg: $VG_NAME
            lv: $LV_NAME
            size: $FALLBACK_SIZE
            state: present
EOF

chown student:student "$PLAYBOOK_FILE"
