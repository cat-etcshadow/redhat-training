## Detach a background process from your shell session

The script **/usr/local/bin/rhtr-worker2.sh** prints a timestamp once per second and runs indefinitely. Launch it in the background from your shell, redirecting its standard output to **{{LOG_FILE}}**, then remove the job from your shell's job table so it is no longer tied to your session. The process must still be running, and **{{LOG_FILE}}** must keep growing, after your session ends.
