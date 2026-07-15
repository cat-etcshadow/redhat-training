## Install a package from a local RPM and configure a local repository

A downloaded RPM file is already available in **{{LOCAL_RPM_DIR}}/**. The directory **{{LOCAL_REPO_DIR}}** contains additional RPM files. Install the package directly from the RPM file in **{{LOCAL_RPM_DIR}}/**, create local repository metadata from **{{LOCAL_REPO_DIR}}**, and create a repo file `/etc/yum.repos.d/rhtr-local.repo` named **rhtr-local** pointing at **{{LOCAL_REPO_DIR}}**, enabled, with GPG checking disabled.
