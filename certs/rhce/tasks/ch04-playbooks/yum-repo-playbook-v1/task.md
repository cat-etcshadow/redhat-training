## Configure Yum Repositories on Managed Hosts

Create a playbook **{{PLAYBOOK_FILE}}** that configures two yum repositories on all managed hosts:

**Repository 1 — BaseOS:**
- `name`: BaseOS
- `description`: Base OS Repo
- `baseurl`: `file:///mnt/BaseOS/`
- `gpgcheck`: yes
- `enabled`: no
- `gpgkey`: `file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release`

**Repository 2 — AppStream:**
- `name`: AppStream
- `description`: AppStream Repo
- `baseurl`: `file:///mnt/AppStream/`
- `gpgcheck`: yes
- `enabled`: no
- `gpgkey`: `file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release`

Requirements:
- The playbook targets **all** managed hosts
- Use the `ansible.builtin.yum_repository` module
- The playbook must pass `--syntax-check`
