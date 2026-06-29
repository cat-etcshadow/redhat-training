## Hint

- `loginctl enable-linger <user>` — allow user's systemd instance to start at boot
- `loginctl show-user <user>` — check linger status
- User systemd units live in `~/.config/systemd/user/`
- `systemctl --user` — manage user-level services (not system services)
- `podman generate systemd --name <ctr> --files --new` — generate unit in current dir
- The `--new` flag generates a unit that always creates a fresh container on start
- `systemctl --user daemon-reload` — reload after adding new unit files
- `systemctl --user enable --now` — enable and start in one step
- Without `enable-linger`, user services stop when the user logs out
