## Configure a static IP address with nmcli

The system's primary NIC currently uses DHCP. Target values are in **/root/rhtr-static-ip-target.txt** (`STATIC_IP`, `GATEWAY`). Configure the NIC with that static IPv4 address, that gateway, DNS servers **8.8.8.8** and **1.1.1.1**, set to autoconnect on boot.
