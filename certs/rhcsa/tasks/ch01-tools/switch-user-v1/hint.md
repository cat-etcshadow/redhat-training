## Hint

- `su - TARGET_USER` starts a full login shell: it changes both the working
  directory and the environment (PATH, HOME, etc.) to match a real login
- `su TARGET_USER` (without the dash) only changes your effective UID — your
  working directory and most of your environment stay the same
- Inside the switched shell: `{ whoami; pwd; } > ~/confirmed.txt`
