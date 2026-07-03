## Hint

- `shutdown -r +10 "Maintenance restart"` schedules a reboot 10 minutes out
- `shutdown` with no arguments, or `cat /run/systemd/shutdown/scheduled`,
  shows a pending schedule
- `shutdown -c` cancels a pending scheduled shutdown/reboot
- `systemctl reboot` reboots immediately — there's nothing to cancel
