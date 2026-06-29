## Create users, group, and configure sudo access

Perform the following user and group management tasks on **server**:

1. Create a group named **{{GROUP}}** with GID **{{GID}}**.

2. Create a user **{{USER1}}** with the following properties:
   - UID: **{{UID1}}**
   - Password: **{{PASSWORD}}**
   - Supplementary member of **{{GROUP}}**

3. Create a user **{{USER2}}** with the following properties:
   - UID: **{{UID2}}**
   - Password: **{{PASSWORD}}**
   - Supplementary member of **{{GROUP}}**

4. Configure **{{USER1}}** to run any command as root using `sudo`
   **without being prompted for a password**.

All settings must survive a reboot.
