## Run a container with memory and CPU limits

The image `registry.access.redhat.com/ubi9/ubi` is already available on the
system.

Your task:

Run a detached container named **{{CONTAINER_NAME}}** from the `ubi9/ubi`
image, kept running with `sleep infinity`, with:

- A memory limit of **{{MEM_LIMIT}}**
- A CPU limit of **{{CPU_LIMIT}}** CPUs
