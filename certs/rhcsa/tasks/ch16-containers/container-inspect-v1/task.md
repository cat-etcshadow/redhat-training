## Inspect container images with podman inspect and skopeo

Your task:

1. **Pull** the image **{{IMAGE}}** if not already present:
   ```
   podman pull {{IMAGE}}
   ```

2. **Inspect the local image** with `podman inspect` and save the output to
   **{{REPORT_FILE}}**:
   ```
   podman inspect {{IMAGE}} > {{REPORT_FILE}}
   ```

3. **Inspect the remote image** without pulling it using `skopeo`:
   ```
   skopeo inspect docker://{{IMAGE}} >> {{REPORT_FILE}}
   ```
   Install skopeo if needed: `dnf install -y skopeo`

4. From `podman inspect`, find and note in **{{REPORT_FILE}}**:
   - The image **ID** (first 12 chars)
   - The **entrypoint** or **Cmd** (what runs by default)
   - The **OS** and **architecture**:
     ```
     podman inspect --format "OS: {{.Os}}  Arch: {{.Architecture}}" {{IMAGE}} >> {{REPORT_FILE}}
     ```

5. Verify: `{{REPORT_FILE}}` contains JSON from `podman inspect` and
   skopeo output with `Architecture` or `Digest` fields.
