## Diagnose SELinux denial from audit log and apply fix

The **httpd** service is running but users report that scripts in
**/var/www/cgi-bin/** are failing with permission errors, even though
the Unix permissions are correct and SELinux is in Enforcing mode.

Your task:

1. Examine the SELinux audit log to identify the denial. Use `ausearch`
   or `sealert` to find the relevant AVC denial for httpd CGI execution.

2. Identify and enable the SELinux boolean that controls CGI script
   execution for httpd — persistently.

3. Confirm httpd is running and SELinux remains in **Enforcing** mode.
