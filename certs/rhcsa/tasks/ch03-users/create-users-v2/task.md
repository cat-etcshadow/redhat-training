## Create users with password aging and group constraints

Perform the following user and group management tasks on **server**:

1. Create a group named **{{GROUP}}** with GID **{{GID}}**.

2. Create a user **{{USER1}}** with the following properties:
   - UID: **{{UID1}}**
   - Password: **{{PASSWORD}}**
   - Supplementary member of **{{GROUP}}**
   - Password must be changed every **{{MAX_AGE}}** days
   - User is warned **{{WARN_DAYS}}** days before the password expires
   - Account is locked **{{INACTIVE}}** days after the password expires without change

3. Create a user **{{USER2}}** with the following properties:
   - UID: **{{UID2}}**
   - Password: **{{PASSWORD}}**
   - Supplementary member of **{{GROUP}}**
   - Login shell: **/bin/sh**

4. Ensure that **{{USER2}}** cannot log in interactively using a password
   (the account should be locked after creation).

All settings must survive a reboot.
