## Hint

- `block:`, `rescue:`, and `always:` are siblings at the task level (same indentation)
- `rescue:` runs only if a task in `block:` fails
- `always:` runs regardless of whether block succeeded or failed
- `community.general.lvol`: `vg` = volume group name, `lv` = logical volume name, `size` = size
- Size format: `1200m` (megabytes), `1g` (gigabytes), `100%FREE`
- The rescue block does not prevent the play from continuing — after rescue, execution resumes normally
- If the VG doesn't exist, `lvol` will fail — rescue handles this gracefully
