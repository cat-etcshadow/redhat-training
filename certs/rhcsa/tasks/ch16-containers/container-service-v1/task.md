## Run a container as a systemd service using quadlet or generate systemd

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system.
Make a container start automatically with the system as a systemd service.

Your task:

1. Create and run a container named **myapp** using `registry.access.redhat.com/ubi9/ubi`
   with a command that keeps it alive (`sleep infinity`).
2. Generate a systemd service unit for the container and install it system-wide.
3. Enable and start the service so that **myapp** starts automatically at boot.
4. The service must be **active** and **enabled**.
