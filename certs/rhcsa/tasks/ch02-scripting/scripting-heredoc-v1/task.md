## Write a script that generates a config file using a here-document

Create an executable script at **{{SCRIPT_PATH}}** that accepts three arguments, `<user>` `<port>` `<config-dir>`, exiting **1** with a usage message if the count is wrong. It must create `<config-dir>` if it does not exist, then use a here-document (`<<EOF`) to write `<config-dir>/app.conf` with an `[app]` section containing the keys `user`, `port`, and `log_level` set from the argument values, with variable substitution occurring. On success it must print `Generated config in <config-dir>` and exit **0**.
