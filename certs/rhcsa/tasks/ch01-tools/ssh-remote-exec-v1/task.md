## Execute commands on a remote system over SSH

SSH key-based authentication to `localhost` is already configured for root.
An executable script exists at **{{REMOTE_SCRIPT}}**.

Your task, using **ssh**:

1. Run **{{REMOTE_SCRIPT}}** on `localhost` and redirect its standard
   output to **{{OUT_FILE}}** (overwriting any existing content).
2. Run the command `date +%Y` on `localhost` and **append** its output to
   **{{OUT_FILE}}**.
3. **{{OUT_FILE}}** must end up containing exactly two lines: the output of
   **{{REMOTE_SCRIPT}}**, followed by the current four-digit year.

Neither command may prompt for a password.
