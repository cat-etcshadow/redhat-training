## Distinguish runtime and permanent firewalld changes

Add the **ftp** service to the **public** zone for the current running configuration only, so that it is not present after a `firewall-cmd --reload`, and add the **smtp** service to the **public** zone permanently so that it also takes effect in the current running configuration. When done, the running configuration must have both ftp and smtp active, but the permanent configuration must have only smtp.
