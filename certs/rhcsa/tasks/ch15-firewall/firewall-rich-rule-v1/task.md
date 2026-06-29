## Create a firewalld rich rule to restrict SSH access by source IP

For security reasons SSH access should only be allowed from the
management subnet **192.168.100.0/24**. All other SSH connections
must be rejected.

Your task:

1. Remove the default **ssh** service from the public zone.
2. Add a **rich rule** that allows SSH only from **192.168.100.0/24**.
3. Add a **rich rule** that rejects SSH from all other sources.
4. Make both rules permanent and reload firewalld.
