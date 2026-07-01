## Add a repository with dnf config-manager

A local package repository is available at **{{REPO_URL}}**.

Your task:

1. Add this repository using `dnf config-manager --add-repo`.

2. Disable GPG checking for this repository (`gpgcheck=0`).

3. Install **{{PKG}}** from this repository.
