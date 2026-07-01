## Redirect standard output and standard error separately

The script **{{NOISY_SCRIPT}}** prints a success message to standard output
and an error message to standard error, then exits with status 1.

**{{OUT_FILE}}** already contains a line from a previous run that must be
kept.

Your task, using a single invocation of **{{NOISY_SCRIPT}}**:

1. **Append** its standard output to **{{OUT_FILE}}** — the existing line
   must remain.
2. Redirect its standard error to **{{ERR_FILE}}**.
3. Standard output must **not** appear in **{{ERR_FILE}}**, and standard
   error must **not** appear in **{{OUT_FILE}}**.
