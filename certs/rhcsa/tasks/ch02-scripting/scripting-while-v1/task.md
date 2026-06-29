## Write a script that reads a file line by line with while

The file **{{INPUT_FILE}}** contains one username per line.

Create an executable script at **{{SCRIPT_PATH}}** that:

1. Accepts one argument: the path to the user list file.
   Exit **1** with usage if argument is missing or the file does not exist.

2. Uses a **`while read`** loop to process the file line by line.

3. For each username in the file:
   - If the user **already exists**, print: `SKIP: <name> already exists`
   - If the user **does not exist**, create it with `useradd -M` and print: `CREATED: <name>`

4. Exit **0** when done.

The idiomatic while-read pattern:
```bash
while IFS= read -r username; do
  # process $username
done < "$input_file"
```

> `IFS=` prevents stripping leading/trailing whitespace; `-r` prevents backslash
> interpretation. This is the correct way to read files in bash scripts.
