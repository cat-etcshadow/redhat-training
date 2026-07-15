## Interact with a running container using exec and logs

The container **rhtr-execlogs** is running. Using `podman exec`, create the file **/tmp/{{MARKER_FILE}}** inside it containing the text `hello from exec`, and using `podman logs`, save the container's log output to **{{OUTPUT_FILE}}** on the host.
