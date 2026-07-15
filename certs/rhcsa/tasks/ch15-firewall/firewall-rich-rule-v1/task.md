## Create a firewalld rich rule to restrict SSH access by source IP

For security reasons SSH access should only be allowed from the management subnet **192.168.100.0/24**; all other SSH connections must be rejected. Remove the default **ssh** service from the public zone, and add permanent rich rules that allow SSH from **192.168.100.0/24** and reject SSH from all other sources, then reload firewalld.
