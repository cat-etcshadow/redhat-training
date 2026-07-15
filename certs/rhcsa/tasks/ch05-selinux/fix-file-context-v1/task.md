## Fix SELinux file context on web content directory

The Apache web server (**httpd**) is installed and configured to serve content from **/var/www/html/{{WEBDIR}}/**, but is returning **403 Forbidden** for all files there even though standard Unix permissions are correct — the SELinux context on the files is wrong. Apply the correct SELinux context to the directory and its files so httpd can serve them, and make the fix persistent so files added to **/var/www/html/{{WEBDIR}}/** in the future automatically receive the correct context.
