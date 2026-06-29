## Delete a user account and clean up resources

The user **{{DEL_USER}}** is a former employee whose account must be removed.

Your task:

1. **Lock** the account first (good practice before deletion):
   ```
   usermod -L {{DEL_USER}}
   ```

2. **Delete** the user and their home directory:
   ```
   userdel -r {{DEL_USER}}
   ```
   The `-r` flag removes the home directory (`/home/{{DEL_USER}}`) and mail spool.

3. **Delete** the group **{{DEL_GROUP}}** if it still exists:
   ```
   groupdel {{DEL_GROUP}}
   ```

4. **Remove** any sudoers drop-in for the user:
   ```
   rm -f /etc/sudoers.d/{{DEL_USER}}
   ```

5. Verify:
   - `id {{DEL_USER}}` should return a non-zero exit code (user not found)
   - `/home/{{DEL_USER}}` should not exist
   - `getent group {{DEL_GROUP}}` should return nothing
