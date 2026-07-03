## Identify SELinux process context of running services

The **httpd** service is installed and running.

Your task:

1. Determine the SELinux **type** of the running **httpd**
   process (e.g. `httpd_t`) and write just the type, and nothing else, to
   **{{OUTPUT_FILE}}**.
2. Determine the SELinux **type** of the running **sshd**
   process and append just the type to **{{OUTPUT_FILE}}** on a second
   line.
3. SELinux must remain in **Enforcing** mode.
