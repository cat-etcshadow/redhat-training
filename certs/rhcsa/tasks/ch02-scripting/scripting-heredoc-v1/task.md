## Write a script that generates a config file using a here-document

Create an executable script at **{{SCRIPT_PATH}}** that:

1. Accepts three arguments: `<user>` `<port>` `<config-dir>`.
   Exit **1** with usage if wrong count.

2. Creates `<config-dir>` if it does not exist.

3. Uses a **here-document** (`<<EOF`) to write `<config-dir>/app.conf` with an
   `[app]` section containing keys `user`, `port`, and `log_level`
   (using the argument values; variable substitution must occur).

4. Prints: `Generated config in <config-dir>`

5. Exit **0**.
