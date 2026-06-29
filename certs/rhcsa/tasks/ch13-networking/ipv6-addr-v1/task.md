## Configure a static IPv6 address

Your task:

1. Identify the name of the primary network connection (e.g. `eth0`, `ens3`):
   ```
   nmcli connection show
   ```

2. Add a **static IPv6 address** to the primary connection:
   - Address: **{{IPV6_ADDR}}/{{IPV6_PREFIX}}**
   - Gateway: **{{IPV6_GW}}**
   - Method: **manual** (not auto/DHCP)
   ```
   nmcli connection modify <conn> ipv6.method manual \
     ipv6.addresses {{IPV6_ADDR}}/{{IPV6_PREFIX}} \
     ipv6.gateway {{IPV6_GW}}
   ```

3. Bring the connection down and up to apply:
   ```
   nmcli connection down <conn> && nmcli connection up <conn>
   ```

4. Verify the address is assigned:
   ```
   ip -6 addr show
   ```
   The address **{{IPV6_ADDR}}** must appear with prefix **{{IPV6_PREFIX}}**.

5. The configuration must be **persistent** (survive a reload of NetworkManager).

> Note: IPv6 addresses use the format `::` as a shorthand for consecutive zero groups.
> `2001:db8:1::10/64` is a valid full IPv6 address.
