## Grant full sudo access via the wheel group

The user **{{WHEEL_USER}}** already exists but currently has no
administrative access. The `%wheel` group rule in `/etc/sudoers` has also
been disabled.

Your task:

1. Re-enable the `%wheel` group rule in `/etc/sudoers` so that members of
   the **wheel** group can run any command as root.
2. Add **{{WHEEL_USER}}** as a supplementary member of the **wheel** group.
3. `/etc/sudoers` must remain syntactically valid.
4. Confirm that **{{WHEEL_USER}}** can run any command as root via `sudo`.

Do not create any files under `/etc/sudoers.d/` for this task.
