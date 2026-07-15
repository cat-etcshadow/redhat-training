## Execute commands on a remote system over SSH

SSH key-based authentication to `localhost` is already configured for root, and an executable script exists at **{{REMOTE_SCRIPT}}**. Using **ssh**, without either command prompting for a password, run **{{REMOTE_SCRIPT}}** on `localhost` and write its standard output to **{{OUT_FILE}}**, then run `date +%Y` on `localhost` and append its output, so that **{{OUT_FILE}}** ends up containing exactly two lines: the script's output followed by the current four-digit year.
