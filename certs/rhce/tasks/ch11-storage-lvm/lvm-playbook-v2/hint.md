## Hint

- `community.general.lvol`: creates logical volumes; VG must already exist
- `ansible.builtin.filesystem`: formats a block device; idempotent — won't reformat if already formatted
- `ansible.builtin.mount` states:
  - `state: mounted` — mounts now AND adds to `/etc/fstab` (persistent across reboots)
  - `state: present` — adds to `/etc/fstab` but does not mount immediately
  - `state: unmounted` — unmounts but keeps the `/etc/fstab` entry
  - `state: absent` — unmounts and removes the `/etc/fstab` entry
- LV device path: `/dev/VG_NAME/LV_NAME` (symlink to actual device mapper path)
- The `path:` parameter in `mount` is the mount point directory — Ansible creates it automatically
- Verify: `ansible -m command -a "df -h" prod` after running the playbook
