## Create and Format a Disk Partition via Ansible

Create a playbook **{{PLAYBOOK_FILE}}** for **prod** hosts that manages disk partitioning with error handling:

### Requirements:

Use `block`/`rescue` structure:

**BLOCK** section:
- Create a primary partition of size **{{PART_SIZE}}** on `/dev/{{DISK}}`
  - Use `community.general.parted` module
  - Partition number: 1
  - `part_type: primary`
  - `part_end` or `part_start`/`part_end` to specify size
- Format the partition with **{{FS_TYPE}}**
  - Use `ansible.builtin.filesystem`
  - `dev: /dev/{{DISK}}1`

**RESCUE** section:
- Print `"Could not create partition of that size"` using `ansible.builtin.debug`
- Create partition with fallback size **{{FALLBACK_SIZE}}** instead

**Additional:**
- If `/dev/{{DISK}}` does not exist, print `"this disk does not exist"` using a pre-check task with `failed_when`
- Use `become: true`
- The playbook must pass `--syntax-check`
