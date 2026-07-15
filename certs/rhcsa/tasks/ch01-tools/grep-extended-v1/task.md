## Filter and extract user information with grep and cut

The file **{{INPUT_FILE}}** contains `/etc/passwd`-format lines. Write every line whose login shell (the last colon-delimited field) is `/bin/{{TARGET_SHELL}}` to **{{OUTPUT_USERS}}**, then extract just the usernames (the first colon-delimited field) from those lines into **{{OUTPUT_NAMES}}**, one plain username per line.
