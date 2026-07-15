## Switch Users with a Full Login Shell

The user **{{TARGET_USER}}** already exists on this system. Switch to the **{{TARGET_USER}}** account using `su` in a way that starts a full login shell, equivalent to actually logging in as that user rather than just changing your effective UID while keeping your original environment. While logged in as **{{TARGET_USER}}**, create a file named `confirmed.txt` in **{{TARGET_USER}}**'s home directory, owned by **{{TARGET_USER}}**, containing the output of `whoami` on the first line and the output of `pwd` on the second line.
