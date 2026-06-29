## Write a script with if/elif/else

Create an executable shell script at **{{SCRIPT_PATH}}** that:

1. Accepts exactly **one argument** (a username). If no argument is given, print
   `Usage: check_user.sh <username>` to stderr and exit with code **1**.

2. If the user **exists** on the system:
   - Print: `User <name> exists with UID <uid>`
   - Exit with code **0**

3. If the user **does not exist**:
   - Print: `User <name> does not exist`
   - Exit with code **2**

The script must be **executable** (`chmod +x`).

Example output:
```
$ check_user.sh root
User root exists with UID 0

$ check_user.sh nobody123
User nobody123 does not exist

$ check_user.sh
Usage: check_user.sh <username>
```
