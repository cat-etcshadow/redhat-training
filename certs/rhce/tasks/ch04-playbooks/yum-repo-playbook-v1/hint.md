## Hint

- Module: `ansible.builtin.yum_repository`
- Key parameters: `name`, `description`, `baseurl`, `gpgcheck` (yes/no), `enabled` (yes/no), `gpgkey`
- `enabled: no` means the repo is configured but not active by default
- `gpgcheck: yes` requires a valid `gpgkey` URL
- `ansible-doc ansible.builtin.yum_repository` — full module documentation
- `become: true` is needed to write to `/etc/yum.repos.d/`
