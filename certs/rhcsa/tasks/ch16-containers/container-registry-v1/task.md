## Search registries and configure registry access

Your task:

1. **Search** for images matching **{{SEARCH_TERM}}** across configured registries:
   ```
   podman search {{SEARCH_TERM}} | head -20
   ```
   Save the output to **{{REPORT_FILE}}**.

2. **Pull** the specific image **{{TARGET_IMAGE}}**:
   ```
   podman pull {{TARGET_IMAGE}}
   ```

3. **Tag** the pulled image with a local alias `local/ubi9:latest`:
   ```
   podman tag {{TARGET_IMAGE}} local/ubi9:latest
   ```

4. Verify both names refer to the same image:
   ```
   podman images | grep -E '{{SEARCH_TERM}}|local/ubi9'
   ```
   Both must show the **same IMAGE ID**.

5. Review and understand `/etc/containers/registries.conf`:
   - This file configures which registries `podman search` and short-name resolution use
   - Add `registry.access.redhat.com` to `unqualified-search-registries` if not present:
   ```
   # /etc/containers/registries.conf
   unqualified-search-registries = ["registry.access.redhat.com", "docker.io"]
   ```
   Append the current content of `registries.conf` to **{{REPORT_FILE}}**.

6. List all local images: `podman images >> {{REPORT_FILE}}`.
