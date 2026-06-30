## Hint

- `ansible.builtin.archive`: compresses files/dirs on the **remote** host
  - `path:` source file or directory
  - `dest:` destination archive path on the remote host
  - `format:` gz, bz2, xz, zip, tar
- `ansible.builtin.fetch`: copies files **from** the remote host **to** the control node
  - `src:` path on the remote host
  - `dest:` path on the control node
  - `flat: false` (default): preserves `hostname/path` structure under dest
  - `flat: true`: copies directly to dest (useful for single-host)
- `{{ inventory_hostname }}` resolves to the current host's name — useful for unique dest paths
- `become: true` required for reading `/etc/ssh/` (contains private keys)
