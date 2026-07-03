## Run a background process that survives session end

The script **/usr/local/bin/rhtr-worker.sh** prints a timestamp once per
second and runs indefinitely.

Your task:

1. Launch **/usr/local/bin/rhtr-worker.sh** in the background, in a way
   that keeps it running even after your terminal session ends.

2. Redirect its standard output to **{{LOG_FILE}}**.

3. The process must still be running, and **{{LOG_FILE}}** must keep
   growing, after your session ends.
