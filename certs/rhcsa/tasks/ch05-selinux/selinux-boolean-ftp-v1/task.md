## Enable SELinux boolean to allow anonymous FTP uploads

The **vsftpd** FTP server is installed and configured to allow anonymous access, but anonymous users cannot upload files to the incoming directory because SELinux is blocking the write. Enable the SELinux boolean that permits anonymous FTP write access, persistently, while SELinux remains in **Enforcing** mode.
