## Hint

- Module: `ansible.builtin.cron`
- Key parameters: `name` (label), `user`, `minute`, `job`
- "Every N minutes" uses `minute: "*/N"` (e.g., `"*/2"` for every 2 minutes)
- Default for omitted time fields is `*` (every hour/day/month/weekday)
- The `name` parameter is required — it's the cron job comment used to identify/update the entry
- `user` specifies whose crontab to manage; needs `become: true`
- `ansible-doc ansible.builtin.cron` for full parameter list
