# redhat-training — implementation tracker

Check off items as they are completed. Phases are sequential; tasks within a phase
can be parallelised. Do not start Phase N+1 until Phase N is done.

---

## Phase 0 — Repo hygiene ✓

- [x] Confirm final repo name / GitHub remote (`cat-etcshadow/redhat-training`)
- [x] `.gitignore` — cover `.state/`, `*.qcow2`, editor files
- [x] Repo skeleton: `bin/`, `lib/`, `certs/`, skeleton `certs/rhcsa/`, `certs/rhce/`

---

## Phase 1 — Core CLI + lib (cert-agnostic) ✓

These files contain no RHCSA- or RHCE-specific logic.

- [x] `bin/rhtr` — entry point: resolves `RHTR_DIR` via symlink, sources lib, dispatches `<cert> <cmd>`
- [x] `lib/core.sh` — `die`, `log`, `info`, `warn`, color helpers, `rhtr_require_state`
- [x] `lib/vm.sh` — `vm_create`, `vm_destroy`, `vm_exec_script`, `vm_snapshot_create`,
      `vm_snapshot_restore`, `vm_wait_ready`, `vm_shell`, `vm_exists`, `vm_running`
- [x] `lib/select.sh` — `select_tasks` (dispatches to random weighted / fixed / topic),
      `select_random_from_topic`, `select_topic_all`, version filtering via `RHEL_VERSIONS`
- [x] `lib/exam.sh` — `cmd_new`, `cmd_train`, `cmd_shell`, `cmd_grade`, `cmd_reset`,
      `cmd_destroy`, `cmd_status`, `cmd_hint`, `display_exam`, timer logic
- [x] `lib/report.sh` — `grade_all_tasks`, `print_score`, `print_task_row`, report table
- [x] `lib/progress.sh` — `progress_record`, `progress_read`, `cmd_progress`
      writes/reads `~/.local/share/redhat-training/progress/<cert>/<task>.json`
- [x] `lib/list.sh` — `cmd_list_certs`, `cmd_list_topics`, `cmd_list_tasks` (with filters),
      `cmd_list_profiles`, `cmd_list_fixed`, `cmd_show_task`

---

## Phase 2 — RHCSA cert definition ✓

- [x] `certs/rhcsa/cert.conf` — CERT_NAME, EXAM_CODE, PASS_THRESHOLD=70,
      DEFAULT_DURATION=150, DEFAULT_RHEL_VERSION=9, RHEL_VERSIONS="8 9 10"
- [x] `certs/rhcsa/topology.sh` — `topology_create`: VM `rhtr-rhcsa-server-<ver>` +
      4 GB block disk; `topology_destroy`: delete VM + volume

---

## Phase 3 — RHCSA task library ✓

Each task needs: `meta.sh`, `task.md`, `setup.sh`, `grade.sh`.
`hint.md` and `solution.sh` are optional but should be added from the start where possible.

### ch01 — Essential Tools
- [x] `archive-compress-v1` — create and extract gzip tar archive
- [x] `archive-compress-v2` — create and extract bzip2/xz tar archive (randomised format)
- [x] `links-v1` — create hard link and symbolic link, verify inode sharing
- [x] `find-files-v1` — use find with -type and -name to locate files, save to output file
- [x] `find-exec-v1` — use find -exec to fix world-writable permissions recursively
- [x] `grep-regex-v1` — grep -ri for errors and grep -rE for IPv4 addresses in log files
- [x] `grep-extended-v1` — grep to filter /etc/passwd-format file, cut to extract usernames
- [x] `scp-transfer-v1` — scp file to localhost, rsync directory; SSH key pre-configured

### ch02 — Shell Scripting
- [x] `scripting-if-v1` — write check_user.sh: if/elif/else, id check, specific exit codes
- [x] `scripting-for-list-v1` — write create_dirs.sh: for loop over literal list, mkdir + README
- [x] `scripting-for-files-v1` — write archive_logs.sh: for loop over find output, gzip each .log
- [x] `scripting-while-v1` — write create_users_from_file.sh: while IFS= read -r, useradd
- [x] `scripting-args-v1` — write backup_file.sh: $1/$2/$#, -f/-r/-d tests, timestamp suffix
- [x] `scripting-case-v1` — write svc_ctl.sh: case statement for start/stop/restart/status/enable
- [x] `scripting-functions-v1` — write disk_report.sh: named functions, --output flag, mountpoint check
- [x] `scripting-heredoc-v1` — write gen_config.sh: heredoc with/without variable expansion

### ch03 — Manage Local Users and Groups
- [x] `create-users-v1` — create two users with specific UIDs, group with GID, sudo NOPASSWD
- [x] `create-users-v2` — different users/UIDs, password aging constraint
- [x] `sudo-nopasswd-v1` — pre-existing user, configure sudoers drop-in for specific command
- [x] `password-aging-v1` — set max age, warning days, inactive period for existing user
- [x] `group-membership-v1` — change primary group, add supplementary groups
- [x] `delete-user-v1` — lock account, userdel -r, groupdel, remove sudoers drop-in

### ch04 — Control Access to Files
- [x] `setgid-dir-v1` — create directory with SGID, correct group ownership and mode
- [x] `sticky-bit-v1` — SGID + sticky bit on shared dir, mode 3770
- [x] `acl-v1` — set named ACL entries on a directory, verify with getfacl
- [x] `umask-v1` — set persistent per-user and system-wide umask
- [x] `fix-perms-v1` — diagnose and correct broken web root permissions (chgrp -R, find -exec chmod)

### ch05 — Manage SELinux Security
- [x] `fix-file-context-v1` — wrong context on /var/www/html subdir, fix with semanage + restorecon
- [x] `fix-file-context-v2` — wrong context on custom service data dir
- [x] `boolean-httpd-v1` — enable httpd_can_network_connect boolean persistently
- [x] `boolean-nfs-v1` — enable SELinux boolean for NFS home dirs
- [x] `troubleshoot-audit-v1` — find SELinux denial in audit log, identify boolean fix
- [x] `selinux-port-v1` — add non-standard port to http_port_t, configure Apache
- [x] `selinux-mode-v1` — setenforce 0/1, persist SELINUX=enforcing in config, ls -Z output

### ch06 — Tune System Performance
- [x] `tuned-profile-v1` — set and activate a specific tuned profile persistently
- [x] `process-priority-v1` — renice a running process, launch process with specific nice value

### ch07 — Schedule Future Tasks
- [x] `at-job-v1` — schedule one-time job with at
- [x] `cron-job-v1` — create cron entry for a user to run script at specific time
- [x] `systemd-timer-v1` — create a systemd timer unit for a recurring task
- [x] `tmpfiles-v1` — configure tmpfiles.d to create/clean a directory on boot

### ch08 — Install and Update Software Packages
- [x] `dnf-install-v1` — install a package, verify with rpm -q
- [x] `dnf-group-v1` — install a package group
- [x] `dnf-module-v1` — enable a nodejs module stream, install from it
- [x] `repo-enable-v1` — enable a disabled DNF repo, install package from it
- [x] `dnf-local-rpm-v1` — install from local .rpm file; configure local file:// repo with createrepo_c

### ch09 — Manage Basic Storage
- [x] `add-partition-xfs-v1` — partition disk (MBR), format XFS, mount persistently at /mnt/data
- [x] `add-partition-ext4-v1` — partition disk (MBR), format ext4, mount persistently
- [x] `add-partition-gpt-v1` — partition disk with GPT (parted), format XFS, fstab by UUID
- [x] `add-partition-vfat-v1` — partition disk, format vfat/FAT32, fstab with 0 0 fsck fields
- [x] `swap-partition-v1` — create swap partition, activate persistently
- [x] `persistent-mount-uuid-v1` — update /etc/fstab to use UUID instead of device path
- [x] `persistent-mount-label-v1` — mount by filesystem label

### ch10 — Manage Storage Stack (LVM)
- [x] `create-lv-v1` — PV on extra disk, VG vg_data, LV lv_storage, format XFS, mount at /mnt/storage
- [x] `extend-lv-v1` — extend existing LV by 300 MB online without data loss
- [x] `lv-ext4-v1` — create LV, format ext4, mount persistently
- [x] `stratis-pool-v1` — create Stratis pool + filesystem, fstab with x-systemd.requires (RHEL_VERSIONS="9 10")

### ch11 — Control Services and Boot Process
- [x] `reset-root-password-v1` — root locked, candidate resets via rd.break to known value
- [x] `boot-target-v1` — switch default boot target to multi-user.target
- [x] `repair-fstab-v1` — broken /etc/fstab entry prevents boot, fix in emergency shell
- [x] `service-enable-v1` — ensure a service is enabled and running after reboot
- [x] `grub-param-v1` — add kernel parameter with grubby

### ch12 — Analyze and Store Logs
- [x] `journald-persistent-v1` — configure journald to persist logs across reboots
- [x] `journald-size-v1` — set journald Storage=persistent and SystemMaxUse
- [x] `rsyslog-rule-v1` — add rsyslog rule to forward specific facility to a file
- [x] `chrony-server-v1` — configure chrony NTP client with specific server

### ch13 — Manage Networking
- [x] `hostname-dns-v1` — set static hostname, add /etc/hosts entry
- [x] `static-ip-v1` — configure second NIC with static IP via nmcli (requires topology 2nd NIC)
- [x] `nmcli-bond-v1` — create network bond (RHEL_VERSIONS="8 9 10")
- [x] `routing-v1` — add persistent static route via nmcli
- [x] `ipv6-addr-v1` — assign static IPv6 address via nmcli, method manual, persist
- [x] `ssh-key-auth-v1` — generate RSA key pair, configure authorized_keys, functional test

### ch14 — Access Network-Attached Storage
- [x] `nfs-mount-v1` — mount NFS share persistently (fstab checked; server not required in lab)
- [x] `nfs-export-v1` — configure NFS server export
- [x] `autofs-v1` — configure autofs for indirect NFS mounts

### ch15 — Manage Network Security
- [x] `firewall-add-service-v1` — add http + https services permanently to firewalld
- [x] `firewall-add-port-v1` — open a specific TCP port permanently
- [x] `firewall-rich-rule-v1` — add a rich rule allowing specific source IP
- [x] `firewall-zone-v1` — assign interface to zone, set zone default

### ch16 — Run Containers
- [x] `run-container-v1` — pull and run container with podman, map port
- [x] `container-env-v1` — run container with env vars and port mapping
- [x] `container-service-v1` — run container as root systemd service via podman generate systemd
- [x] `container-storage-v1` — run container with persistent bind-mount volume
- [x] `container-build-v1` — build image from Containerfile with podman build, verify output
- [x] `container-user-service-v1` — rootless container as user systemd service; loginctl enable-linger
- [x] `container-inspect-v1` — podman inspect + skopeo inspect, save JSON/output to report file
- [x] `container-registry-v1` — podman search, pull, tag image, review registries.conf

---

## Phase 4 — RHCSA exam profiles and fixed exams ✓

- [x] `certs/rhcsa/exams/profiles/full.conf` — balanced draw across all chapters, ~120 pts, 120 min
- [x] `certs/rhcsa/exams/profiles/topic-tools.conf`
- [x] `certs/rhcsa/exams/profiles/topic-scripting.conf`
- [x] `certs/rhcsa/exams/profiles/topic-users.conf`
- [x] `certs/rhcsa/exams/profiles/topic-permissions.conf`
- [x] `certs/rhcsa/exams/profiles/topic-selinux.conf`
- [x] `certs/rhcsa/exams/profiles/topic-performance.conf`
- [x] `certs/rhcsa/exams/profiles/topic-scheduling.conf`
- [x] `certs/rhcsa/exams/profiles/topic-packages.conf`
- [x] `certs/rhcsa/exams/profiles/topic-storage.conf`
- [x] `certs/rhcsa/exams/profiles/topic-lvm.conf`
- [x] `certs/rhcsa/exams/profiles/topic-boot.conf`
- [x] `certs/rhcsa/exams/profiles/topic-logging.conf`
- [x] `certs/rhcsa/exams/profiles/topic-networking.conf`
- [x] `certs/rhcsa/exams/profiles/topic-nfs.conf`
- [x] `certs/rhcsa/exams/profiles/topic-firewall.conf`
- [x] `certs/rhcsa/exams/profiles/topic-containers.conf`
- [x] `certs/rhcsa/exams/fixed/full-v1.conf` — first curated fixed exam
- [x] `certs/rhcsa/exams/fixed/full-v2.conf` — second curated fixed exam (different variants)

---

## Phase 5 — End-to-end RHCSA validation

- [ ] `rhtr rhcsa new --rhel 9 --profile full` completes without error
- [ ] `rhtr rhcsa shell` opens VM shell
- [ ] `rhtr rhcsa grade` grades all tasks, produces score table
- [ ] `rhtr rhcsa reset` restores snapshot and re-applies setups
- [ ] `rhtr rhcsa destroy` removes VMs and clears state
- [ ] `rhtr rhcsa list-tasks --rhel 8` filters correctly
- [ ] `rhtr rhcsa progress` shows training history
- [ ] Test `--rhel 8` and `--rhel 10` end to end (after images available)

---

## Phase 6 — RHCE cert definition

- [ ] `certs/rhce/cert.conf` — PASS_THRESHOLD=70, DEFAULT_DURATION=240, RHEL_VERSIONS="8 9 10"
- [ ] `certs/rhce/topology.sh` — create `rhtr-rhce-control-<ver>`, `rhtr-rhce-node1-<ver>`,
      `rhtr-rhce-node2-<ver>`; configure SSH keys; install Ansible on control; write inventory

### Incus features to use in the RHCE topology (confirmed available in Incus codebase)

**Isolated network between nodes:**
Create a dedicated bridge with no uplink so managed nodes are reachable only from
the control node and not from the external network. Attach control + nodes to it.
```bash
incus network create rhtr-rhce-net --type=bridge
# No uplink config → isolated. Then attach each VM:
incus config device add rhtr-rhce-control-9 eth1 nic network=rhtr-rhce-net
incus config device add rhtr-rhce-node1-9   eth0 nic network=rhtr-rhce-net
incus config device add rhtr-rhce-node2-9   eth0 nic network=rhtr-rhce-net
```
The control node gets two NICs: eth0 for Incus host access (incus exec / shell),
eth1 for the isolated exam network. Managed nodes get only the isolated NIC.

**Cloud-init for managed node first-boot:**
Pass `cloud-init.user-data` at launch to pre-configure managed nodes without a
post-boot setup script. Handles: create `ansible` user, add SSH authorized key,
install Python, disable requiretty in sudoers. All done before `vm_wait_ready` returns.
```bash
incus launch rocky9 rhtr-rhce-node1-9 --vm \
  --profile default \
  --profile rhtr-rhce-node \
  --config cloud-init.user-data="$(cat certs/rhce/cloud-init/managed-node.yaml)"
```
Create `certs/rhce/cloud-init/managed-node.yaml` with the cloud-init config.

**Profile for RHCE nodes:**
Create `rhtr-rhce-node` profile (1 vCPU, 1 GiB RAM — managed nodes are lightweight).
Create `rhtr-rhce-control` profile (2 vCPU, 2 GiB RAM — Ansible runs here).

---

## Phase 7 — RHCE task library

### ch01 — Ansible basics and ad-hoc commands
- [ ] `adhoc-ping-v1`
- [ ] `adhoc-package-v1`

### ch03 — Inventory
- [ ] `static-inventory-v1`
- [ ] `group-vars-v1`

### ch04 — Playbooks
- [ ] `basic-playbook-v1`
- [ ] `handlers-v1`
- [ ] `multiplay-v1`

### ch05 — Variables and facts
- [ ] `magic-vars-v1`
- [ ] `registered-vars-v1`
- [ ] `facts-filter-v1`

### ch06 — Task control
- [ ] `loops-v1`
- [ ] `conditionals-v1`
- [ ] `tags-v1`
- [ ] `error-handling-v1`

### ch07 — Files and Jinja2
- [ ] `template-v1`
- [ ] `lineinfile-v1`
- [ ] `copy-fetch-v1`

### ch08 — Roles
- [ ] `create-role-v1`
- [ ] `role-galaxy-v1`
- [ ] `role-requirements-v1`

### ch09 — Vault
- [ ] `encrypt-var-v1`
- [ ] `encrypt-file-v1`
- [ ] `vault-in-playbook-v1`

### ch10 — Troubleshooting
- [ ] `syntax-error-v1`
- [ ] `failed-task-debug-v1`

---

## Phase 8 — RHCE profiles and fixed exams

- [ ] `certs/rhce/exams/profiles/full.conf`
- [ ] `certs/rhce/exams/profiles/topic-playbooks.conf`
- [ ] `certs/rhce/exams/profiles/topic-roles.conf`
- [ ] `certs/rhce/exams/profiles/topic-vault.conf`
- [ ] `certs/rhce/exams/fixed/full-v1.conf`

---

## Phase 9 — Polish and ergonomics

- [ ] Bash/zsh shell completion script for `rhtr`
- [ ] `rhtr rhcsa status` — live timer display during exam
- [ ] Friendly error messages when Incus image is missing (prompt user with import command)
- [ ] Validate task library on load (all required files present, meta.sh parseable)
- [ ] `--dry-run` flag for `new` — show which tasks would be selected without starting VM
- [ ] Man page or `rhtr help <command>` per-command help

---

## Phase 9 — Polish and ergonomics (continued)

### Incus project isolation (defer until it causes real problems)

All rhtr VMs are currently in the default Incus project and distinguished only
by name prefix `rhtr-*`. If naming collisions become an issue, migrate to a
dedicated `rhtr` project:

```bash
incus project create rhtr
incus project set rhtr features.storage.volumes=false  # share default storage pool
incus project set rhtr features.networks=false          # share default network
```

Then add a `_incus()` wrapper in `lib/vm.sh` that prepends `--project rhtr` to
all instance-level commands (info, start, stop, delete, exec, shell, launch,
snapshot, config, profile). Storage and image commands stay as plain `incus`.

**Also useful later:**
- `incus snapshot create --expiry <duration>` — auto-expire old pre-exam snapshots
  (e.g. `--expiry 7d`) to prevent accumulation across multiple sessions
- `incus monitor` — JSON event stream; could power a live `rhtr status` view
  that shows what the VM is doing during the exam without polling
- `incus export / import` — full VM backup including snapshots; useful for
  distributing pre-configured exam environments

---

## Backlog / future

- [ ] RHCA / other cert support (same framework, new `certs/<cert>/` dir)
- [ ] Multi-session support (named sessions instead of single `.state/`)
- [ ] Web-based score report (HTML output from `grade`)
- [ ] Task contribution guide (`CONTRIBUTING.md`)
