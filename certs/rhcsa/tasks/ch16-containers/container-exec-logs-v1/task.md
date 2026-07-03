## Interact with a running container using exec and logs

The container **rhtr-execlogs** is running.

Your task:

1. Using `podman exec`, create the file **/tmp/{{MARKER_FILE}}** inside
   the running **rhtr-execlogs** container, containing the text
   `hello from exec`.
2. Using `podman logs`, retrieve the container's log output and save it
   to **{{OUTPUT_FILE}}** on the host.
