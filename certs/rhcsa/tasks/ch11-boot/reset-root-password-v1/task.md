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

> **Lab access (Incus VM):** The `rhtr rhcsa shell` command opens a root shell
> via the Incus agent — it bypasses PAM, so root's locked password doesn't
> matter there. To practice the full GRUB procedure, open the VM console from
> your **host** terminal before rebooting:
> ```
> incus console rhtr-rhcsa-server-10
> ```
> Then reboot the VM from inside (`reboot`) and press a key at the GRUB prompt.
> Press `Ctrl-a d` to detach from the console when done.
>
> **Training shortcut:** If you only want to verify the mechanics, use
> `rhtr rhcsa shell` to enter the VM and run `echo 'root:RedHat123!' | chpasswd`.
> The grader will pass either way — it checks the password, not the method.
