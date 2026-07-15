## Create a shared directory with SGID and group ownership

On **server**, create a group named **webteam** (any GID is acceptable), then create the directory **/srv/webshared** owned by user **root** and group **webteam**, with permissions **rwxrwx---** (mode **0770**) and the setgid bit set so that new files created inside automatically inherit the **webteam** group. Create a user **webdev** as a supplementary member of **webteam**, such that a file created by **webdev** inside **/srv/webshared** gets group ownership **webteam** automatically.
