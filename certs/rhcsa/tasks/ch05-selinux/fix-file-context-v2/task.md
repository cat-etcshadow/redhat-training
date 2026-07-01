## Fix SELinux file context on custom service data directory

The **vsftpd** FTP server is installed and configured to serve files from
**/srv/ftp/pub/** instead of the default `/var/ftp/pub/`.

The service fails to serve files from this custom location because SELinux
is denying access — the directory has the wrong context type.

Your task:

1. Identify the correct SELinux context type that vsftpd requires for its
   content directories.

2. Configure a **persistent** policy so that **/srv/ftp/pub** and all content
   beneath it carries the correct context.

3. Apply the context to the existing files.

4. Confirm that SELinux remains in **Enforcing** mode.
