## Write a script using an until loop to poll for a file

Create an executable script at **{{SCRIPT_PATH}}** that waits for a file to
appear.

Requirements:

1. Accepts one argument: the path to the file to wait for.
   If no argument is provided, print usage to stderr and exit non-zero.

2. Uses an **until loop** to repeatedly check whether the file exists,
   sleeping 1 second between checks, printing a progress line each attempt
   (e.g. `Waiting... (<attempt>/<max>)`).

3. Gives up after **5** attempts: print an error containing the word
   "Timeout" to stderr and exit non-zero.

4. As soon as the file appears, print a line containing the word "found"
   and exit **0**.
