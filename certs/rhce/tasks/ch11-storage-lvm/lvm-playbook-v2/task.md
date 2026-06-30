## Create LVM Logical Volume with Persistent Mount

Create a playbook **{{PLAYBOOK_FILE}}** for **prod** hosts that creates a logical volume and mounts it persistently:

### Tasks (in order):

1. Create logical volume **{{LV_NAME}}** of size **{{LV_SIZE}}** in volume group **{{VG_NAME}}**
   - Use `community.general.lvol`

2. Format the logical volume with **{{FS_TYPE}}** filesystem
   - Use `ansible.builtin.filesystem`
   - `dev: /dev/{{VG_NAME}}/{{LV_NAME}}`

3. Mount the logical volume **persistently** at **{{MOUNT_POINT}}**
   - Use `ansible.builtin.mount`
   - `src: /dev/{{VG_NAME}}/{{LV_NAME}}`
   - `path: {{MOUNT_POINT}}`
   - `fstype: {{FS_TYPE}}`
   - `state: mounted`

Requirements:
- Use `become: true`
- `ansible.builtin.mount` with `state: mounted` is required
- `{{LV_SIZE}}` and `{{FS_TYPE}}` must be referenced
- `{{MOUNT_POINT}}` must be referenced
- The playbook must pass `--syntax-check`
