## Search registries and configure registry access

Your task:

1. **Search** for images matching **{{SEARCH_TERM}}** across configured registries
   and save the output to **{{REPORT_FILE}}**.

2. **Pull** the specific image **{{TARGET_IMAGE}}**.

3. **Tag** the pulled image with a local alias `local/ubi9:latest`.

4. Verify both names refer to the same image — they must show the **same IMAGE ID**.

5. Review `/etc/containers/registries.conf` and ensure `registry.access.redhat.com`
   is in `unqualified-search-registries`. Append the file content to **{{REPORT_FILE}}**.

6. List all local images and append to **{{REPORT_FILE}}**.
