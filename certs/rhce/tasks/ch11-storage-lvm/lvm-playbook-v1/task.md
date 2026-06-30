## Create LVM Logical Volume with Error Handling

Create a playbook **{{PLAYBOOK_FILE}}** for **all** hosts that manages LVM storage with proper error handling:

### Requirements:

Use `block`/`rescue` structure:

**BLOCK** section:
- Create a logical volume `{{LV_NAME}}` of size **{{LV_SIZE}}** in volume group **{{VG_NAME}}**
- Use `community.general.lvol` module
- If the VG does not exist, use `failed_when` or let the module fail naturally
- Format the LV with filesystem type **{{FS_TYPE}}** using `ansible.builtin.filesystem`

**RESCUE** section:
- Print the message `"could not create logical volume of that size"` using `ansible.builtin.debug`
- Attempt to create the logical volume with fallback size **{{FALLBACK_SIZE}}** instead

**Additional requirements:**
- If the volume group `{{VG_NAME}}` does not exist, print `"volume group does not exist"`
- Use `become: true`
- Do **NOT** mount the logical volume
- The playbook must pass `--syntax-check`

Verify:
```
ansible-playbook --syntax-check {{PLAYBOOK_FILE}}
```
