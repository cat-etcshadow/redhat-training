## Build a container image from a Containerfile

A build directory has been created at **{{BUILD_DIR}}** containing a `Containerfile`.

Your task:

1. Review the Containerfile in **{{BUILD_DIR}}/Containerfile**.

2. Build the image using `podman build`, tagging it as **{{IMAGE_TAG}}**:
   ```
   podman build -t {{IMAGE_TAG}} {{BUILD_DIR}}
   ```

3. Verify the image exists:
   ```
   podman images | grep {{IMAGE_TAG}}
   ```

4. Run a container from your image to confirm it works:
   ```
   podman run --rm {{IMAGE_TAG}}
   ```
   The container should print the expected message and exit cleanly.

### Containerfile reference

A Containerfile (also called Dockerfile) is a text file with instructions:
```
FROM <base-image>          # starting image
RUN <command>              # run command during build
COPY <src> <dest>          # copy files into the image
ENV KEY=value              # set environment variable
EXPOSE <port>              # document a port
CMD ["cmd", "arg"]         # default command when container starts
ENTRYPOINT ["cmd"]         # fixed entrypoint (CMD provides args)
LABEL key=value            # metadata
```
