## Allow httpd on a non-standard port via SELinux

Apache `httpd` needs to listen on port **{{HTTP_PORT}}**, which is not in the default
SELinux `http_port_t` definition.

Your task:

1. Add TCP port **{{HTTP_PORT}}** to the SELinux `http_port_t` type.
2. Configure Apache to listen on **{{HTTP_PORT}}**.
3. Ensure `httpd` is running and enabled.

SELinux must remain in **Enforcing** mode.
