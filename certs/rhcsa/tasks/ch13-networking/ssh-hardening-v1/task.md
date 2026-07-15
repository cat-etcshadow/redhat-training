## Harden sshd: disable root login and password authentication

Configure `/etc/ssh/sshd_config` so that root cannot log in over SSH (`PermitRootLogin no`) and password authentication is disabled (`PasswordAuthentication no`), and apply the changes to the running `sshd` service.
