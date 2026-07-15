## Search registries and configure registry access

Search for images matching **{{SEARCH_TERM}}** across configured registries and save the output to **{{REPORT_FILE}}**, pull the image **{{TARGET_IMAGE}}**, and tag it with the local alias `local/ubi9:latest` such that both names resolve to the same image ID. Ensure `/etc/containers/registries.conf` has `registry.access.redhat.com` in `unqualified-search-registries`, and append that file's content and a full listing of local images to **{{REPORT_FILE}}**.
