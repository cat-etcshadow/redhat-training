## Write a script that generates files using here-documents

Create an executable script at **{{SCRIPT_PATH}}** that:

1. Accepts three arguments: `<user>` `<port>` `<config-dir>`.
   Exit **1** with usage if wrong count.

2. Creates `<config-dir>` if it does not exist.

3. Uses a **here-document** (`<<EOF`) to write `<config-dir>/app.conf` with an
   `[app]` section containing keys `user`, `port`, `log_level`, and `pid_file`
   (using the argument values; variable substitution must occur).

4. Uses a **quoted here-document** (`<<'EOF'`) to write `<config-dir>/app.env`
   with literal dollar signs (no substitution), defining variables `APP_USER`,
   `APP_PORT`, and `APP_LOG`.

5. Prints: `Generated config in <config-dir>`

6. Exit **0**.
