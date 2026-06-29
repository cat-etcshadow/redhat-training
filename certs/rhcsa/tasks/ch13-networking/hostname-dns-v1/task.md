## Set hostname and configure DNS resolution

Your task:

1. Set the system hostname to **{{FQDN}}** persistently
   using `hostnamectl`.
2. Add a static `/etc/hosts` entry so that **{{FQDN}}**
   resolves to **{{IP_ADDR}}**.
3. Verify the hostname: `hostnamectl status` and `hostname -f` should
   both show **{{FQDN}}**.
