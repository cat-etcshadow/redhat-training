## Hint

- `ansible-doc community.general.sefcontext` — parameters: `target`, `setype`, `state`
  - `target` is a regex: `'/srv/web(/.*)?'` to match the dir and all contents
- `ansible-doc ansible.posix.seboolean` — parameters: `name`, `state`, `persistent`
  - `state: yes` enables the boolean; `persistent: yes` survives reboot
- After `sefcontext`, you must run `restorecon` to apply the label on disk:
  ```yaml
  - name: Apply context
    ansible.builtin.command: restorecon -Rv /srv/web
  ```
- Task order: sefcontext → restorecon → seboolean
- `community.general` collection must be installed: `ansible-galaxy collection install community.general`
