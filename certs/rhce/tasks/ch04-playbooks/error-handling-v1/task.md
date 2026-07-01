## LVM Error Handling with block/rescue/always

Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that uses `block`, `rescue`, and `always` to handle LVM logical volume creation:

**BLOCK** section:
- Create a logical volume named `data` of size **{{LV_SIZE}}** in volume group `research`
- Use `community.general.lvol` module

**RESCUE** section:
- Print the message `"could not create logical volume of that size"` using `ansible.builtin.debug`
- Attempt to create the logical volume with the fallback size **{{FALLBACK_SIZE}}** instead

**ALWAYS** section:
- Print `"LVM task complete"` using `ansible.builtin.debug`

Additional requirements:
- Use `become: true`
- The playbook must pass `--syntax-check`
- All three sections (`block:`, `rescue:`, `always:`) must be present
