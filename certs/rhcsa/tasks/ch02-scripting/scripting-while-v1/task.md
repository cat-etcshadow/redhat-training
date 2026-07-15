## Write a script that reads a file line by line with while

The file **{{INPUT_FILE}}** contains one username per line. Create an executable script at **{{SCRIPT_PATH}}** that accepts one argument, the path to the user list file — exiting **1** with usage if the argument is missing or the file does not exist — and uses a `while read` loop to process the file line by line: for each username, if the user already exists print `SKIP: <name> already exists`; if the user does not exist, create it without a home directory and print `CREATED: <name>`. Exit **0** when done.
