## Inspect container images, local and remote

Pull the image **{{IMAGE}}** if not already present, inspect the local image and save the output to **{{REPORT_FILE}}**, then inspect the remote image without pulling it and append that output to **{{REPORT_FILE}}**. From the local image inspection, also append to **{{REPORT_FILE}}** the image ID (first 12 characters), the entrypoint or Cmd (what runs by default), and the OS and architecture.
