#!/usr/bin/env bash
cat > "$PLAYBOOK_FILE" <<EOF
---
- name: Create LVM logical volume with error handling
  hosts: all
  become: true
  tasks:
    - name: LVM volume creation with fallback
      block:
        - name: Create logical volume of $LV_SIZE
          community.general.lvol:
            vg: research
            lv: data
            size: $LV_SIZE
            state: present
      rescue:
        - name: Print error message
          ansible.builtin.debug:
            msg: "could not create logical volume of that size"

        - name: Create logical volume with fallback size $FALLBACK_SIZE
          community.general.lvol:
            vg: research
            lv: data
            size: $FALLBACK_SIZE
            state: present
      always:
        - name: Report task completion
          ansible.builtin.debug:
            msg: "LVM task complete"
EOF

chown student:student "$PLAYBOOK_FILE"
