## Write a script using a for loop

Create an executable script at **{{SCRIPT_PATH}}** that:

1. Accepts one argument: a **base directory** path.
   If no argument is provided, print usage to stderr and exit **1**.

2. Uses a **for loop** to create the following subdirectories inside the base directory:
   `logs`, `data`, `config`, `backups`, `tmp`

3. Inside each subdirectory, create a file named `README` containing the text:
   `This is the <name> directory`  (where `<name>` is the subdirectory name)

4. Print one line per created directory: `Created: <full-path>`

5. Exit **0** on success.

Example:
```
$ create_dirs.sh /srv/app
Created: /srv/app/logs
Created: /srv/app/data
Created: /srv/app/config
Created: /srv/app/backups
Created: /srv/app/tmp
```

Key construct:
```bash
for name in logs data config backups tmp; do
  mkdir -p "$base/$name"
  echo "This is the $name directory" > "$base/$name/README"
  echo "Created: $base/$name"
done
```
