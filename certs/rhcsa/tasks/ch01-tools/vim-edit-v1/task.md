## Edit a configuration file with a text editor

The file `{{CONF_FILE}}` contains placeholder values that must be updated.

Using a text editor (`vim` or `nano`), make the following changes:

1. Set `HOSTNAME` to `{{NEW_HOSTNAME}}`
2. Set `LISTEN_PORT` to `{{LISTEN_PORT}}`
3. Set `TIMEOUT` to `{{TIMEOUT_VAL}}`
4. Change `DEBUG=true` to `DEBUG=false`

Save the file when done. The grader will verify each key=value pair exactly.
