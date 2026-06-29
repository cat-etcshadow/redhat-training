## Hint

- `nmcli connection show` lists all connections; `nmcli device status` shows devices
- `nmcli connection modify <conn> ipv6.method manual ipv6.addresses <addr>/<prefix>`
- Set the gateway: `nmcli connection modify <conn> ipv6.gateway <gw>`
- Apply: `nmcli connection up <conn>` (or `nmcli device reapply <dev>`)
- Verify: `ip -6 addr show` or `nmcli connection show <conn> | grep ipv6`
- IPv6 uses `::` notation: `2001:db8::1` is short for `2001:0db8:0000:0000:0000:0000:0000:0001`
- `/64` is the most common prefix length for LAN segments
