## Write a script that parses flags with getopts

Create an executable script at **{{SCRIPT_PATH}}** that backs up a file, parsing its options with **getopts**. It must accept the required flags `-s <source-file>` and `-d <dest-dir>`, printing a usage message to stderr and exiting **1** if either is missing, and exit **2** with an error to stderr if `<source-file>` does not exist. It must create `<dest-dir>` if it does not exist, copy `<source-file>` into it, then print `Backup complete` and exit **0** on success.
