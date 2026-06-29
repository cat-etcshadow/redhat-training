## Reset the root password via emergency boot

The root password has been changed and is now unknown. You must recover it
through the GRUB boot loader.

**This task requires interactive intervention at the GRUB prompt.**

Your task:

1. Reboot the system and interrupt the GRUB countdown to edit the boot entry.
2. Add the appropriate kernel parameter to break into an early emergency shell.
3. At the emergency prompt, remount `/sysroot` read-write and chroot into it.
4. Reset the root password.
5. Ensure SELinux will relabel the affected files on next boot before exiting.
6. Exit chroot and allow the system to boot normally.

**For exam simulation**: the grader checks if root's password was changed
after setup time. Set it to **RedHat123!**
