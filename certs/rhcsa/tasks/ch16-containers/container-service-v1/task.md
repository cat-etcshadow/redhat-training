## Run a container as a systemd service

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system. Create and run a container named **myapp** using `registry.access.redhat.com/ubi9/ubi` with a command that keeps it alive (`sleep infinity`), generate a systemd service unit for it installed system-wide, and enable and start the service so that **myapp** starts automatically at boot, active and enabled.
