## Distinguish runtime and permanent firewalld changes

Your task:

1. Add the **ftp** service to the **public** zone for the **current
   running configuration only** — it must **not** be present after a
   `firewall-cmd --reload`.
2. Add the **smtp** service to the **public** zone **permanently**, and
   make sure it also takes effect in the current running configuration.
3. When you are done, the running configuration must have **both** ftp
   and smtp active, but the permanent configuration must have **only**
   smtp.
