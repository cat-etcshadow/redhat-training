## Allow httpd to connect to network services via SELinux

The Apache web server is configured as a reverse proxy and needs to connect
to backend services on the network. SELinux is currently blocking these
outbound connections.

Your task:

1. Identify and enable the SELinux boolean that allows httpd to make
   outbound network connections — persistently.

2. SELinux must remain in **Enforcing** mode.
