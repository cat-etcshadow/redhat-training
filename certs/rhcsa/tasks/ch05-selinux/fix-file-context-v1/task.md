## Fix SELinux file context on web content directory

The Apache web server (**httpd**) is installed and configured to serve content
from the directory **/var/www/html/{{WEBDIR}}/**.

However, httpd is currently returning **403 Forbidden** for all files in that
directory. The standard Unix permissions are correct.

The problem is that the files in **/var/www/html/{{WEBDIR}}/** have the wrong
SELinux context — they were copied from **/tmp** and retained a `tmp_t` context.

Your task:

1. Identify the incorrect SELinux context on the files in **/var/www/html/{{WEBDIR}}/**.

2. Apply the correct SELinux context (`httpd_sys_content_t`) to all files and
   the directory itself so that httpd can serve them.

3. The fix must be **persistent** — files added to **/var/www/html/{{WEBDIR}}/**
   in the future should automatically receive the correct context.

Do **not** set SELinux to permissive mode.
