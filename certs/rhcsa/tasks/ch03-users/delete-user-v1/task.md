## Delete a user account and clean up resources

The user **{{DEL_USER}}** is a former employee whose account must be removed.

Your task:

1. **Lock** the account first (good practice before deletion).

2. **Delete** the user and their home directory.

3. **Delete** the group **{{DEL_GROUP}}** if it still exists.

4. **Remove** any sudoers drop-in for the user.

5. Verify:
   - `id {{DEL_USER}}` should return a non-zero exit code (user not found)
   - `/home/{{DEL_USER}}` should not exist
   - `getent group {{DEL_GROUP}}` should return nothing
