## Hint

- `community.general.lvol`: manages logical volumes
  - `vg:` — volume group name
  - `lv:` — logical volume name
  - `size:` — size (e.g., `1200m`, `1g`, `100%FREE`)
- `ansible.builtin.filesystem`: formats a device (`fstype: ext4`, `dev: /dev/vg/lv`)
- LVM requires the VG to already exist — check with `vgs vgname` before creating the LV
- Use `register: + ignore_errors: true` to detect missing VG, then `when: rc != 0` for the message
- The block/rescue pattern handles the size-too-large error gracefully
- LV device path: `/dev/VG_NAME/LV_NAME` or `/dev/mapper/VG_NAME-LV_NAME`
- Do NOT use `ansible.builtin.mount` — the task says do not mount the LV
