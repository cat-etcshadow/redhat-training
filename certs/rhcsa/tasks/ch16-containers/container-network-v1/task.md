## Create a custom podman network and attach a container to it

The image `registry.access.redhat.com/ubi9/ubi` is already available on the system. Create a podman network named **{{NET_NAME}}** with subnet **{{SUBNET}}**, and run a detached container named **{{CONTAINER_NAME}}** from the `ubi9/ubi` image attached to **{{NET_NAME}}**, kept running with `sleep infinity`, such that its IP address falls within **{{SUBNET}}**.
