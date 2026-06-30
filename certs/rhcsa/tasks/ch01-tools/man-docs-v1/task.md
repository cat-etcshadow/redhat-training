## Locate and use system documentation

The exam environment has no internet access. You must use `man` pages and
on-system documentation to find the options you need.

Your task:

1. Use `man cp` to locate the option that copies files in **archive mode**
   (preserves permissions, timestamps, ownership, and symbolic links — equivalent
   to `-dR --preserve=all`). Copy `/etc/hosts` to **{{DEST_FILE}}** using that option.

2. Use `man find` to locate the option that filters by **file size in megabytes**.
   Find all files in `/var/log` larger than **1 MB** and write the list to **{{OUTPUT_FILE}}**.
