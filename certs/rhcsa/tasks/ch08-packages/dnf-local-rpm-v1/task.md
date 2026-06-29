## Install a package from a local RPM and configure a local repository

This simulates receiving an RPM from a vendor or installing from an ISO
without internet access.

### Part 1: Install from a local RPM file

A downloaded RPM file is already available in **{{LOCAL_RPM_DIR}}/**.

1. Install the package directly from the RPM file:
   ```
   dnf install {{LOCAL_RPM_DIR}}/<package>.rpm
   ```
   or equivalently:
   ```
   rpm -ivh {{LOCAL_RPM_DIR}}/<package>.rpm
   ```

2. Verify installation: `rpm -q {{LOCAL_PKG}}` should show the package version.

### Part 2: Configure a local file-based repository

3. The directory **{{LOCAL_REPO_DIR}}** contains RPM files. Create a local
   repository metadata from it:
   ```
   dnf install -y createrepo_c
   createrepo_c {{LOCAL_REPO_DIR}}
   ```

4. Create a repo file `/etc/yum.repos.d/rhtr-local.repo`:
   ```ini
   [rhtr-local]
   name=RHTR Local Repository
   baseurl=file://{{LOCAL_REPO_DIR}}
   enabled=1
   gpgcheck=0
   ```

5. Verify the repo is visible: `dnf repolist` should show `rhtr-local`.
