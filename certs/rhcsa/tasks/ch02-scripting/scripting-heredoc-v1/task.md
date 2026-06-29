## Write a script that generates files using here-documents

Create an executable script at **{{SCRIPT_PATH}}** that:

1. Accepts three arguments: `<user>` `<port>` `<config-dir>`.
   Exit **1** with usage if wrong count.

2. Creates `<config-dir>` if it does not exist.

3. Uses a **here-document** (`<<EOF`) to write `<config-dir>/app.conf`:
   ```
   [app]
   user = <user>
   port = <port>
   log_level = info
   pid_file = /run/<user>/app.pid
   ```
   Variable substitution must happen (do not quote `EOF`).

4. Uses a **quoted here-document** (`<<'EOF'`) to write `<config-dir>/app.env`
   with literal dollar signs (no substitution):
   ```
   APP_USER=$APP_USER
   APP_PORT=$APP_PORT
   APP_LOG=/var/log/app.log
   ```

5. Prints: `Generated config in <config-dir>`

6. Exit **0**.

Here-document syntax:
```bash
cat > /path/to/file <<EOF
content with $variable expansion
EOF

cat > /path/to/file <<'EOF'
content with literal \$no_expansion
EOF
```
