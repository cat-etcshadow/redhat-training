## Hint

- `ansible-doc ansible.posix.firewalld` — two distinct parameters: `service:` vs `port:`
- Port format must include the protocol: `8080/tcp`
- `permanent: true` persists the rule after reboot
- `immediate: true` applies the rule now without a reload/reboot
- Use both together so the rule is active immediately AND survives reboot
- `state: enabled` opens the service/port; `state: disabled` closes it
- `zone:` defaults to the default zone if omitted
