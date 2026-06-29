## Mount host storage into a container

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system.

Your task:

1. Create a directory **/srv/container-data** on the host.
2. Set the SELinux context on **/srv/container-data** to allow container access.
3. Run a detached container named **datastore** from `registry.access.redhat.com/ubi9/ubi`
   with **/srv/container-data** mounted at **/data** inside the container
   and a keep-alive command (`sleep infinity`).
4. Verify the container is running and the bind mount is visible with `podman inspect`.
