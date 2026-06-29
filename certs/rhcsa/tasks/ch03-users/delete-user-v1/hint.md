## Hint

- `usermod -L <user>` — lock the account (disable password login)
- `userdel -r <user>` — delete user AND home directory and mail spool
- `userdel <user>` without `-r` leaves the home directory behind
- `groupdel <group>` — delete a group (fails if it's anyone's primary group)
- Check for remaining files: `find / -user <user>` (then chown or delete them)
- After deletion, `id <user>` returns exit code 1 (user not found)
