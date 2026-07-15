## Adjust process scheduling priority for running and new processes

The process **sha256_worker** (a background shell loop) is already running on the system; adjust its priority to a nice value of **15**. Also start a new background `dd` process reading from `/dev/zero` and writing to `/dev/null`, launched with a nice value of **-5**, and leave it running.
