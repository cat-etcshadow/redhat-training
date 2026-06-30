## Enable a disabled DNF repository and install a package

A repository named **extras** has been configured on the system but is
currently **disabled**.

Your task:

1. Identify the disabled repository.
2. Enable the **extras** repository persistently.
3. Install the package **epel-release** from that repository.

The repository must remain enabled after a reboot.

> **Lab note:** The simulated `extras` repo in this environment uses a local
> file path and does not contain `epel-release`. The grader only checks that
> the repo is persistently enabled — the package install step is for practice
> with real RHEL repos where epel-release is available.
