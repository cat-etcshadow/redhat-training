## Configure Network Interfaces with Ansible

Create a playbook **{{PLAYBOOK_FILE}}** that targets all hosts in the **dev** group and configures a static IP on a second network interface:

Create an Ethernet connection named `{{CONN_NAME}}` on device `{{DEVICE}}` with:
- IP address: `{{IP_ADDRESS}}`
- Gateway: `{{GATEWAY}}`
- DNS server: `{{DNS_SERVER}}`
- IPv4 method: `manual`
- Connection state: `present`

Requirements:
- Use `community.general.nmcli` module
- Set `type: ethernet`
- Use `become: true`
- The playbook must pass `--syntax-check`
