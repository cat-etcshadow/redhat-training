## Run a background process immune to hangup with nohup

The script **/usr/local/bin/rhtr-worker.sh** prints a timestamp once per
second and runs indefinitely.

Your task:

1. Launch **/usr/local/bin/rhtr-worker.sh** in the background using `nohup`,
   so it would keep running even if your terminal session ended.

2. Redirect its standard output to **{{LOG_FILE}}**.

3. The process must still be running, and **{{LOG_FILE}}** must keep
   growing, after your session ends.
