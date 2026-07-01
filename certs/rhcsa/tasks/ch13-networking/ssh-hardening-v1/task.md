## Harden sshd: disable root login and password authentication

Your task:

1. Configure `/etc/ssh/sshd_config` so that:
   - Root cannot log in over SSH (`PermitRootLogin no`)
   - Password authentication is disabled (`PasswordAuthentication no`)

2. Apply the changes to the running `sshd` service.
