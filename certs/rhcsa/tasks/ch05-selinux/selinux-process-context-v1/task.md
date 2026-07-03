## Identify SELinux process context with ps -Z

The **httpd** service is installed and running.

Your task:

1. Using `ps -Z`, determine the SELinux **type** of the running **httpd**
   process (e.g. `httpd_t`) and write just the type, and nothing else, to
   **{{OUTPUT_FILE}}**.
2. Using `ps -Z`, determine the SELinux **type** of the running **sshd**
   process and append just the type to **{{OUTPUT_FILE}}** on a second
   line.
3. SELinux must remain in **Enforcing** mode.
