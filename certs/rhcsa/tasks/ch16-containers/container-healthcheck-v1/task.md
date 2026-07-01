## Run a container with a health check

The image `registry.access.redhat.com/ubi9/ubi` is already available on the
system.

Your task:

1. Run a detached container named **{{CONTAINER_NAME}}** from the `ubi9/ubi`
   image, kept running with `sleep infinity`.

2. Configure a health check on the container:
   - Command: `echo healthy`
   - Interval: **2 seconds**
   - Timeout: **2 seconds**
   - Retries: **1**

3. The container's health status must become **healthy**.
