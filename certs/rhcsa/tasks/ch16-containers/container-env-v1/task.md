## Run a container with environment variables and port mapping

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system. Run a detached container named **{{CONTAINER_NAME}}** from the `ubi9/ubi` image with environment variable **{{ENV_KEY}}={{ENV_VAL}}**, host port **{{HOST_PORT}}** mapped to container port **8080**, and a command that keeps it running (`sleep infinity`).
