## Configure a static IPv6 address

Your task:

1. Identify the name of the primary network connection.

2. Add a **static IPv6 address** to the primary connection:
   - Address: **{{IPV6_ADDR}}/{{IPV6_PREFIX}}**
   - Gateway: **{{IPV6_GW}}**
   - Method: **manual** (not auto/DHCP)

3. Bring the connection down and up to apply.

4. The configuration must be **persistent** (survive a reload of NetworkManager).
