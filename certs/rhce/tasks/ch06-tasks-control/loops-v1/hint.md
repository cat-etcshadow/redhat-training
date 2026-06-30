## Hint

- `loop:` is a list under the task — each item is available as `{{ item }}`
- Package loop example:
  ```yaml
  - name: Install packages
    ansible.builtin.dnf:
      name: "{{ item }}"
      state: present
    loop:
      - httpd
      - firewalld
  ```
- User creation uses the same pattern with `ansible.builtin.user` and `name: "{{ item }}"`
- `ansible-doc ansible.builtin.dnf` — check the `name` and `state` parameters
- `ansible-doc ansible.builtin.user` — check the `name` and `state` parameters
- Do not use `with_items` — it is deprecated; use `loop:` instead
