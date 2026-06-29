## Open a custom port in firewalld

Your task:

1. Add TCP port **{{TCP_PORT}}** to the **public** zone permanently.
2. Also open the UDP port range **{{UDP_START}}-{{UDP_END}}** permanently.
3. Reload firewalld and confirm both are listed in `firewall-cmd --list-all`.
