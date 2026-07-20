# redhat-training

A CLI-driven lab environment for Red Hat certification exam practice and training.
Spins up preconfigured virtual machines via Incus, presents realistic exam tasks,
and grades your work automatically.

**Currently supported:** RHCSA (EX200), RHCE (EX294)

**RHEL versions:** 8, 9, 10 (Rocky Linux official Generic Cloud images)

---

## Concept

The tool is intentionally exam-agnostic at its core. Every certification lives under
`certs/<cert>/` and brings its own VM topology, task library, and exam profiles.
The shared `lib/` and the `rhtr` CLI wire everything together.

Two modes exist:

- **Exam mode** (`rhtr rhcsa new`) — timed, no hints, graded at the end. Mirrors real exam conditions.
- **Train mode** (`rhtr rhcsa train`) — no timer, hints on request, solution shown after grading, progress tracked.

---

## How it works — Incus under the hood

Every session command eventually talks to **Incus**, the system container and VM manager,
through a small set of primitives. Here is what happens behind each `rhtr` command.

### `rhtr rhcsa new` — starting an exam

1. **Image check** — `vm_require_image rocky9` scans `incus image list` for the alias.
   If missing, it prints the exact `wget` + `incus image import` commands and exits.

2. **Profile** — `vm_profile_ensure rhtr-rhcsa` creates (or updates) a named Incus profile
   holding the VM-level config: `limits.cpu=2`, `limits.memory=2GiB`,
   `security.secureboot=false`. Profiles are reused across sessions so `incus launch`
   stays a one-liner and settings are never duplicated per VM.

3. **Launch** — `incus launch rocky9 rhtr-rhcsa-server-9 --vm --profile default --profile rhtr-rhcsa`
   boots a full hardware-virtualised VM from the QCOW2 image. The `default` profile
   provides the bridged NIC; `rhtr-rhcsa` provides the CPU/RAM/secureboot config.

4. **Agent wait** — `vm_wait_ready` polls `incus exec <vm> -- true` every 2 seconds until
   the Incus agent inside the VM responds. The agent is a small binary shipped in the
   QCOW2 image that lets Incus exec commands over virtio-vsock without SSH.

5. **Snapshot** — `incus snapshot create rhtr-rhcsa-server-9 pre-exam --reuse` takes an
   atomic snapshot of the pristine VM state. `--reuse` replaces an existing snapshot in
   one operation so there is never a window where no snapshot exists (needed for safe
   `reset`).

6. **Setup scripts** — for each selected task, `vm_exec_script` pushes `setup.sh` into
   the VM via `incus file push --mode 0700` (a file transfer over the agent channel),
   then runs it with `incus exec <vm> -- bash /tmp/rhtr-<pid>.sh`, then removes it.
   Pushing as a file avoids stdin-pipe issues in scripts that themselves read from stdin
   (e.g. `fdisk`, `passwd`).

### `rhtr rhcsa grade` — scoring your work

`vm_exec_script` runs `grade.sh` the same way. The script exits 0 for pass, non-zero for
fail. Output is captured and shown in train mode as a diagnostic. Points come from
`meta.sh`, not from the grader — the grader only signals pass/fail.

### `rhtr rhcsa reset` — restoring clean state

`incus snapshot restore rhtr-rhcsa-server-9 pre-exam` rolls the VM back to the
pre-exam snapshot in seconds (disk blocks are reverted, memory state is discarded).
After restore, `vm_wait_ready` polls the agent again, then all setup scripts re-run to
recreate the exam state from scratch.

### Why the official Rocky Linux QCOW2 — not `incus image import images:rocky/9`

The Incus community `images:` remote ships a **minimal** Rocky Linux image built for
containers and light VM use. It does not include the `incus-agent` binary, so
`incus exec` never connects — the agent poll loop would time out on every command.

More importantly, the minimal image boots with SELinux in **permissive** mode
(sometimes disabled entirely). RHCSA tasks covering SELinux context fixes, booleans,
and policy troubleshooting would be meaningless on a permissive system.

The **official Rocky Linux Generic Cloud QCOW2** from `download.rockylinux.org` ships:
- `incus-agent` pre-installed (virtio-vsock agent)
- SELinux enforcing from first boot
- `cloud-init` for first-boot configuration

That is the only supported image source.

---

## Installation

```bash
git clone git@github.com:cat-etcshadow/redhat-training.git
cd redhat-training
ln -s "$PWD/bin/rhtr" ~/.local/bin/rhtr
```

No build step. The symlink resolves back to the repo at runtime so the tool always
uses the current working copy.

**Requirements:** `incus`, `bash ≥ 5`, `shuf` (GNU coreutils), `python3` (for progress tracking)

Import the Rocky Linux base images you intend to use. Each version only needs to
be imported once.

```bash
# RHEL 9 (default)
wget https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
rhtr import-image rocky9 Rocky-9-GenericCloud-Base.latest.x86_64.qcow2

# RHEL 8
wget https://download.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2
rhtr import-image rocky8 Rocky-8-GenericCloud-Base.latest.x86_64.qcow2

# RHEL 10
wget https://download.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2
rhtr import-image rocky10 Rocky-10-GenericCloud-Base.latest.x86_64.qcow2
```

Use the **official Generic Cloud QCOW2** images only — see Known Constraints.

---

## CLI reference

```
rhtr <cert> <command> [options]
```

### Exam and train

```bash
rhtr rhcsa new                              # random full exam (default profile, default RHEL version)
rhtr rhcsa new --profile full               # explicit profile name
rhtr rhcsa new --profile selinux            # topic-only random exam
rhtr rhcsa new --fixed full-v1              # pinned fixed task list
rhtr rhcsa new --rhel 8                     # run against RHEL 8 (Rocky 8)
rhtr rhcsa new --rhel 10 --profile full     # flags combine freely

rhtr rhcsa train                            # full train session (all tasks, no timer)
rhtr rhcsa train --topic ch05-selinux       # train on one chapter
rhtr rhcsa train --difficulty hard          # filter by difficulty
rhtr rhcsa train --rhel 9                   # specify RHEL version
```

### During a session

```bash
rhtr rhcsa shell                            # open shell in exam VM
rhtr rhce  shell --node control             # RHCE: shell into specific node
rhtr rhce  shell --node node1
rhtr rhcsa hint                             # train mode only: show hint for current task
rhtr rhcsa grade                            # run all graders, print score report
rhtr rhcsa status                           # show timer, task count, current score if graded
```

### Session management

```bash
rhtr rhcsa reset                            # restore VM to pre-exam snapshot, re-apply setups
rhtr rhcsa destroy                          # delete VM(s) and clear .state/
```

### Discovery — no VM required

```bash
rhtr list-certs                             # all supported certs with default RHEL version

rhtr rhcsa list-topics                      # chapters available for this cert
rhtr rhcsa list-tasks                       # all tasks: title, points, difficulty, RHEL versions
rhtr rhcsa list-tasks --topic ch05-selinux  # filter by chapter
rhtr rhcsa list-tasks --difficulty hard     # filter by difficulty
rhtr rhcsa list-tasks --rhel 8              # only tasks compatible with RHEL 8

rhtr rhcsa list-profiles                    # random weighted profiles
rhtr rhcsa list-fixed                       # pinned fixed exam lists
rhtr rhcsa show ch05-selinux/fix-file-context-v1   # print task.md for one task

rhtr rhcsa progress                         # training history table: pass rate per task
rhtr rhcsa progress --topic ch05-selinux    # filter progress by chapter

rhtr rhcsa lint                             # static checks: all tasks + profiles + fixed lists, no VM
rhtr rhcsa lint ch05-selinux/fix-file-context-v1   # lint a single task
rhtr rhcsa lint --topic ch05-selinux        # lint one chapter's tasks only
```

---

## Repo layout

```
redhat-training/
├── bin/
│   └── rhtr                        # CLI entry point — symlink target
│
├── lib/
│   ├── core.sh                     # die, log, color output, path helpers
│   ├── vm.sh                       # Incus VM lifecycle (cert-agnostic)
│   ├── select.sh                   # task selection: random weighted / fixed / topic
│   ├── exam.sh                     # exam + train orchestration, timer, display
│   └── report.sh                   # grading loop, scoring, output formatting
│
├── certs/
│   ├── rhcsa/
│   │   ├── cert.conf               # cert metadata
│   │   ├── topology.sh             # how to build and tear down the VM environment
│   │   ├── tasks/
│   │   │   ├── ch03-users/
│   │   │   │   ├── create-users-v1/
│   │   │   │   ├── create-users-v2/
│   │   │   │   └── sudo-nopasswd-v1/
│   │   │   ├── ch04-permissions/
│   │   │   ├── ch05-selinux/
│   │   │   ├── ch06-performance/
│   │   │   ├── ch07-scheduling/
│   │   │   ├── ch08-packages/
│   │   │   ├── ch09-storage/
│   │   │   ├── ch10-lvm/
│   │   │   ├── ch11-boot/
│   │   │   ├── ch12-logging/
│   │   │   ├── ch13-networking/
│   │   │   ├── ch14-nfs/
│   │   │   ├── ch15-firewall/
│   │   │   └── ch16-containers/
│   │   └── exams/
│   │       ├── profiles/           # random weighted draw profiles
│   │       │   ├── full.conf
│   │       │   ├── selinux.conf
│   │       │   └── storage.conf
│   │       └── fixed/              # pinned task lists
│   │           ├── full-v1.conf
│   │           └── full-v2.conf
│   │
│   └── rhce/
│       ├── cert.conf
│       ├── topology.sh
│       ├── tasks/
│       │   ├── ch01-ansible-basics/
│       │   ├── ch02-navigator-git/
│       │   ├── ch03-inventory/
│       │   ├── ch04-playbooks/
│       │   ├── ch05-variables/
│       │   ├── ch06-tasks-control/
│       │   ├── ch07-files-jinja2/
│       │   ├── ch08-roles/
│       │   ├── ch09-vault/
│       │   ├── ch10-troubleshooting/
│       │   └── ch11-storage-lvm/
│       └── exams/
│           ├── profiles/
│           └── fixed/
│
├── .state/                         # gitignored — runtime state of active session
│   ├── cert                        # which cert is active: "rhcsa" | "rhce"
│   ├── exam.conf                   # session metadata
│   ├── active-tasks.txt            # selected task dirs, one per line
│   └── grades.txt                  # results after grading
│
└── README.md
```

---

## Task anatomy

Every task is a self-contained directory. The same structure works across all certs.

```
tasks/ch05-selinux/fix-file-context-v1/
├── meta.sh         # required
├── task.md         # required
├── setup.sh        # required — creates the exam state on the VM
├── postsetup.sh    # optional — runs after every selected task's setup.sh
├── grade.sh        # required — exit 0 = pass, exit 1 = fail
├── hint.md         # optional — shown in train mode on request
└── solution.sh     # optional — shown after grading in train mode
```

### meta.sh

```bash
POINTS=8
TOPIC="selinux"
CHAPTER=5
TITLE="Fix SELinux file context on web directory"
DIFFICULTY="medium"       # easy | medium | hard
RHEL_VERSIONS="8 9 10"   # space-separated; omit a version if the task is incompatible
```

`RHEL_VERSIONS` tells the selector which base images this task can run against.
A task that uses `semanage` syntax that changed in RHEL 10 would set `RHEL_VERSIONS="8 9"`.
The selector silently skips incompatible tasks when drawing for a specific `--rhel` version.

### grade.sh contract

- Runs as root inside the VM via `incus exec`
- `exit 0` = task passed
- `exit 1` (or any non-zero) = task failed
- Should print a short diagnostic line before exiting on failure
- Must be idempotent — can be run multiple times without side effects

### setup.sh contract

- Runs as root inside the VM before the exam starts
- Creates the "broken" or "unconfigured" state the candidate must fix
- Must clean up any previous state (re-runnable for `rhtr reset`)

---

## Exam profiles

### Random weighted (`exams/profiles/full.conf`)

```bash
NAME="Full RHCSA Exam"
DURATION=150          # minutes
PASS_THRESHOLD=70     # percent of total points

TOPICS=(
  "ch03-users:2"        # draw 2 random tasks from this chapter
  "ch04-permissions:1"
  "ch05-selinux:2"
  "ch07-scheduling:1"
  "ch09-storage:2"
  "ch10-lvm:1"
  "ch11-boot:1"
  "ch13-networking:1"
  "ch15-firewall:1"
)
```

Each run draws a different combination of task variants. The total points float
depending on which tasks land. Pass threshold is always `≥PASS_THRESHOLD%` of
whatever the actual total is — not a fixed 70/100.

### Fixed list (`exams/fixed/full-v1.conf`)

```bash
NAME="Full RHCSA Exam v1"
DURATION=150
PASS_THRESHOLD=70

FIXED_TASKS=(
  "ch03-users/create-users-v1"
  "ch03-users/sudo-nopasswd-v1"
  "ch05-selinux/fix-file-context-v1"
  "ch09-storage/add-partition-xfs-v1"
  "ch10-lvm/create-lv-v1"
  "ch11-boot/reset-root-password-v1"
  "ch13-networking/hostname-dns-v1"
  "ch15-firewall/add-service-v1"
)
```

Paths are relative to `certs/<cert>/tasks/`. Fixed exams are reproducible —
useful for sharing or re-attempting the same set.

---

## VM topologies

The RHEL version is selected with `--rhel <8|9|10>` at session start and stored in
`.state/exam.conf`. The topology script maps version → image alias (`rocky8`, `rocky9`,
`rocky10`). VM names embed the version so two sessions against different RHEL versions
can coexist: `rhtr-rhcsa-server-9`, `rhtr-rhcsa-server-8`.

### RHCSA

One VM, one extra block disk for storage and LVM tasks.

| Resource | Value |
|---|---|
| VM name | `rhtr-rhcsa-server-<version>` |
| Base image | `rocky8` / `rocky9` / `rocky10` |
| Default RHEL | 9 |
| CPU / RAM | 2 vCPU / 2 GB |
| Extra disk | 4 GB block volume for partitioning / LVM tasks |

### RHCE

One control node, five managed nodes. SSH keys pre-configured from control to
every node. Control node has `ansible-core`, `ansible-navigator`, `podman`,
and `git` installed; each task's own `setup.sh`/`params.sh` writes its
inventory and playbook paths under `/home/student/ansible/`.

| VM name | Role |
|---|---|
| `rhtr-rhce-control-<version>` | Ansible control node — candidate works here |
| `rhtr-rhce-node1-<version>` | Managed node (dev) |
| `rhtr-rhce-node2-<version>` | Managed node (test) |
| `rhtr-rhce-node3-<version>` | Managed node (prod) |
| `rhtr-rhce-node4-<version>` | Managed node (prod) |
| `rhtr-rhce-node5-<version>` | Managed node (balancers) |

| Default RHEL | 9 |

Grading is mostly static: `grade.sh` validates playbook/config YAML,
`--syntax-check`, and required module/parameter usage via targeted greps.
Some tasks additionally run the playbook for real (e.g. `ansible-navigator
run`) and assert on its output.

---

## Scoring

Points come from each task's `meta.sh`. The total varies per session.

```
Score = (sum of POINTS for passed tasks) / (sum of POINTS for all tasks) × 100
Pass  = Score ≥ PASS_THRESHOLD (default 70%)
```

After `rhtr <cert> grade`:

```
  [PASS] Task  1: create-users-v1           10 pts
  [FAIL] Task  2: fix-file-context-v1        8 pts
  [PASS] Task  3: reset-root-password-v1    10 pts
  ...
  ──────────────────────────────────────────────
  Score: 68 / 86  (79%)
  Result: PASS  (threshold: 70%)
```

---

## Session state

All runtime state lives in `.state/` (gitignored). Only one session can be active
at a time per repo clone. If you need to run two sessions simultaneously, use two
clones.

```
.state/cert                 # active cert name
.state/exam.conf            # NAME, DURATION, PASS_THRESHOLD, MODE, DEADLINE_EPOCH
.state/active-tasks.txt     # absolute paths of selected tasks, ordered
.state/grades.txt           # task_path|PASS|pts_earned|pts_total  (post-grade)
```

---

## Training progress

Train-mode results are persisted per task in `~/.redhat-training/progress/`.

```
~/.redhat-training/progress/
├── rhcsa/
│   └── ch05-selinux__fix-file-context-v1.json
└── rhce/
    └── ch04-playbooks__basic-playbook-v1.json
```

Each file:
```json
{ "attempts": 3, "passes": 2, "last_attempted": "2026-06-23" }
```

`rhtr rhcsa progress` renders this as a table. The task selector can optionally
weight against recently-passed tasks to surface weaker areas.

---

## Adding a new certification

1. Create `certs/<cert>/cert.conf`:

```bash
CERT_NAME="RHCSA"
CERT_FULL_NAME="Red Hat Certified System Administrator"
EXAM_CODE="EX200"
PASS_THRESHOLD=70
DEFAULT_DURATION=150
DEFAULT_RHEL_VERSION=9
RHEL_VERSIONS="8 9 10"
```

2. Create `certs/<cert>/topology.sh` implementing `topology_create` and `topology_destroy`.
   Both functions receive `$RHEL_VERSION` from the session environment.

3. Create `certs/<cert>/tasks/<chapter>/<task-variant>/` with the four required files.

4. Create at least one profile in `certs/<cert>/exams/profiles/`.

The `rhtr` CLI picks up the new cert automatically — no changes to `lib/` needed.

---

## Incus features used

| Feature | Where | Why |
|---|---|---|
| **Profiles** | `topology.sh` per cert | Reusable VM config (CPU/RAM/secureboot) — `incus launch` stays a one-liner |
| **`snapshot create --reuse`** | `lib/vm.sh` | Atomic snapshot replacement — no window without a snapshot during reset |
| **`file push --mode`** | `lib/vm.sh` | Scripts pushed as real files; avoids stdin issues in grade/setup scripts that read input themselves |
| **Isolated bridge network** | `certs/rhce/topology.sh` (planned) | Managed nodes reachable only from control — mirrors real RHCE topology |
| **`cloud-init.user-data`** | `certs/rhce/topology.sh` (planned) | First-boot managed node config (ansible user, SSH key, Python) without post-boot scripts |

**Not yet used but available if needed:**
- `--project rhtr` scoping — isolate all rhtr VMs from other Incus workloads
- `snapshot create --expiry` — auto-expire stale snapshots
- `incus monitor` — live JSON event stream for a real-time status display

---

## Known constraints and notes

- The Rocky Linux 9 base image must use the **official Generic Cloud QCOW2** from
  rockylinux.org, not the `images:` remote. The Incus `images:` remote ships a
  stripped image without SELinux; `setenforce 1` kills the Incus agent on that image.
- VM snapshots use `incus snapshot create` / `incus snapshot restore` — the restore
  command is `incus snapshot restore <instance> <snapshot>`, not `incus restore`.
- Extra block volumes for RHCSA storage tasks must be created with `--type=block`;
  filesystem-type volumes cannot be attached to VMs.
- Launching the VM with `security.secureboot=false` avoids a known `blk_mq_get_tag`
  kernel panic on first boot.

---

## Task library: EX200 exam coverage

**Total tasks: 188 — 165 exam-aligned, 21 extra, 2 borderline**

> **Legend**
> - `exam` — directly maps to an official EX200 objective
> - `extra` — good practice, but not an explicit EX200 objective
> - `borderline` — not in the published objective list, but may appear on the actual exam

Current EX200 objectives target RHEL 10; tasks are marked `exam` if they map to a
currently published objective, regardless of which `RHEL_VERSIONS` they run against.

| Chapter | Topic | Tasks | Exam | Extra | Task names |
|---|---|---|---|---|---|
| ch01-tools | Essential commands | 16 | 16 | — | archive-compress-v1, archive-compress-v2, find-exec-v1, find-files-v1, find-mtime-v1, grep-extended-v1, grep-regex-v1, io-redirect-v1, links-v1, man-docs-v1, scp-transfer-v1, sort-uniq-v1, ssh-remote-exec-v1, switch-user-v1, tar-selective-v1, vim-edit-v1 |
| ch02-scripting | Shell scripting | 14 | 14 | — | scripting-args-v1, scripting-arithmetic-v1, scripting-arrays-v1, scripting-case-v1, scripting-defaults-v1, scripting-exit-codes-v1, scripting-for-files-v1, scripting-for-list-v1, scripting-functions-v1, scripting-getopts-v1, scripting-heredoc-v1, scripting-if-v1, scripting-until-v1, scripting-while-v1 |
| ch03-users | Users and groups | 12 | 12 | — | account-expiry-v1, create-users-v1, create-users-v2, delete-user-v1, group-batch-membership-v1, group-membership-v1, password-aging-v1, sudo-nopasswd-v1, sudo-wheel-group-v1, troubleshoot-account-access-v1, useradd-custom-v1, usermod-lock-v1 |
| ch04-permissions | Permissions | 10 | 9 | 1 | acl-mask-v1, acl-revoke-v1, acl-v1, ~~chattr-immutable-v1~~, fix-perms-v1, numeric-perms-v1, setgid-dir-v1, sticky-bit-v1, suid-sgid-audit-v1, umask-v1 |
| ch05-selinux | SELinux | 12 | 12 | — | boolean-httpd-v1, boolean-nfs-v1, fix-file-context-v1, fix-file-context-v2, selinux-boolean-ftp-v1, selinux-boolean-set-v1, selinux-mode-v1, selinux-port-ssh-v1, selinux-port-v1, selinux-process-context-v1, selinux-restorecon-v1, troubleshoot-audit-v1 |
| ch06-performance | Process management | 9 | 9 | — | disown-background-v1, job-control-v1, kill-signals-v1, nice-launch-v1, process-priority-v1, ps-filter-report-v1, top-batch-report-v1, troubleshoot-runaway-process-v1, tuned-profile-v1 |
| ch07-scheduling | Scheduling | 10 | 9 | 1 | at-batch-v1, at-job-v1, at-manage-v1, cron-dow-v1, cron-env-v1, cron-job-v1, cron-system-v1, systemd-timer-v1, ~~tmpfiles-v1~~, troubleshoot-missed-backup-v1 |
| ch08-packages | Software management | 12 | 10 | 2 | ~~dnf-autoremove-v1~~, dnf-config-manager-v1, dnf-group-v1, ~~dnf-history-undo-v1~~, dnf-install-v1, dnf-local-rpm-v1, dnf-module-v1, dnf-reinstall-v1, dnf-search-provides-v1, flatpak-v1, repo-enable-v1, troubleshoot-repo-install-v1 |
| ch09-storage | Local storage | 13 | 10 | 3 | add-partition-ext4-v1, add-partition-gpt-v1, add-partition-vfat-v1, add-partition-xfs-v1, delete-partition-v1, ~~fstab-noauto-v1~~, ~~mount-options-v1~~, persistent-mount-label-v1, persistent-mount-uuid-v1, ~~resize-partition-v1~~, swap-file-v1, swap-partition-v1, troubleshoot-app-data-mount-v1 |
| ch10-lvm | LVM | 11 | 8 | 3 | create-lv-v1, extend-lv-ext4-v1, extend-lv-v1, lv-ext4-v1, lv-extend-percentage-v1, lv-remove-v1, ~~lv-rename-v1~~, ~~lvm-snapshot-v1~~, ~~stratis-pool-v1~~, troubleshoot-lv-inactive-v1, vg-extend-v1 |
| ch11-boot | Boot process | 13 | 12 | 1 | boot-target-v1, custom-unit-v1, disable-service-v1, fix-broken-service-v1, grub-param-v1, grub-timeout-v1, grubby-remove-param-v1, isolate-target-v1, reboot-shutdown-v1, repair-fstab-v1, reset-root-password-v1, service-enable-v1, ~~service-mask-v1~~ |
| ch12-logging | Logging and time | 11 | 8 | 3 | ~~chrony-server-v1~~, journalctl-priority-v1, journalctl-since-v1, journalctl-v1, journalctl-vacuum-v1, journald-persistent-v1, journald-size-v1, ~~logrotate-v1~~, ntp-toggle-v1, ~~rsyslog-rule-v1~~, timedatectl-v1 |
| ch13-networking | Networking | 13 | 11 | 2 | dns-resolver-v1, dns-search-domain-v1, hostname-dns-v1, ipv6-addr-v1, ~~nmcli-bond-v1~~, nmcli-connection-add-v1, nmcli-secondary-ip-v1, routing-v1, ~~ssh-hardening-v1~~, ssh-key-auth-v1, static-ip-v1, troubleshoot-connectivity-v1, troubleshoot-ssh-keyauth-v1 |
| ch14-nfs | NFS / Autofs | 8 | 5 | 3 | autofs-direct-v1, autofs-v1, ~~nfs-automount-systemd-v1~~, ~~nfs-export-v1~~, nfs-mount-options-v1, nfs-mount-v1, nfs-unmount-v1, ~~showmount-v1~~ |
| ch15-firewall | Firewall | 10 | 10 | — | firewall-add-port-v1, firewall-add-service-v1, firewall-default-zone-v1, firewall-masquerade-v1, firewall-port-forward-v1, firewall-remove-service-v1, firewall-rich-rule-v1, firewall-runtime-permanent-v1, firewall-zone-v1, troubleshoot-service-unreachable-v1 |
| ch16-containers | Containers | 14 | 10 | 4 | container-env-v1, container-exec-logs-v1, ~~container-healthcheck-v1~~, container-lifecycle-v1, container-network-v1, container-registry-v1, ~~container-resource-limits-v1~~, container-service-v1, container-storage-v1, container-user-service-v1, run-container-v1, troubleshoot-container-boot-v1, *container-build-v1*, *container-inspect-v1* |
| **Total** | | **188** | **165** | **21** | *italic* = borderline |

### Extra tasks (21)

| Task | Why it's extra |
|---|---|
| `ch04/chattr-immutable-v1` | File immutability via `chattr`/`lsattr` is not an explicit EX200 objective |
| `ch07/tmpfiles-v1` | tmpfiles.d management is not an EX200 objective |
| `ch08/dnf-history-undo-v1` | `dnf history undo` is not an explicit EX200 objective verb |
| `ch08/dnf-autoremove-v1` | Orphaned-dependency cleanup with `dnf autoremove` is not an explicit EX200 objective |
| `ch09/mount-options-v1` | Hardened mount options (nosuid/nodev/noexec) are not explicitly named in EX200 objectives |
| `ch09/fstab-noauto-v1` | `noauto`/`user` mount options are not explicitly named in EX200 objectives |
| `ch09/resize-partition-v1` | EX200 only lists extending logical volumes, not plain partitions |
| `ch10/stratis-pool-v1` | Stratis is not in the current EX200 exam |
| `ch10/lvm-snapshot-v1` | LVM snapshots are not in the current EX200 exam objectives |
| `ch10/lv-rename-v1` | `lvrename` is not an explicit EX200 objective verb |
| `ch11/service-mask-v1` | `systemctl mask` is not an explicit EX200 objective verb |
| `ch12/chrony-server-v1` | EX200 tests NTP client sync, not running your own NTP server |
| `ch12/rsyslog-rule-v1` | Advanced rsyslog routing rules are not in EX200 objectives |
| `ch12/logrotate-v1` | Logrotate configuration is not an explicit EX200 objective |
| `ch13/nmcli-bond-v1` | Network bonding is not in EX200 networking objectives |
| `ch13/ssh-hardening-v1` | Disabling root/password SSH login is good practice but not an explicit EX200 objective |
| `ch14/nfs-automount-systemd-v1` | `x-systemd.automount` is an alternative to autofs, not the technique named in EX200 objectives |
| `ch14/nfs-export-v1` | EX200 tests NFS client (mount/autofs), not NFS server configuration |
| `ch14/showmount-v1` | Requires configuring an NFS *server* export — EX200 only tests the NFS *client* role |
| `ch16/container-healthcheck-v1` | Container health checks are not an explicit EX200 objective |
| `ch16/container-resource-limits-v1` | Memory/CPU limits on containers are not an explicit EX200 objective |

### Borderline tasks (2)

| Task | Note |
|---|---|
| `ch16/container-build-v1` | Building from a Containerfile is not in the published objective list but may appear in practice |
| `ch16/container-inspect-v1` | `podman inspect` is not explicit in objectives but is useful exam knowledge |

---

## Task library: EX294 exam coverage

**Total tasks: 55 — all exam-aligned**

| Chapter | Topic | Tasks | Exam | Extra | Task names |
|---|---|---|---|---|---|
| ch01-ansible-basics | Ansible fundamentals | 6 | 6 | — | ad-hoc-command-v1, ansible-cfg-advanced-v1, ansible-doc-v1, install-configure-v1, managed-nodes-v1, privilege-escalation-v1 |
| ch02-navigator-git | ansible-navigator, Execution Environments, Git | 3 | 3 | — | ansible-navigator-config-v1, execution-environment-v1, git-playbook-repo-v1 |
| ch03-inventory | Inventory | 4 | 4 | — | group-vars-v1, host-vars-v1, static-inventory-v1, yaml-inventory-v1 |
| ch04-playbooks | Playbooks | 9 | 9 | — | error-handling-v1, firewall-playbook-v1, nmcli-playbook-v1, packages-playbook-v1, packages-playbook-v2, selinux-playbook-v1, service-playbook-v1, user-group-playbook-v1, yum-repo-playbook-v1 |
| ch05-variables | Variables and facts | 4 | 4 | — | custom-facts-v1, hwreport-v1, registered-vars-v1, set-fact-v1 |
| ch06-tasks-control | Task control | 8 | 8 | — | block-rescue-v1, conditionals-v1, cron-playbook-v1, handlers-v1, include-tasks-v1, issue-file-v1, loops-v1, tags-v1 |
| ch07-files-jinja2 | Files and templates | 4 | 4 | — | archive-fetch-v1, gen-hosts-v1, lineinfile-v1, template-motd-v1 |
| ch08-roles | Roles and collections | 6 | 6 | — | collections-posix-v1, create-role-v1, galaxy-requirements-v1, role-defaults-v1, system-roles-selinux-v1, system-roles-timesync-v1 |
| ch09-vault | Ansible Vault | 4 | 4 | — | create-vault-v1, rekey-vault-v1, use-vault-users-v1, vault-group-vars-v1 |
| ch10-troubleshooting | Troubleshooting | 4 | 4 | — | check-diff-mode-v1, debug-vars-v1, fix-logic-v1, fix-syntax-v1 |
| ch11-storage-lvm | Storage automation | 3 | 3 | — | lvm-playbook-v1, lvm-playbook-v2, partition-playbook-v1 |
| **Total** | | **55** | **55** | **0** | |

### Deliberately excluded

The EX294 objectives page also lists a VS Code editor workflow (playbook creation,
`ansible-navigator` integration inside VS Code, running playbooks from dev
containers via the editor). That's not testable by a headless `grade.sh` in a
VM with no GUI or editor state to assert on, so it's intentionally not
represented as a task here. Everything else on the objectives page has a
corresponding task.
