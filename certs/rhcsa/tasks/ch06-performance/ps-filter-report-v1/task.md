## Filter processes by name with ps and save a PID report

Two worker processes, **rhtr-worker-a** and **rhtr-worker-b**, are running.
A third, unrelated process, **rhtr-other-proc**, is also running and must be
excluded.

Your task:

1. Use `ps -ef` together with `grep` to find the PIDs of every process whose
   command line contains **rhtr-worker**.

2. Write those PIDs, one per line, sorted numerically, to
   **{{REPORT_FILE}}** — and nothing else.
