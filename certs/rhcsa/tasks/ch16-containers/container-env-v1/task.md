## Run a container with environment variables and port mapping

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system.

Your task:

1. Run a detached container named **{{CONTAINER_NAME}}** from the `ubi9/ubi` image with:
   - Environment variable **{{ENV_KEY}}={{ENV_VAL}}**
   - Port mapping: host port **{{HOST_PORT}}** → container port **8080**
   - A command that keeps it running: `sleep infinity`
2. Verify:
   - `podman ps` shows **{{CONTAINER_NAME}}** running
   - The container has the correct environment variable set
