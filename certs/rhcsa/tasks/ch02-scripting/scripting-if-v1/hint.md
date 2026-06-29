## Hint

- Check argument count: `[[ $# -ne 1 ]]`
- Write to stderr: `echo "message" >&2`
- Test if a user exists: `id "$username" &>/dev/null`
- Get a user's UID: `id -u "$username"`
- `exit 0` / `exit 1` / `exit 2` — set the script's return code
- Make executable: `chmod +x /path/to/script.sh`
- Always start with `#!/usr/bin/env bash` or `#!/bin/bash`
