## Switch Users with a Full Login Shell

The user **{{TARGET_USER}}** already exists on this system.

Your task:

1. Switch to the **{{TARGET_USER}}** account using `su`, in a way that starts
   a full login shell — equivalent to actually logging in as that user, not
   just changing your effective UID while keeping your original environment.
2. While logged in as **{{TARGET_USER}}**, create a file named
   `confirmed.txt` in **{{TARGET_USER}}**'s home directory containing two
   lines:
   - the output of `whoami`
   - the output of `pwd`
3. The file must be owned by **{{TARGET_USER}}**.
