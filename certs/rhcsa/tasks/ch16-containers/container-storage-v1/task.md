## Mount host storage into a container

The image `registry.access.redhat.com/ubi9/ubi` is available on the system. Create a directory **/srv/container-data** on the host with an SELinux context that allows container access, and run a detached container named **datastore** from `registry.access.redhat.com/ubi9/ubi` with **/srv/container-data** mounted at **/data** inside it and a keep-alive command (`sleep infinity`), running with the bind mount visible.
