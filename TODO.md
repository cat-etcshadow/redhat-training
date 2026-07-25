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
- [x] `vim-edit-v1` — edit config file with a text editor (key=value substitutions)
- [x] `man-docs-v1` — use man pages to find archive flag for cp, use find -size to locate large files
- [x] `sort-uniq-v1` — sort/uniq -c to find the most frequent line in a log file
- [x] `tar-selective-v1` — extract a single named file from a tar archive without unpacking the rest
- [x] `io-redirect-v1` — append stdout and redirect stderr to separate files in one invocation

### ch02 — Shell Scripting
- [x] `scripting-if-v1` — write check_user.sh: if/elif/else, id check, specific exit codes
- [x] `scripting-for-list-v1` — write create_dirs.sh: for loop over literal list, mkdir + README
- [x] `scripting-for-files-v1` — write archive_logs.sh: for loop over find output, gzip each .log
- [x] `scripting-while-v1` — write create_users_from_file.sh: while IFS= read -r, useradd
- [x] `scripting-args-v1` — write backup_file.sh: $1/$2/$#, -f/-r/-d tests, timestamp suffix
- [x] `scripting-case-v1` — write svc_ctl.sh: case statement for start/stop/restart/status/enable
- [x] `scripting-functions-v1` — write disk_report.sh: named functions, --output flag, mountpoint check
- [x] `scripting-heredoc-v1` — write gen_config.sh: heredoc with/without variable expansion
- [x] `scripting-exit-codes-v1` — write script that uses meaningful exit codes, use $? and ||/&&
- [x] `scripting-arrays-v1` — write inventory_report.sh: indexed arrays, for loop over indices
- [x] `scripting-until-v1` — write wait_for_file.sh: until loop polling with a timeout
- [x] `scripting-defaults-v1` — write deploy_env.sh: ${VAR:-default} parameter expansion, string tests

### ch03 — Manage Local Users and Groups
- [x] `create-users-v1` — create two users with specific UIDs, group with GID, sudo NOPASSWD
- [x] `create-users-v2` — different users/UIDs, password aging constraint
- [x] `sudo-nopasswd-v1` — pre-existing user, configure sudoers drop-in for specific command
- [x] `password-aging-v1` — set max age, warning days, inactive period for existing user
- [x] `group-membership-v1` — change primary group, add supplementary groups
- [x] `delete-user-v1` — lock account, userdel -r, groupdel, remove sudoers drop-in
- [x] `usermod-lock-v1` — lock one account with usermod -L, unlock another with usermod -U
- [x] `group-batch-membership-v1` — set exact group membership at once with gpasswd -M
- [x] `useradd-custom-v1` — create a system service account: nologin shell, custom home, no auto-created dir

### ch04 — Control Access to Files
- [x] `setgid-dir-v1` — create directory with SGID, correct group ownership and mode
- [x] `sticky-bit-v1` — SGID + sticky bit on shared dir, mode 3770
- [x] `acl-v1` — set named ACL entries on a directory, verify with getfacl
- [x] `umask-v1` — set persistent per-user and system-wide umask
- [x] `fix-perms-v1` — diagnose and correct broken web root permissions (chgrp -R, find -exec chmod)
- [x] `acl-mask-v1` — fix an ACL mask restricting a named entry's effective permissions
- [x] `suid-sgid-audit-v1` — find files with SUID set, remove an unauthorized one, keep an approved one
- [x] `numeric-perms-v1` — apply exact numeric chmod modes across a set of files

### ch05 — Manage SELinux Security
- [x] `fix-file-context-v1` — wrong context on /var/www/html subdir, fix with semanage + restorecon
- [x] `fix-file-context-v2` — wrong context on custom service data dir
- [x] `boolean-httpd-v1` — enable httpd_can_network_connect boolean persistently
- [x] `boolean-nfs-v1` — enable SELinux boolean for NFS home dirs
- [x] `troubleshoot-audit-v1` — find SELinux denial in audit log, identify boolean fix
- [x] `selinux-port-v1` — add non-standard port to http_port_t, configure Apache
- [x] `selinux-mode-v1` — setenforce 0/1, persist SELINUX=enforcing in config, ls -Z output
- [x] `selinux-restorecon-v1` — cp --preserve=context carries a wrong type in; fix with restorecon alone
- [x] `selinux-boolean-set-v1` — enable a randomly-chosen SELinux boolean persistently
- [x] `selinux-port-ssh-v1` — label a non-standard SSH port with ssh_port_t, configure sshd to listen on it

### ch06 — Tune System Performance
- [x] `tuned-profile-v1` — set and activate a specific tuned profile persistently
- [x] `process-priority-v1` — renice a running process, launch process with specific nice value
- [x] `kill-signals-v1` — kill processes with pkill, killall, and kill by PID
- [x] `job-control-v1` — launch a background process with nohup, redirect output, survive hangup
- [x] `ps-filter-report-v1` — ps -ef + grep to find PIDs by name, save filtered report
- [x] `nice-launch-v1` — renice -u to change scheduling priority for all of a user's processes at once

### ch07 — Schedule Future Tasks
- [x] `at-job-v1` — schedule one-time job with at
- [x] `cron-job-v1` — create cron entry for a user to run script at specific time
- [x] `systemd-timer-v1` — create a systemd timer unit for a recurring task
- [x] `tmpfiles-v1` — configure tmpfiles.d to create/clean a directory on boot
- [x] `cron-system-v1` — system-wide cron job in /etc/cron.d with a user field
- [x] `at-manage-v1` — atq to list queued jobs, atrm to remove one specific job
- [x] `cron-env-v1` — set PATH in a crontab so a job can find a non-standard-PATH dependency

### ch08 — Install and Update Software Packages
- [x] `dnf-install-v1` — install a package, verify with rpm -q
- [x] `dnf-group-v1` — install a package group
- [x] `dnf-module-v1` — enable a nodejs module stream, install from it
- [x] `repo-enable-v1` — enable a disabled DNF repo, install package from it
- [x] `dnf-local-rpm-v1` — install from local .rpm file; configure local file:// repo with createrepo_c
- [x] `dnf-history-undo-v1` — undo an entire transaction with dnf history undo (not per-package remove)
- [x] `dnf-autoremove-v1` — dnf mark dependency + dnf autoremove to clean an orphaned package
- [x] `dnf-config-manager-v1` — dnf config-manager --add-repo, disable gpgcheck, install from it

### ch09 — Manage Basic Storage
- [x] `add-partition-xfs-v1` — partition disk (MBR), format XFS, mount persistently at /mnt/data
- [x] `add-partition-ext4-v1` — partition disk (MBR), format ext4, mount persistently
- [x] `add-partition-gpt-v1` — partition disk with GPT (parted), format XFS, fstab by UUID
- [x] `add-partition-vfat-v1` — partition disk, format vfat/FAT32, fstab with 0 0 fsck fields
- [x] `swap-partition-v1` — create swap partition, activate persistently
- [x] `persistent-mount-uuid-v1` — update /etc/fstab to use UUID instead of device path
- [x] `persistent-mount-label-v1` — mount by filesystem label
- [x] `mount-options-v1` — persistent mount with nosuid/nodev/noexec hardened options
- [x] `resize-partition-v1` — grow a partition with growpart and its XFS filesystem online
- [x] `fstab-noauto-v1` — noauto,user options so a regular user can mount/unmount without root

### ch10 — Manage Storage Stack (LVM)
- [x] `create-lv-v1` — PV on extra disk, VG vg_data, LV lv_storage, format XFS, mount at /mnt/storage
- [x] `extend-lv-v1` — extend existing LV by 300 MB online without data loss
- [x] `lv-ext4-v1` — create LV, format ext4, mount persistently
- [x] `stratis-pool-v1` — create Stratis pool + filesystem, fstab with x-systemd.requires (RHEL_VERSIONS="9 10")
- [x] `extend-lv-ext4-v1` — extend existing LV, resize ext4 filesystem online with resize2fs
- [x] `lvm-snapshot-v1` — create an LVM snapshot of an existing logical volume
- [x] `vg-extend-v1` — add a new physical volume to an existing (near-full) volume group
- [x] `lv-rename-v1` — lvrename an LV and fix a device-path fstab reference so it still mounts

### ch11 — Control Services and Boot Process
- [x] `reset-root-password-v1` — root locked, candidate resets via rd.break to known value
- [x] `boot-target-v1` — switch default boot target to multi-user.target
- [x] `repair-fstab-v1` — broken /etc/fstab entry prevents boot, fix in emergency shell
- [x] `service-enable-v1` — ensure a service is enabled and running after reboot
- [x] `grub-param-v1` — add kernel parameter with grubby
- [x] `custom-unit-v1` — create Type=oneshot systemd unit file, enable and start it
- [x] `service-mask-v1` — systemctl mask a deprecated unit so it can't be started even manually
- [x] `grub-timeout-v1` — set GRUB_TIMEOUT in /etc/default/grub, regenerate grub.cfg
- [x] `disable-service-v1` — stop and disable a running, enabled service

### ch12 — Analyze and Store Logs
- [x] `journald-persistent-v1` — configure journald to persist logs across reboots
- [x] `journald-size-v1` — set journald Storage=persistent and SystemMaxUse
- [x] `rsyslog-rule-v1` — add rsyslog rule to forward specific facility to a file
- [x] `chrony-server-v1` — configure chrony NTP client with specific server
- [x] `journalctl-v1` — query journal by syslog identifier and by boot, redirect to files
- [x] `timedatectl-v1` — set system timezone with timedatectl, enable chronyd NTP service
- [x] `logrotate-v1` — configure /etc/logrotate.d for a custom app log: size, rotate, compress, copytruncate
- [x] `journalctl-priority-v1` — filter journal entries by priority (-p err), excluding lower-priority noise
- [x] `ntp-toggle-v1` — enable/disable NTP sync with timedatectl set-ntp (not touching chronyd directly)

### ch13 — Manage Networking
- [x] `hostname-dns-v1` — set static hostname, add /etc/hosts entry
- [x] `static-ip-v1` — configure second NIC with static IP via nmcli (requires topology 2nd NIC)
- [x] `nmcli-bond-v1` — create network bond (RHEL_VERSIONS="8 9 10")
- [x] `routing-v1` — add persistent static route via nmcli
- [x] `ipv6-addr-v1` — assign static IPv6 address via nmcli, method manual, persist
- [x] `ssh-key-auth-v1` — generate RSA key pair, configure authorized_keys, functional test
- [x] `nmcli-connection-add-v1` — nmcli con add a new dummy-interface profile with static IPv4, autoconnect no
- [x] `dns-resolver-v1` — set DNS servers via nmcli ipv4.dns, ignore-auto-dns, verify resolv.conf
- [x] `ssh-hardening-v1` — sshd_config: PermitRootLogin no, PasswordAuthentication no

### ch14 — Access Network-Attached Storage
- [x] `nfs-mount-v1` — mount NFS share persistently (fstab checked; server not required in lab)
- [x] `nfs-export-v1` — configure NFS server export
- [x] `autofs-v1` — configure autofs for indirect NFS mounts
- [x] `nfs-mount-options-v1` — persistent NFS mount with ro,noatime,rsize/wsize tuning
- [x] `autofs-direct-v1` — direct autofs map (/- master entry, full-path key, vs. indirect wildcard)
- [x] `showmount-v1` — showmount -e to discover an export, mount it (self-hosted local NFS server)

### ch15 — Manage Network Security
- [x] `firewall-add-service-v1` — add http + https services permanently to firewalld
- [x] `firewall-add-port-v1` — open a specific TCP port permanently
- [x] `firewall-rich-rule-v1` — add a rich rule allowing specific source IP
- [x] `firewall-zone-v1` — assign interface to zone, set zone default
- [x] `firewall-port-forward-v1` — permanent --add-forward-port redirecting one port to another
- [x] `firewall-remove-service-v1` — permanently remove a service from a zone
- [x] `firewall-masquerade-v1` — permanently enable IP masquerading on a zone

### ch16 — Run Containers
- [x] `run-container-v1` — pull and run container with podman, map port
- [x] `container-env-v1` — run container with env vars and port mapping
- [x] `container-service-v1` — run container as root systemd service via podman generate systemd
- [x] `container-storage-v1` — run container with persistent bind-mount volume
- [x] `container-build-v1` — build image from Containerfile with podman build, verify output
- [x] `container-user-service-v1` — rootless container as user systemd service; loginctl enable-linger
- [x] `container-inspect-v1` — podman inspect + skopeo inspect, save JSON/output to report file
- [x] `container-registry-v1` — podman search, pull, tag image, review registries.conf
- [x] `container-healthcheck-v1` — run with --health-cmd/--health-interval, wait for healthy status
- [x] `container-network-v1` — podman network create with a subnet, attach a container to it
- [x] `container-resource-limits-v1` — run with --memory and --cpus, verify via podman inspect

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

- [x] `rhtr rhcsa new --rhel 10 --profile full` completes without error
- [x] `rhtr rhcsa shell` opens VM shell (verified via `incus exec`)
- [x] `rhtr rhcsa grade` grades all tasks, produces score table
- [x] `rhtr rhcsa reset` restores snapshot and re-applies setups
- [x] `rhtr rhcsa destroy` removes VMs and clears state
- [ ] `rhtr rhcsa list-tasks --rhel 8` filters correctly
- [ ] `rhtr rhcsa progress` shows training history
- [ ] Test `--rhel 8` and `--rhel 10` end to end (RHEL 10 validated; RHEL 8/9 images not yet imported on this host)

Validated 2026-07-06 on RHEL 10 after fixing the incus-agent bootstrap (see
`lib/vm.sh` `_vm_inject_agent_bootstrap` and `vm_profile_ensure`) — the
VM agent would not start at all before this fix. See git history for
details.

---

## Phase 6 — RHCE cert definition ✓

- [x] `certs/rhce/cert.conf` — PASS_THRESHOLD=70, DEFAULT_DURATION=180, RHEL_VERSIONS="9"
- [x] `certs/rhce/topology.sh` — creates `rhtr-rhce-control-<ver>` +
      `rhtr-rhce-node{1..5}-<ver>`; configures SSH keys; installs ansible-core,
      ansible-navigator, podman, git on control

### Incus features considered for the RHCE topology — not adopted

Isolated bridge network and cloud-init first-boot config (see git history for
the original proposal) were considered but not used. The implemented
`topology.sh` uses the shared `default` bridged profile plus post-boot
`vm_exec` bootstrap heredocs instead — simpler, and sufficient since managed
nodes don't need to be reachable from outside the host.

---

## Phase 7 — RHCE task library ✓

55 tasks across 11 chapters (`ch01-ansible-basics` through `ch11-storage-lvm`,
including `ch02-navigator-git`). See the EX294 coverage table in README.md for
the full, current task list — this phase's original per-chapter task-name
plan is superseded by what's actually implemented and is no longer tracked
here to avoid drift.

---

## Phase 8 — RHCE profiles and fixed exams ✓

- [x] `certs/rhce/exams/profiles/full.conf`
- [x] `certs/rhce/exams/profiles/inventory.conf`, `playbooks.conf`, `roles.conf`,
      `troubleshooting.conf`, `variables.conf`, `vault.conf`, `navigator-git.conf`
- [x] `certs/rhce/exams/fixed/full-v1.conf`, `full-v2.conf`

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

## Phase 10 — Objective-gap closure (EX200 RHEL 10 / EX294 navigator+EE) ✓

Cross-checked the task library against Red Hat's currently published EX200 and
EX294 objectives and closed every gap found:

- [x] `ch08-packages/flatpak-v1` — Flatpak repo access + install/remove
      (new "Manage software" objective category on EX200)
- [x] `ch01-tools/switch-user-v1` — `su -` full login shell vs `su`
- [x] `ch11-boot/reboot-shutdown-v1` — schedule/cancel with `shutdown`
- [x] `ch11-boot/isolate-target-v1` — `systemctl isolate` vs `set-default`
- [x] `certs/rhcsa` README table — reclassified `systemd-timer-v1` and
      `ipv6-addr-v1` from extra to exam-aligned (both are explicit objectives
      on the current EX200 page; the table had gone stale)
- [x] `ch02-navigator-git/` (new RHCE chapter) — `ansible-navigator-config-v1`,
      `execution-environment-v1`, `git-playbook-repo-v1`
- [x] `certs/rhce/topology.sh` — control node now installs `ansible-navigator`,
      `podman`, `git` (previously only `ansible-core`)
- [x] Wired new tasks into `certs/rhcsa` and `certs/rhce` exam profiles/fixed exams
- [x] Documented the VS Code EX294 objective as intentionally excluded
      (not gradable headlessly — no GUI/editor state to assert on)

---

## Phase 11 — Review backlog (full repo review, 2026-07-07)

Findings from a full review: every task.md/meta.sh audited for hint leaks,
all of `bin/`+`lib/` code-reviewed, exam configs cross-checked, and the task
library compared against the current EX200/EX294 objectives.

### 11a — Fix: critical

- [x] **RHCE managed nodes unreachable by inventory hostname** —
      `certs/rhce/topology.sh:103`: `short="${node%%-"${RHEL_VERSION}"}"` turns
      `rhtr-rhce-node1-9` into `rhtr-rhce-node1`, not `node1`, so `/etc/hosts`
      on the control node never gets the `node1..node5` names every task
      inventory uses. No RHCE playbook can reach its nodes. Fix by passing the
      short name into the loop directly instead of re-deriving it.
      Then run one real RHCE task end-to-end to validate (never done — Phase 5
      has no RHCE equivalent). — **still needs a real end-to-end VM run to
      validate; not testable from this session (no VM access here).**
- [ ] **RHCE grading is static text-matching** — 43/55 `grade.sh` only run
      `ansible-playbook --syntax-check` + `grep` for module names/strings in
      the playbook text; zero execute against node state (only the two
      ch02-navigator tasks do). Passable by keyword-stuffing a dead playbook.
      After the hostname fix: rework grade.sh to run the playbook and assert
      on real state on `node1..node5`. Do chapter by chapter; ch04-playbooks
      and ch11-storage-lvm first (most state-assertable).
      **Progress:** 8/9 ch04-playbooks tasks reworked (firewall, nmcli,
      packages-v1, packages-v2, selinux, service, user-group, yum-repo) —
      each now runs the real playbook via `ansible-playbook` (not just
      `--syntax-check`) as the `student` user, then asserts live state with
      `ansible <group> -m command/shell -a ...` (rpm -q, systemctl is-active,
      firewall-cmd --query-*, getent, semanage fcontext -l, ls -Z, nmcli -g,
      cat /etc/yum.repos.d/*.repo). Discovered and fixed along the way:
      `topology.sh` bootstrap never installed the `community.general` /
      `ansible.posix` collections every single RHCE playbook module depends
      on (only `ansible-core`, which ships zero collections) — added
      `ansible-galaxy collection install community.general ansible.posix` to
      control-node bootstrap, plus `firewalld`/`python3-firewall`/
      `policycoreutils-python-utils`/`NetworkManager` to managed-node
      bootstrap so the `firewalld`/`seboolean`/`sefcontext`/`nmcli` modules
      have their runtime deps. `selinux-playbook-v1/setup.sh` now
      pre-populates `$CUSTOM_DIR` with a real file on the prod nodes so
      "apply context to existing files" is an actual, checkable action
      instead of a no-op against a directory that never existed.
      **Not yet done:** `error-handling-v1` (ch04) and all of
      `ch11-storage-lvm` (`lvm-playbook-v1`, `lvm-playbook-v2`,
      `partition-playbook-v1`) target a `research`/`data_vg` volume group or
      raw disk that doesn't exist anywhere — RHCE managed nodes get **no**
      extra disk from `topology.sh` (unlike RHCSA's `NEEDS_DISK`/
      `EXTRA_DISK_SIZES_GIB` mechanism). Real grading for these needs the
      same kind of per-task extra-disk plumbing built for RHCSA, extended to
      attach to specific managed nodes (prod = node3/node4, or `all` for
      error-handling-v1) — a bigger, separate lift than the ch04 rework.
      **First live-VM run (2026-07-24) hit exactly this kind of bug:**
      `selinux-playbook-v1/setup.sh`'s two new `ansible prod ...` calls ran
      from `student`'s home dir instead of `$ANSIBLE_DIR`, so `ansible.cfg`'s
      `host_key_checking = False` wasn't picked up — the first-ever SSH from
      `student` to node3/node4 hit an unaccepted host key non-interactively
      and `ansible` reported both hosts unreachable (rc=4), failing session
      setup for the whole exam. Fixed by `cd $ANSIBLE_DIR &&` before both
      calls, matching the pattern `grade.sh` already used. Still untested:
      the other 7 reworked ch04 `grade.sh` scripts' exact module output
      formats (e.g. `nmcli -g` field ordering, `getsebool`/
      `semanage fcontext -l` output shape) against a real Rocky 9 managed
      node — only `selinux-playbook-v1` has been exercised end-to-end so
      far.
- [x] **`container-user-service-v1` claims RHEL 10 but solution uses
      `podman generate systemd`** — removed in podman 5.x (RHEL 10). Capped
      `RHEL_VERSIONS` to `"8 9"` rather than attempting a Quadlet rewrite
      (tracked separately as `quadlet-service-v1` in 11g).
- [x] **Ctrl-C during `new`/`train` orphans VMs** — `lib/exam.sh:104` EXIT trap
      does `rm -rf "$STATE_DIR"` but never `topology_destroy`; aborted setup
      leaves Incus VMs behind while deleting the state that tracks them.
      Fixed via `_start_session_cleanup` in `lib/exam.sh`.

### 11b — Fix: task content (hint/answer leaks — full audit, corpus otherwise clean)

- [ ] `ch05-selinux/selinux-process-context-v1/task.md` — "(e.g. `httpd_t`)"
      IS the answer to the task's own question; drop the parenthetical
- [ ] `ch14-nfs/autofs-direct-v1/task.md` — opening sentence explains how
      direct vs indirect maps work (teaching aside); delete it
- [ ] `certs/rhce/.../ch09-vault/use-vault-users-v1/task.md` — "(`password_hash('sha512')`
      filter)" leaks the exact filter syntax; require "SHA512 hash format" only
- [ ] `certs/rhce/.../ch05-variables/registered-vars-v1/task.md` — decide on
      `svc_result.rc` (leaks the `.rc` attribute; borderline vs. method mandate)
- [ ] Borderline, decide once: `ch12-logging/logrotate-v1` ("keeps its log file
      open…" rationale), `ch13-networking/static-ip-v1` ("**Important**:" preface)

### 11c — Fix: weak grading / wrong solutions (RHCSA)

- [x] `ch03-users/create-users-v{1,2}/grade.sh` — required password value never
      verified, any hash passes; check the hash against `{{PASSWORD}}`
- [x] `ch09-storage/add-partition-{ext4,xfs,gpt}-v1`, `persistent-mount-label-v1`
      — `{{PART_SIZE}}` is required by task.md but never graded; assert size ±tolerance
- [x] `ch16-containers/container-registry-v1/grade.sh` — two report-file greps
      satisfiable with `echo`; assert on podman state instead where possible
- [ ] **15 tasks whose `solution.sh` hardcodes example values instead of using
      their params vars** (shown text is wrong for the actual instance):
      create-users-v1/v2, password-aging-v1 (also misses `-I`, wouldn't pass its
      own grader), sudo-nopasswd-v1, fix-file-context-v1, tuned-profile-v1,
      cron-job-v1, add-partition-ext4-v1, add-partition-xfs-v1,
      delete-partition-v1, create-lv-v1, extend-lv-v1, rsyslog-rule-v1,
      hostname-dns-v1, firewall-add-port-v1
- [ ] `lib/report.sh` `_show_solution` — substitute session params when
      displaying solution.sh (task.md is rendered, solution.sh is raw-`cat`'d;
      trainees see literal `"$HTTP_PORT"`)

### 11d — Fix: robustness (lib)

- [ ] `lib/exam.sh:404` `_run_task_script` — `tail -n +2` silently drops the
      first line of any script not starting with a shebang; add a guard
- [ ] `cmd_shell`/`cmd_grade`/`cmd_reset` — check `vm_running` and start stopped
      VMs (or add `rhtr <cert> start`); today a stopped VM = raw Incus error
- [ ] `lib/select.sh:28` — non-numeric topic count in a profile throws a raw
      bash error instead of `die` naming the bad entry
- [ ] Duplicate `## Phase 9` heading in this file — merge the two sections

### 11e — Improve

- [ ] **`bin/lint-tasks` — automated task-convention linter** (solves the
      recurring "models re-introduce hints" problem structurally): fail on
      hint phrasing in task.md (`Note:`, `Tip:`, `you can`, `e.g. <command>`,
      man-page refs), non-whitelisted meta.sh variables, params.sh vars unused
      by grade.sh, solution.sh referencing none of its params vars. Run in a
      pre-commit hook / CI so violations can't land
- [ ] shellcheck over `bin/` + `lib/` + all task scripts, fix findings, keep in CI
- [ ] Validate RHEL 8 and 9 end-to-end (only 10 was validated); while there,
      confirm `ch11-boot/grub-timeout-v1`'s hardcoded `/boot/grub2/grub.cfg`
      is right for UEFI VMs (vs `/boot/efi/EFI/...`) per version
- [ ] `hint.md` coverage: 140/233 tasks missing — decide policy (fill all via
      cheap-model batch job, gated by the linter so hints stay out of task.md)
- [ ] RHCE fixed exams full-v1/full-v2 share 7 tasks — reduce overlap as the
      RHCE pool grows (blocked on 11f)
- [ ] `progress.sh`/`history.sh` spawn `python3` per JSON field — batch reads
      or use jq (minor)

### 11f — Add: RHCE pool depth (thin chapters block varied full exams)

Real EX294 is ~17–20 tasks; several chapters can't contribute variety:
ch02 (3 tasks), ch03 (4), ch05 (4), ch07 (4), ch09 (4), ch10 (4), ch11 (3).
Target ≥6 per chapter. Specific new tasks, all exam-aligned:

- [ ] `ch08-roles/system-roles-storage-v1` — RHEL system role: storage (LVM+mount)
- [ ] `ch08-roles/system-roles-network-v1` — RHEL system role: network
- [ ] `ch08-roles/system-roles-firewall-v1` — RHEL system role: firewall
- [ ] `ch06-tasks-control/reboot-update-v1` — update package(s), conditional
      reboot via `ansible.builtin.reboot`, verify with `wait_for`/uptime
- [ ] `ch06-tasks-control/at-task-v1` — one-shot scheduled job via `ansible.posix.at`
- [ ] `ch08-roles/collection-requirements-v1` — install collections from a
      `requirements.yml` (galaxy-requirements-v1 covers roles only)
- [ ] `ch09-vault/vault-string-v1` — `ansible-vault encrypt_string` inline secret
- [ ] `ch07-files-jinja2/template-loop-filters-v1` — template with `for` loop +
      filters (`default`, `upper`) over hostvars
- [ ] `ch03-inventory/inventory-refactor-v1` — restructure a flat inventory into
      groups/children + group_vars (second static-inventory variant)
- [ ] `ch10-troubleshooting/fix-idempotence-v1` — playbook that changes every
      run; make it idempotent (command→module conversion)
- [ ] Capstone: `ch04-playbooks/webserver-stack-v1` — httpd + template + SELinux
      + firewalld + handler, graded by curl from control (exam-style compound)

### 11g — Add: RHCSA tasks/topics

- [ ] `ch16-containers/quadlet-service-v1` (+ rootless user variant) —
      Quadlet `.container` unit; **required** for RHEL 10, exam-current for 9
- [ ] `ch01-tools/find-by-owner-v1` — find files owned by a user, copy to a
      target dir preserving permissions (classic exam item; find-files-v1 only
      covers name/type/size)
- [ ] `ch12-logging/chrony-client-v1` — point chronyd at a specific NTP server
      (chrony-server-v1 exists; client-side config is the actual exam task)
- [ ] `ch10-lvm/swap-on-lv-v1` — swap on a logical volume, persistent
- [ ] `ch04-permissions/acl-default-v1` — default ACLs on a directory so new
      files inherit (acl-v1 covers named entries only)
- [ ] Compound capstone tasks (real exam bundles objectives): e.g.
      `ch05-selinux/web-nonstandard-port-v1` — httpd on alt port + SELinux port
      label + firewalld + enabled at boot, graded via curl
- [ ] Second variants (`-v2`) for chapters still at one variant per objective
      where randomization is thin — lowest priority

---

## Phase 12 — RHCE: non-prescriptive exam-format mode (`--format exam`)

Audit (2026-07-25) of all 55 `tasks/` task.md/grade.sh pairs: 41 name the exact
module to use in task.md, 42 `grep` the student's playbook source for that
module name in grade.sh (fail if a different valid module was used), and only
8 actually apply the playbook and check resulting state on the managed nodes —
the rest either only run `--syntax-check` (43) or check file content that
never touches a node at all. Good for *learning* which module does what; not
representative of EX294, which states an outcome only and grades on live
system state, never on how you got there.

Decision: keep `tasks/` exactly as-is (it's good training-wheels material) and
add a second, parallel pool for exam-realistic practice. The existing pool,
profiles, and RHCSA are untouched; `topology.sh` gained a scaling mechanism
(12d below) that both formats share.

**Shipped 2026-07-25** (mechanism cert-agnostic in `lib/`, one scenario
authored as pipeline proof — see 12a/12b for what's still open):

### 12a — New task pool: `certs/rhce/tasks-exam/`

- [x] Flat directory, not chapter-nested — scenarios span topics by design:
      `certs/rhce/tasks-exam/<scenario-slug>-v1/`
- [x] Same file set as `tasks/`: `task.md`, `meta.sh`, `params.sh`, `setup.sh`,
      `grade.sh`, `solution.sh` — no `hint.md` (real exam gives no hints).
      Enforced by `lib/lint.sh` (`_lint_check_no_hint`, `_lint_check_no_module_naming`
      — two-tier: ERROR on FQCN module/collection names, WARN on bare
      module-ish words), not a separate `bin/lint-tasks` — folded into the
      existing linter's `--format exam` path instead of a new binary
- [x] `task.md`: outcome/state only, never names a module, collection, or
      Ansible construct
- [x] `meta.sh`: `TOPICS` becomes an array of every chapter/topic the scenario
      touches (e.g. `TOPICS=(playbooks tasks-control files-jinja2 roles)`) for
      reporting; `POINTS` scaled up per scenario (compound tasks worth more
      than single-skill ones)
- [x] `grade.sh`: state-only, always — no `grep` of `$PLAYBOOK_FILE` or any
      other source-inspection of the student's work. Every assertion checks
      live state on the managed nodes via `ansible ... -m command`/curl —
      stricter than the 8 "reworked" ch04 tasks in `tasks/`, which still keep
      1-2 module-name greps as a gate; this pool has zero source-inspection
- [x] First scenario built and live-verified end-to-end against real Incus
      VMs: `webserver-stack-v1` (httpd + custom docroot + template + SELinux
      fcontext + firewalld + restart-on-change handler, graded by curl from
      control). Confirmed grade.sh both PASSes a correct reference solution
      and FAILs when a step (firewalld) is removed from the playbook.
- [ ] Curate the remaining ~14-19 scenarios (target ~15-20 total, matching
      11f's own EX294 estimate of ~17-20 real exam items) — only one exists
      so far, deliberately (see "why one scenario first" in the session that
      built this: prove the pipeline once, cheaply, before repeating the
      shape 15-20 times)

### 12b — New CLI surface: `--format exam`

- [x] `rhtr rhce new --format exam [...]` / `rhtr rhce train --format exam`
      select from `tasks-exam/` instead of `tasks/`; omitting `--format`
      keeps today's behavior unchanged. Validated: dies cleanly with a clear
      message if `--format exam` is requested for a cert with no
      `tasks-exam/` dir yet (e.g. `rhtr rhcsa new --format exam` today)
- [x] `lib/select.sh` gained a format-aware selection path: `_select_exam_pool`
      (random "pick N of the flat pool", `SCENARIO_COUNT` in
      `exams/profiles-exam/*.conf`) and `_select_fixed_exam` (`SCENARIOS=()`
      in `exams/fixed-exam/*.conf`), dispatched from `select_tasks()` on
      `$FORMAT` — resolved differently from the original plan's guess since
      `tasks-exam/` isn't chapter-scoped
- [ ] Open question, not decided: whether `cert.conf`'s current
      `PASS_THRESHOLD=70` / `DEFAULT_DURATION=180` should differ for
      `--format exam` to better match real EX294 timing — nothing blocks
      deciding this later, since a `profiles-exam/*.conf`/`fixed-exam/*.conf`
      file can already set its own `DURATION`/`PASS_THRESHOLD` per the
      existing per-profile override mechanism

### 12c — Explicitly out of scope for this phase

- [x] Existing `tasks/` learning pool, profiles, and
      `rhtr rhce new --profile full` (etc.) — unchanged (still module-name
      grading style; live-verified unaffected: `rhtr rhce lint` and a full
      live `new`/`shell`/`grade`/`reset`/`destroy` training-pool cycle both
      still pass with zero regressions)
- [x] RHCSA — mechanically unchanged (still no `tasks-exam/` dir; `--format
      exam` on `rhtr rhcsa ...` errors cleanly). The `--format`/pool-dir split
      itself *is* now cert-agnostic in `lib/` (see 12d) so RHCSA or a future
      cert can opt in later with zero `lib/` changes — just a `tasks-exam/`
      dir and matching `exams/profiles-exam|fixed-exam/` — but nothing about
      RHCSA's own tasks/profiles/topology was touched
- [ ] Multi-tenant / paid-platform architecture (per-session VM isolation,
      concurrent provisioning cost, per-user grading queues) — real concern
      for the planned hosted version of this, but a separate planning pass
      once the task-format work above lands

### 12d — Generalized beyond the original spec: cert-agnostic mechanism + node scaling

Two things not in the original Phase 12 spec above, added because the repo
owner wanted them explicitly:

- [x] **Cert-agnostic pool split, not RHCE-specific.** `lib/core.sh` gained
      `pool_dir()`/`pool_dir_exists()` (training → `certs/$cert/tasks/`, exam
      → `certs/$cert/tasks-exam/`); every hardcoded `tasks/` reference across
      `lib/exam.sh`, `lib/select.sh`, `lib/list.sh`, `lib/lint.sh` now goes
      through it. `task_short_name()`/`task_abs_path()` in `lib/core.sh`
      generalized to handle either pool-dir segment.
- [x] **`NEEDS_NODES` topology scaling** (RHCE-specific content, generic
      mechanism) — mirrors RHCSA's existing `NEEDS_DISK` pattern exactly. A
      task declares `NEEDS_NODES=(node3 node4)` in `meta.sh`; new
      `_assign_task_nodes()` in `lib/exam.sh` (sibling to
      `_assign_task_disks()`) unions every selected task's declared nodes
      into `SESSION_NODES`, persisted in `exam.conf` (same convention as
      `MODE`/`RHEL_VERSION`) so every later command
      (`shell`/`grade`/`reset`/`destroy`) reads the same set.
      `certs/rhce/topology.sh`'s `topology_names()` builds `VM_NAMES` from
      `SESSION_NODES` instead of a hardcoded contiguous `node1..NODE_COUNT`
      range. **Live-verified**: a fixed exam-format session built only
      control+node3+node4 (not all 5) per its `NEEDS_NODES`; a training-pool
      task needing only `node1` built only control+node1 — confirmed via
      `incus list`, and `shell`/`grade`/`reset`/`destroy` all worked correctly
      against the sparse set.
- [x] The old `--nodes <1-5>` flag and its grep-based
      `_task_required_nodes`/`_filter_tasks_by_node_count` heuristic (which
      only derived a *count* from grepping script text for `node[1-5]`, not
      an actual subset, and over-counted almost universally since setup.sh
      conventionally writes a full 5-node inventory regardless of real need)
      are **removed outright** — breaking CLI change, intentional. Topology
      now always sizes itself to exactly what's declared, so the failure mode
      `--nodes` guarded against no longer exists.
- [x] Backfilled `NEEDS_NODES` onto 15 of the 55 existing `tasks/` tasks whose
      real footprint (content-derived, cross-checked against actual
      `ansible`/`ansible-playbook` execution in each task's `grade.sh` — not
      merely what a setup.sh inventory happens to list) is narrower than all
      5 nodes: 6 control-node-only (`NEEDS_NODES=()`), 9 single/dual-group.
      The other 40 tasks (mostly ones whose content targets `all`) are left
      with `NEEDS_NODES` unset — the safe default already equals the full
      5-node set, so no behavior change for them.
- [ ] **Found, not fixed** (pre-existing, unrelated to this feature):
      `certs/rhce/topology.sh`'s `/etc/hosts` entries (written during
      `topology_create`, before the pre-exam snapshot is taken) do not
      survive a `rhtr rhce reset` — confirmed live: after `reset`, `/etc/hosts`
      on control reverted to having no node entries at all, breaking SSH
      resolution for every subsequent `ansible-playbook` run. Likely a
      guest-disk-flush race between the `incus exec` write and Incus's
      block-level snapshot. Affects any RHCE session (both pools, unrelated
      to `NEEDS_NODES`) that runs `reset` — needs its own investigation
      (e.g. an explicit `sync` before `vm_snapshot_create`, or moving the
      `/etc/hosts` write to something reset-safe).

---

## Backlog / future

- [ ] RHCA / other cert support (same framework, new `certs/<cert>/` dir)
- [ ] Multi-session support (named sessions instead of single `.state/`)
- [ ] Web-based score report (HTML output from `grade`)
- [ ] Task contribution guide (`CONTRIBUTING.md`)
