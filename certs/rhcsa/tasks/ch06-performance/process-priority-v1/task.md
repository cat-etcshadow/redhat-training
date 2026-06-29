## Adjust process scheduling priority with nice and renice

Perform the following process scheduling tasks on **server**:

1. The process **sha256_worker** (a background shell loop) is already running
   on the system. Find its PID and **renice** it to a nice value of **15**
   (lower priority).

2. Start a new background `dd` process reading from `/dev/zero` and writing
   to `/dev/null`, launched with a nice value of **-5** (higher priority,
   requires root).
   The process must still be running when grading is performed.

3. Confirm the nice values using `ps` or `top`.
