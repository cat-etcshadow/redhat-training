## Filter and extract user information with grep and cut

The file **{{INPUT_FILE}}** contains `/etc/passwd`-format lines.

Your task:

1. Find all lines in **{{INPUT_FILE}}** where the login shell is
   `/bin/{{TARGET_SHELL}}` (the last `:` field). Write the **full matching lines**
   to **{{OUTPUT_USERS}}**.
   ```
   grep '/bin/{{TARGET_SHELL}}$' {{INPUT_FILE}} > {{OUTPUT_USERS}}
   ```

2. From **{{OUTPUT_USERS}}**, extract **only the usernames** (field 1, colon-delimited)
   and write them to **{{OUTPUT_NAMES}}**, one name per line.
   ```
   cut -d: -f1 {{OUTPUT_USERS}} > {{OUTPUT_NAMES}}
   ```

3. Verify:
   - Each line in **{{OUTPUT_USERS}}** ends with `/bin/{{TARGET_SHELL}}`
   - **{{OUTPUT_NAMES}}** contains only plain usernames (no colons)

This mirrors a common real-world task: finding all users with a given shell.
