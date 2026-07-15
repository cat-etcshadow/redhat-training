## Restore the correct SELinux context after a file copy

The Apache web server (**httpd**) serves content from **/var/www/html/{{WEBDIR}}/**. A file was copied into this directory with a command that preserved the source file's SELinux context instead of picking up the correct context for its new location, so **page.html** in that directory has the wrong SELinux type and httpd cannot serve it. Restore the correct SELinux context on **/var/www/html/{{WEBDIR}}/page.html**.
