## Run a container from a local image and inspect it

The image `registry.access.redhat.com/ubi9/ubi` is available on the system. Run a detached, rootless container named **webserver** from `registry.access.redhat.com/ubi9/ubi`, with host port **8080** mapped to container port **80**, environment variable **APP_ENV=production**, and a keep-alive command (`sleep infinity`).
