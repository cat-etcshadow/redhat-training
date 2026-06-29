## Create a shared directory with SGID and group ownership

Perform the following tasks on **server**:

1. Create a group named **webteam** (accept any GID).

2. Create the directory **/srv/webshared** with these properties:
   - Owned by user **root** and group **webteam**
   - Permissions: **rwxrwx---** (mode **0770**)
   - The **setgid** bit must be set so that new files created inside
     the directory automatically inherit the **webteam** group

3. Create a user **webdev** and make them a supplementary member of **webteam**.

Verify that a file created by **webdev** inside **/srv/webshared** gets
group ownership **webteam** automatically.
