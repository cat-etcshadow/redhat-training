## Allow httpd on a non-standard port via SELinux

Apache `httpd` needs to listen on port **{{HTTP_PORT}}**, which is not in the default SELinux `http_port_t` definition, while SELinux remains in **Enforcing** mode. Add TCP port **{{HTTP_PORT}}** to the SELinux `http_port_t` type, configure Apache to listen on **{{HTTP_PORT}}**, and ensure `httpd` is running and enabled.
