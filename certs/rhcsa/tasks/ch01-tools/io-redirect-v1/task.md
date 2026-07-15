## Redirect standard output and standard error separately

The script **{{NOISY_SCRIPT}}** prints a success message to standard output and an error message to standard error, then exits with status 1. **{{OUT_FILE}}** already contains a line from a previous run that must be kept. Using a single invocation of **{{NOISY_SCRIPT}}**, append its standard output to **{{OUT_FILE}}** and redirect its standard error to **{{ERR_FILE}}**, keeping the two streams fully separated.
