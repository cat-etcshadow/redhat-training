## Hint

- `podman build -t <image:tag> <build-context-dir>` — build using `Containerfile` in the dir
- `podman build -f /path/to/Containerfile -t <tag> .` — specify Containerfile explicitly
- `podman images` — list local images
- `podman run --rm <image>` — run and remove container after exit
- `podman image inspect <image>` — show full image metadata
- `FROM` must reference an image you can pull (or that is already local)
- `CMD` is the default command; override with `podman run <image> <override-cmd>`
