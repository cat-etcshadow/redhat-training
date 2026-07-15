## Fix SELinux file context on custom service data directory

The **vsftpd** FTP server is installed and configured to serve files from **/srv/ftp/pub/** instead of the default `/var/ftp/pub/`, but fails to serve files from this custom location because SELinux is denying access — the directory has the wrong context type. Configure a persistent policy so that **/srv/ftp/pub** and all content beneath it carries the correct SELinux context for vsftpd content, apply it to the existing files, and keep SELinux in **Enforcing** mode.
