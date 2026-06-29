## Hint

- `podman pull <image>` — download image to local storage
- `podman inspect <image>` — full JSON metadata for a local image
- `podman inspect --format '{{.Os}}' <image>` — Go template for specific field
- `skopeo inspect docker://<image>` — inspect remote image without pulling
- `skopeo inspect --raw docker://<image>` — raw manifest JSON
- `podman images` — list local images with IDs
- `jq '.[0].Id' <<< "$(podman inspect <image>)"` — extract field with jq (if installed)
