## Search files with grep and regular expressions

The directory **{{LOG_DIR}}** contains several log files. Search all files under **{{LOG_DIR}}** recursively for lines containing `ERROR` or `error` (case-insensitive) and write the matches to **{{ERROR_OUTPUT}}**, and separately search for lines containing an IPv4 address (a pattern like `192.168.1.10` — four groups of 1-3 digits separated by dots) and write those matches to **{{IP_OUTPUT}}**.
