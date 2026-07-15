## Create users, group, and configure sudo access

On **server**, create a group named **{{GROUP}}** with GID **{{GID}}**, then create users **{{USER1}}** (UID **{{UID1}}**) and **{{USER2}}** (UID **{{UID2}}**), each with password **{{PASSWORD}}** and as a supplementary member of **{{GROUP}}**. Configure **{{USER1}}** to run any command as root via `sudo` without being prompted for a password. All settings must survive a reboot.
