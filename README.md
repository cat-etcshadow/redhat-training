# redhat-training

A CLI-driven lab environment for Red Hat certification exam practice and training.
Spins up preconfigured virtual machines via Incus, presents realistic exam tasks,
and grades your work automatically.

**Currently supported:** RHCSA (EX200)
**Planned:** RHCE (EX294)

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
rhtr rhcsa new --profile topic-selinux      # topic-only random exam
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
│   │       │   ├── topic-selinux.conf
│   │       │   └── topic-storage.conf
│   │       └── fixed/              # pinned task lists
│   │           ├── full-v1.conf
│   │           └── full-v2.conf
│   │
│   └── rhce/
│       ├── cert.conf
│       ├── topology.sh
│       ├── tasks/
│       │   ├── ch01-ansible-basics/
│       │   ├── ch03-inventory/
│       │   ├── ch04-playbooks/
│       │   ├── ch05-variables/
│       │   ├── ch06-tasks-control/
│       │   ├── ch07-files-jinja2/
│       │   ├── ch08-roles/
│       │   ├── ch09-vault/
│       │   └── ch10-troubleshooting/
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

One control node, two managed nodes. SSH keys pre-configured, Ansible installed,
inventory pre-written at `/home/student/inventory`.

| VM name | Role |
|---|---|
| `rhtr-rhce-control-<version>` | Ansible control node — candidate works here |
| `rhtr-rhce-node1-<version>` | Managed node 1 |
| `rhtr-rhce-node2-<version>` | Managed node 2 |

| Default RHEL | 9 |

Grade scripts run on the control node and verify results across managed nodes
using Ansible check-mode or direct SSH assertions.

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
