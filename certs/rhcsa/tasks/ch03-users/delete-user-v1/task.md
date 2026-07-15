## Delete a user account and clean up resources

The user **{{DEL_USER}}** is a former employee whose account must be removed. Delete the user along with their home directory, delete the group **{{DEL_GROUP}}** if it still exists, and remove any sudoers drop-in file for the user. Afterward, **{{DEL_USER}}** must no longer exist, `/home/{{DEL_USER}}` must be gone, and the group **{{DEL_GROUP}}** must no longer exist.
