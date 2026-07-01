## Create a custom podman network and attach a container to it

The image `registry.access.redhat.com/ubi9/ubi` is already available on the
system.

Your task:

1. Create a podman network named **{{NET_NAME}}** with subnet
   **{{SUBNET}}**.

2. Run a detached container named **{{CONTAINER_NAME}}** from the
   `ubi9/ubi` image, attached to **{{NET_NAME}}**, kept running with
   `sleep infinity`.

3. The container's IP address must fall within **{{SUBNET}}**.
