## Configure tmpfiles.d to manage a runtime directory

The application **myapp** needs a runtime directory at **/run/myapp** that:

- Is created at boot with owner **myapp** (user and group)
- Has permissions **0750**
- Is automatically removed if no files have been accessed for **10 days**

Your task:

1. Ensure the user and group **myapp** exist (create them if necessary).
2. Create a `tmpfiles.d` configuration that satisfies the requirements above.
3. Apply the configuration immediately without rebooting.
