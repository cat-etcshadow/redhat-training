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
      one block disk per selected `NEEDS_DISK=1` task; `topology_destroy`: delete VM
      + volumes

---

## Phase 3 — RHCSA task library ✓

188 tasks across 16 chapters (`ch01-tools` through `ch16-containers`). Each task
carries `meta.sh`, `task.md`, `setup.sh`, `grade.sh`, plus optional `params.sh`,
`hint.md`, and `solution.sh`. See the EX200 coverage table in README.md for the
full, current task list — the original per-chapter plan tracked here drifted out
of date as tasks were added and is no longer duplicated.

---

## Phase 4 — RHCSA exam profiles and fixed exams ✓

- [x] `certs/rhcsa/exams/profiles/full.conf` — balanced draw across all chapters
- [x] One per-chapter profile for each of the 16 chapters: `tools`, `scripting`,
      `users`, `permissions`, `selinux`, `performance`, `scheduling`, `packages`,
      `storage`, `lvm`, `boot`, `logging`, `networking`, `nfs`, `firewall`,
      `containers`
- [x] `certs/rhcsa/exams/fixed/full-v1.conf` — first curated fixed exam
- [x] `certs/rhcsa/exams/fixed/full-v2.conf` — second curated fixed exam (different variants)

---

## Phase 5 — End-to-end RHCSA validation

- [x] `rhtr rhcsa new --rhel 10 --profile full` completes without error
- [x] `rhtr rhcsa shell` opens VM shell (verified via `incus exec`)
- [x] `rhtr rhcsa grade` grades all tasks, produces score table
- [x] `rhtr rhcsa reset` restores snapshot and re-applies setups
- [x] `rhtr rhcsa destroy` removes VMs and clears state
- [x] `rhtr rhcsa list-tasks --rhel 8` filters correctly
- [x] `rhtr rhcsa progress` shows training history
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
- [x] One focused-practice profile per chapter: `ansible-basics.conf`,
      `navigator-git.conf`, `inventory.conf`, `playbooks.conf`, `variables.conf`,
      `tasks-control.conf`, `files-jinja2.conf`, `roles.conf`, `vault.conf`,
      `troubleshooting.conf`, `storage-lvm.conf`
- [x] `certs/rhce/exams/fixed/full-v1.conf`, `full-v2.conf`
- [x] Exam-format pool configs: `exams/profiles-exam/full.conf`,
      `exams/fixed-exam/webserver-stack-v1.conf`

---

## Phase 9 — Polish and ergonomics

- [ ] Bash/zsh shell completion script for `rhtr`
- [ ] `rhtr rhcsa status` — live timer display during exam
- [ ] Friendly error messages when Incus image is missing (prompt user with import command)
- [ ] Validate task library on load (all required files present, meta.sh parseable)
- [ ] `--dry-run` flag for `new` — show which tasks would be selected without starting VM
- [ ] Man page or `rhtr help <command>` per-command help

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
- [ ] **RHCE grading is static text-matching** — 41 of 55 `tasks/` `grade.sh`
      still only run `ansible-playbook --syntax-check` + `grep` for module
      names/strings in the playbook text, never executing against node state,
      so they're passable by keyword-stuffing a dead playbook. Rework the
      rest chapter by chapter to run the playbook and assert real state on
      `node1..node5`.

      Done: 14/55 — all 9 `ch04-playbooks`, all 3 `ch11-storage-lvm`, and 2
      `ch02-navigator-git`. Each runs the playbook as `student` and asserts
      with `ansible <group> -m command/shell` (rpm -q, systemctl is-active,
      firewall-cmd --query-*, getent, semanage fcontext -l, ls -Z, nmcli -g,
      lvs, blkid, findmnt, lsblk).

      Remaining, in rough priority order: ch06-tasks-control, ch07-files-jinja2,
      ch08-roles, ch05-variables, ch03-inventory, ch09-vault,
      ch10-troubleshooting, ch01-ansible-basics, and `git-playbook-repo-v1`
      (the one ch02 task still text-only).

      Supporting fixes made along the way, now permanent: control-node
      bootstrap installs `community.general` + `ansible.posix` (plain
      `ansible-core` ships zero collections, so every RHCE playbook module
      was missing); managed-node bootstrap installs `firewalld`,
      `python3-firewall`, `policycoreutils-python-utils`, `NetworkManager`
      for those modules' runtime deps; per-node task disks and the
      `nodesetup.sh` hook (see Phase 12d) unblocked the four LVM/partition
      tasks that previously targeted a volume group or disk that existed
      nowhere.

      **Not yet validated live:** only `selinux-playbook-v1` has been
      exercised end-to-end on real VMs. Unverified against a real Rocky 9
      node: the other reworked graders' exact module output formats
      (`nmcli -g` field ordering, `getsebool`/`semanage fcontext -l` shape),
      task-disk device enumeration, the LVM free-space math that forces the
      `rescue:` path, and whether device-name discovery resolves before
      `nodesetup.sh` runs without racing disk attachment.
- [x] **`container-user-service-v1` claims RHEL 10 but solution uses
      `podman generate systemd`** — removed in podman 5.x (RHEL 10). Capped
      `RHEL_VERSIONS` to `"8 9"` rather than attempting a Quadlet rewrite
      (tracked separately as `quadlet-service-v1` in 11g).
- [x] **Ctrl-C during `new`/`train` orphans VMs** — `lib/exam.sh:104` EXIT trap
      does `rm -rf "$STATE_DIR"` but never `topology_destroy`; aborted setup
      leaves Incus VMs behind while deleting the state that tracks them.
      Fixed via `_start_session_cleanup` in `lib/exam.sh`.
- [ ] **Task-params leak through the pushed script itself** — confirmed by live
      code read, 2026-07-25. `_run_task_script` (`lib/exam.sh:508-543`)
      prepends the *entire* `params.sh` output — every `KEY=value`, including
      values never surfaced via `{{...}}` in `task.md` — as plaintext into the
      wrapper script pushed into the VM and executed for both `setup.sh` and
      `grade.sh`. Since the student's own shell (`rhtr shell` → `incus shell`)
      is also root in the same VM, a task whose grader checks a hidden
      literal can be passed by reading the transient script during execution
      and fabricating the expected output instead of doing the work.
      Confirmed exploitable on `ch12-logging/journalctl-since-v1`: its
      `setup.sh` holds the wrapper file on disk for several seconds via a
      `while`+`sleep 1` loop (straddling a timestamp boundary on purpose),
      during which `KEEP_MESSAGE`/`DECOY_MESSAGE` — never shown in
      `task.md` — sit readable in `/tmp/rhtr-*.sh`. Independent of any
      hosting plans — undermines grading integrity today. Fix needs hidden
      params to stop being blanket-concatenated into every pushed script
      (e.g. inject only what `grade.sh`/`setup.sh` actually use, or pass
      hidden values via `incus exec`'s own environment rather than a
      `cat`-included file).

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
- [x] Duplicate `## Phase 9` heading in this file — merged

### 11e — Improve

- [ ] **Extend the linter to catch hint leaks structurally** (solves the
      recurring "models re-introduce hints" problem). `lib/lint.sh` ships and
      covers meta fields, script syntax, shellcheck, `{{placeholder}}`
      resolution, `NEEDS_*` requirements, conflicts, and — for the exam pool
      only — no `hint.md` and no module naming in task.md. Still missing:
      hint phrasing in training-pool task.md (`Note:`, `Tip:`, `you can`,
      `e.g. <command>`, man-page refs), params.sh vars unused by grade.sh,
      solution.sh referencing none of its params vars. Run in a pre-commit
      hook / CI so violations can't land
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

The `tasks/` pool is prescriptive by design: task.md names the exact module to
use and grade.sh greps the student's playbook source for it, failing a
different but equally valid module. Even the reworked graders that assert live
state keep one or two module-name greps as a gate. Good for *learning* which
module does what; not representative of EX294, which states an outcome only
and grades on live system state, never on how you got there.

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
      stricter than the reworked `tasks/` graders, which still keep 1-2
      module-name greps as a gate; this pool has zero source-inspection
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
- [x] **Per-node task disks + `nodesetup.sh`** — `NEEDS_DISK=1` combined with
      `NEEDS_NODES` now gives a task one dedicated block volume per listed
      managed node, recorded in `task-disks.txt` (`slug|gib|nodes|mib`) by
      `_assign_task_disks` and attached idempotently by
      `certs/rhce/topology.sh`, which also deletes them in
      `topology_destroy`. `NEEDS_DISK_SIZE_MIB` opts a task out of the shared
      whole-GiB counter when the disk's exact size is what makes the task
      work. `_generate_task_params` discovers the attached device's real
      kernel name by size-matching `lsblk` on the node and injects it as
      `$DISK`, replacing the fabricated `sdb` guesses that never matched how
      Incus VM disks enumerate. The new `nodesetup.sh` hook runs on a task's
      target nodes — `setup.sh`/`postsetup.sh` only ever run on `VM_NAMES[0]`
      — for state that must exist on the node itself. RHCSA is unaffected:
      with `NEEDS_NODES` unset the nodes column stays empty and the original
      `EXTRA_DISK_SIZES_GIB` path runs unchanged. `lib/lint.sh` knows the new
      params and scans `nodesetup.sh`; both certs lint clean.
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

## Phase 13 — Hosted paid-platform readiness (architecture review, 2026-07-25)

Findings from a full-repo review (`bin/rhtr`, all of `lib/*.sh`, both
`certs/*/topology.sh`, plus a spot-check of RHCSA/RHCE task graders) done
specifically to scope what stands between today's single-user local CLI and
a paid, multi-tenant hosted training site. This phase is a findings +
open-questions record, not a committed design — nothing below has been
implemented, and sequencing/scope hasn't been decided. See chat log
2026-07-25/26 for the full review and the questions put back to the repo
owner.

### 13a — Confirmed blockers: today's tool is hard-coded single-tenant

- [ ] Single global `.state/` dir anchored to the repo clone (`bin/rhtr:7`) —
      zero session/tenant ID anywhere; "one clone = one session" is enforced
      by convention (README), not code.
- [ ] Zero locking anywhere (`flock` appears nowhere in the codebase) —
      `grades.txt`, `exam.conf`, `active-tasks.txt`, and progress JSON are
      all read-modify-write with no protection; concurrent invocations
      against the same state corrupt or silently lose data.
- [ ] Training-progress history keyed only by OS `$HOME`
      (`lib/progress.sh`, `${XDG_DATA_HOME:-~/.local/share}/redhat-training/progress/`)
      — not per-tenant; two tenants on one host user would merge histories.
- [ ] VM names are a pure function of cert+RHEL-version
      (`rhtr-rhcsa-server-9`, `rhtr-rhce-control-9`, ...) with no
      session/user component — two concurrent same-cert-same-version
      sessions compute the *identical* VM name, and `topology_create` treats
      an existing VM as reusable rather than erroring, so a second session
      can literally take over a first session's live VM.
- [ ] Shared, singular Incus profile per cert (`rhtr-rhcsa`, `rhtr-rhce`)
      with hardcoded CPU/RAM — no per-tenant tiering possible without
      mutating a profile object shared by every VM that references it.
- [ ] Shared default network bridge and shared default storage pool for all
      VMs — an isolated bridge was considered and deliberately not adopted
      (Phase 6); no network segmentation between tenants exists today.
- [ ] `CERT` and profile/fixed/topic names arrive as raw CLI args and are
      used as unsanitized path components that get `source`d as bash
      (`bin/rhtr:76,82-83`; `lib/exam.sh:716-717,725-726`) — safe only
      because today's sole caller is a trusted local shell user; the moment
      any of this is reachable from a web form, it's arbitrary-file-source →
      host code execution.
- [ ] Cleanup/EXIT-trap coverage is narrow — only wraps session *creation*
      (`lib/exam.sh:117-124`); a killed/OOM'd process during
      `grade`/`shell`/`reset` leaks VMs and can wedge `.state/` until a human
      intervenes. Normal failure mode in a hosted backend (worker timeouts,
      OOM kills), not normal for a human at a terminal.
- [ ] The tool's whole execution model assumes its caller already has
      host-root-equivalent access (Incus group membership, sudo for agent
      bootstrap) — incompatible with an untrusted web-facing caller by
      design; needs a privileged broker layer in between, not a config
      tweak.

### 13b — Resource/capacity math (from actual code, for pricing & infra sizing)

- [ ] RHCSA session: 2 vCPU / 2 GiB / 1 VM + one block disk per disk-needing
      task (`certs/rhcsa/topology.sh`). RHCE full-topology session: 1 control +
      up to 5 nodes × 2 vCPU/1 GiB each = **12 vCPU / 6 GiB per session**
      (`certs/rhce/topology.sh:54-55` + launch loop) — RHCE is ~6x the
      footprint of RHCSA and CPU-bound, not RAM-bound.
- [ ] Rough math on a 32 vCPU / 128 GB box, no overcommit: ~16 concurrent
      RHCSA sessions vs. only ~2 concurrent full RHCE sessions. This is a
      real constraint on what a launch pricing/tier model can promise.
- [ ] RHCE provisioning is fully sequential — 6 VMs launched, agent-waited,
      and `dnf`/`ansible-galaxy`-provisioned one after another, no
      parallelism (`certs/rhce/topology.sh`) — realistic wall-clock is
      minutes for RHCSA, likely 5-15+ minutes for a full RHCE session. Not
      "instant" — matters for whether launch is on-demand-provision or a
      pre-warmed pool.
- [ ] No snapshot/VM expiry or TTL exists (README already notes
      `--expiry` as "not yet used") — abandoned/crashed sessions accumulate
      VM disk + block-volume usage indefinitely with no cleanup mechanism
      today.

### 13c — Grading integrity as a paid-product trust issue

- [ ] 41/55 RHCE training-pool `grade.sh` scripts only check playbook
      syntax/text, not live state (tracked in 11a) — for a paid product this
      is a direct refund/trust risk on the RHCE side specifically; RHCSA
      grading was independently re-verified as solid in this review
      (spot-checked ch03/05/09/11/16, all live-state).
- [ ] `lib/lint.sh` has no check for grading rigor at all (confirmed: its
      checks cover meta/syntax/shellcheck/placeholders/requirements/
      hint-leak/conflicts only) — nothing today stops a new task from
      shipping with a gameable grader, and nothing would have caught the
      task-params leak logged in 11a either.

### 13d — Open questions (not yet answered by the repo owner)

- [ ] Target hosting shape: single box vs. multiple hosts, on-prem
      (ji-p-pa01-style) vs cloud — drives whether "multi-tenant on one host"
      or "one VM-per-user across a fleet" is the right architecture.
- [ ] Whether RHCE ships at paid launch given its cost/latency profile, or
      RHCSA-only first.
- [ ] Auth/billing/web-frontend stack — zero code exists for any of this
      yet; entirely separate from the `rhtr` engine work.
- [ ] Legal/trademark posture — RHCSA/RHCE/EX200/EX294 are Red Hat marks; a
      paid, publicly marketed product using them needs at minimum a clear
      non-affiliation disclaimer.

---

## Backlog / future

- [ ] RHCA / other cert support (same framework, new `certs/<cert>/` dir)
- [ ] Multi-session support (named sessions instead of single `.state/`)
- [ ] Web-based score report (HTML output from `grade`)
- [ ] Task contribution guide (`CONTRIBUTING.md`)
