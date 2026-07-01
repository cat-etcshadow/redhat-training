## Restore the correct SELinux context after a file copy

The Apache web server (**httpd**) serves content from
**/var/www/html/{{WEBDIR}}/**.

A file was copied into this directory with a command that preserved the
**source** file's SELinux context instead of picking up the correct context
for its new location. As a result, **page.html** in that directory has the
wrong SELinux type and httpd cannot serve it.

Your task:

1. Identify the incorrect SELinux context on
   **/var/www/html/{{WEBDIR}}/page.html**.

2. Restore the correct context using the directory's **existing** SELinux
   policy — no new policy rule needs to be defined for this path.
