## Create an LVM snapshot of a logical volume

The logical volume **{{LV_NAME}}** (in volume group **{{VG_NAME}}**) is
mounted at **{{MOUNT_POINT}}** and holds important data. A risky change is
about to be made to it.

Your task:

Create an LVM **snapshot** named **{{SNAP_NAME}}** of **{{LV_NAME}}**, with
a size of **{{SNAP_SIZE}}**, so the current state can be rolled back to if
needed.
