#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Create and format disk partition with error handling
  hosts: prod
  become: true
  tasks:
    - name: Check if /dev/$DISK exists
      ansible.builtin.stat:
        path: /dev/$DISK
      register: disk_stat

    - name: Report missing disk
      ansible.builtin.debug:
        msg: "this disk does not exist"
      when: not disk_stat.stat.exists

    - name: Partition disk with fallback handling
      when: disk_stat.stat.exists
      block:
        - name: Create primary partition of $PART_SIZE on /dev/$DISK
          community.general.parted:
            device: /dev/$DISK
            number: 1
            state: present
            part_type: primary
            part_start: 0%
            part_end: $PART_SIZE

        - name: Format partition with $FS_TYPE
          ansible.builtin.filesystem:
            fstype: $FS_TYPE
            dev: /dev/${DISK}1

      rescue:
        - name: Report partition size error
          ansible.builtin.debug:
            msg: "Could not create partition of that size"

        - name: Create partition with fallback size $FALLBACK_SIZE
          community.general.parted:
            device: /dev/$DISK
            number: 1
            state: present
            part_type: primary
            part_start: 0%
            part_end: $FALLBACK_SIZE
EOF

chown student:student "$PLAYBOOK_FILE"
