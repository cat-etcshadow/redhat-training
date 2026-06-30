## Hint

- `ansible-doc community.general.nmcli` — key parameters:
  - `conn_name:` — connection profile name
  - `ifname:` — network device name
  - `type: ethernet`
  - `ip4:` — IP with prefix, e.g. `192.168.100.10/24`
  - `gw4:` — gateway IP
  - `dns4:` — list of DNS servers, e.g. `["192.168.1.1"]`
  - `method4: manual` — disables DHCP
  - `state: present`
- `dns4` takes a YAML list, not a plain string
- This task creates the connection profile; it does not bring up the interface (that requires `state: up`)
