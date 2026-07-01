## Inspect container images with podman inspect and skopeo

Your task:

1. **Pull** the image **{{IMAGE}}** if not already present.

2. **Inspect the local image** with `podman inspect` and save the output to
   **{{REPORT_FILE}}**.

3. **Inspect the remote image** without pulling it using `skopeo` and append
   the output to **{{REPORT_FILE}}**.

4. From `podman inspect`, find and append to **{{REPORT_FILE}}**:
   - The image **ID** (first 12 chars)
   - The **entrypoint** or **Cmd** (what runs by default)
   - The **OS** and **architecture**
