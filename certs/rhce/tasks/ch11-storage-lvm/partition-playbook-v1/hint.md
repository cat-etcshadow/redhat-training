## Hint

- `community.general.parted`: wraps the `parted` tool
  - `device:` — block device (e.g., `/dev/sdb`)
  - `number:` — partition number (1 for first partition)
  - `part_type:` — `primary`, `extended`, `logical`
  - `part_start:` / `part_end:` — size in `MiB`, `GiB`, or `%`
  - `state: present` creates the partition; `state: absent` removes it
- Partition device path: `/dev/sdb1` for partition 1 of `/dev/sdb`
- `ansible.builtin.stat` checks if a file/device exists — use `stat.stat.exists`
- `ansible.builtin.filesystem` is idempotent — won't reformat if already formatted
- Check mode: `community.general.parted` supports `--check` via `check_mode: true`
- Verify partitions: `ansible prod -m command -a "lsblk /dev/sdb" -b`
