## Diagnose SELinux denial from audit log and apply fix

The **httpd** service is running but users report that scripts in
**/var/www/cgi-bin/** are failing with permission errors, even though
the Unix permissions are correct and SELinux is in Enforcing mode.

Your task:

1. Examine the SELinux audit log to identify the denial.

2. Enable the relevant SELinux boolean — persistently.

3. Confirm httpd is running and SELinux remains in **Enforcing** mode.
