## Hint

- Jinja2 `for` loop: `{% for host in groups['all'] %}` ... `{% endfor %}`
- Access another host's facts: `hostvars[host]['ansible_facts']['default_ipv4']['address']`
- For this to work, facts must be gathered for ALL hosts first (separate play or `gather_facts: true`)
- Template module: `ansible.builtin.template` — `src:` path to `.j2` file, `dest:` path on remote host
- Two-play pattern: play 1 gathers facts on all, play 2 deploys template on subset
- Use `ansible_facts['fqdn']` for the FQDN and `ansible_facts['hostname']` for short name
