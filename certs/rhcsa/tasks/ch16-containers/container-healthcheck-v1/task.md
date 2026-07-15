## Run a container with a health check

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system. Run a detached container named **{{CONTAINER_NAME}}** from the `ubi9/ubi` image, kept running with `sleep infinity`, with a health check running `echo healthy` on a 2 second interval, a 2 second timeout, and 1 retry, such that the container's health status becomes healthy.
