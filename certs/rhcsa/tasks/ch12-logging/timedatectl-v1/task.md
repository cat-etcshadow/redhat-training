## Configure system time zone and NTP synchronization

The system timezone is currently set to UTC and NTP synchronization is disabled.

Your task:

1. Set the system time zone to **{{TIMEZONE}}** using `timedatectl`.
2. Enable and start the **chronyd** NTP service so the system clock is
   synchronized automatically.
3. Verify:
   ```
   timedatectl
   systemctl status chronyd
   ```
