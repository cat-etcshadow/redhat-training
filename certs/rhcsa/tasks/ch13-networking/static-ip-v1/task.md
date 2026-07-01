## Configure a static IP address with nmcli

The system currently uses DHCP on its primary NIC.

Your task:

1. Find the active NetworkManager connection.
2. Set a static IPv4 address: **10.0.0.50/24**
3. Set the default gateway: **10.0.0.1**
4. Set DNS servers: **8.8.8.8** and **1.1.1.1**
5. Set the connection to **manual** (not DHCP) and **autoconnect yes**.
6. Bring the connection up.

**Important**: Do not modify the loopback interface.
