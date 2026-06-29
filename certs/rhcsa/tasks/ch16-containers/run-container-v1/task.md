## Run a container from a local image and inspect it

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system.

Your task:

1. Install **podman** if not already present.
2. Run a detached container named **webserver** from `registry.access.redhat.com/ubi9/ubi`, with:
   - Port **8080** on the host mapped to port **80** in the container
   - Environment variable **APP_ENV=production**
   - A keep-alive command: `sleep infinity`
3. Verify the container is running with `podman ps`.
4. Run the container as a **rootless** container (as your regular user).

**For this lab**: running as root is acceptable if no non-root user is available.
