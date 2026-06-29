## Hint

- Use `ls -Z /var/www/html/secure/` to see the current SELinux contexts
- `semanage fcontext -a -t httpd_sys_content_t '/var/www/html/secure(/.*)?'`
  adds a persistent policy rule
- `restorecon -Rv /var/www/html/secure/` applies the policy rule to existing files
- `chcon` changes the context temporarily — it does **not** survive a `restorecon`
  run and is not the correct solution
