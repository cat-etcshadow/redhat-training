## Write a script using a for loop

Create an executable script at **{{SCRIPT_PATH}}** that accepts one argument, a base directory path — printing usage to stderr and exiting **1** if none is provided. Using a for loop, it must create the subdirectories `logs`, `data`, `config`, `backups`, and `tmp` inside the base directory, create a file named `README` in each containing `This is the <name> directory` (where `<name>` is the subdirectory name), print `Created: <full-path>` for each directory, and exit **0** on success.
