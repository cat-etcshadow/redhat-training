## Configure a static IPv6 address

Your task:

1. Identify the name of the primary network connection (e.g. `eth0`, `ens3`).

2. Add a **static IPv6 address** to the primary connection:
   - Address: **{{IPV6_ADDR}}/{{IPV6_PREFIX}}**
   - Gateway: **{{IPV6_GW}}**
   - Method: **manual** (not auto/DHCP)

3. Bring the connection down and up to apply.

4. Verify the address is assigned with `ip -6 addr show`.
   The address **{{IPV6_ADDR}}** must appear with prefix **{{IPV6_PREFIX}}**.

5. The configuration must be **persistent** (survive a reload of NetworkManager).
