## Delete a user account and clean up resources

The user **{{DEL_USER}}** is a former employee whose account must be removed.

Your task:

1. **Lock** the account.

2. **Delete** the user and their home directory.

3. **Delete** the group **{{DEL_GROUP}}** if it still exists.

4. **Remove** any sudoers drop-in for the user.

5. After cleanup, **{{DEL_USER}}** must no longer exist, `/home/{{DEL_USER}}`
   must be gone, and the group **{{DEL_GROUP}}** must no longer exist.
