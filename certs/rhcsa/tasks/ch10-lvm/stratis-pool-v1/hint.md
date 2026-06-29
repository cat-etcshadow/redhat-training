## Hint

- `dnf install stratisd stratis-cli` + `systemctl enable --now stratisd`
- `stratis pool create <name> <device>` — creates pool (device must be unformatted)
- `stratis filesystem create <pool> <fsname>` — creates an XFS filesystem in the pool
- `stratis filesystem list` — shows all filesystems with their UUIDs
- The filesystem device path: `/dev/stratis/<pool>/<fsname>`
- Get UUID: `lsblk -o NAME,UUID /dev/stratis/<pool>/<fsname>`
- fstab entry requires `x-systemd.requires=stratisd.service` so stratisd starts first
- `stratis pool list` and `stratis filesystem list` are your main verification commands
