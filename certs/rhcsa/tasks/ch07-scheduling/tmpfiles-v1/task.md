## Configure tmpfiles.d to manage a runtime directory

The application **myapp** needs a runtime directory at **/run/myapp** that is created at boot with owner and group **myapp**, has permissions **0750**, and is automatically removed if no files have been accessed for **10 days**. Ensure the user and group **myapp** exist, create a `tmpfiles.d` configuration that satisfies these requirements, and apply it immediately without rebooting.
