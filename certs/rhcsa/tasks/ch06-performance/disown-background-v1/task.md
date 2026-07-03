## Run a background process immune to hangup with disown

The script **/usr/local/bin/rhtr-worker2.sh** prints a timestamp once per
second and runs indefinitely.

Your task:

1. Launch **/usr/local/bin/rhtr-worker2.sh** in the background from your
   shell.
2. Redirect its standard output to **{{LOG_FILE}}**.
3. Use `disown` to remove the job from your shell's job table so it is no
   longer tied to your session.
4. The process must still be running, and **{{LOG_FILE}}** must keep
   growing, after your session ends.
