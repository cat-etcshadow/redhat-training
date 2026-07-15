## Allow httpd to connect to network services via SELinux

The Apache web server is configured as a reverse proxy and needs to connect to backend services on the network, but SELinux is currently blocking these outbound connections. Enable the SELinux boolean that allows httpd to make outbound network connections, persistently, while SELinux remains in **Enforcing** mode.
