## Diagnose SELinux denial from audit log and apply fix

The **httpd** service is running but users report that scripts in **/var/www/cgi-bin/** are failing with permission errors, even though the Unix permissions are correct and SELinux is in Enforcing mode. Enable the relevant SELinux boolean, persistently, so that httpd can execute the CGI scripts, keeping httpd running and SELinux in **Enforcing** mode.
