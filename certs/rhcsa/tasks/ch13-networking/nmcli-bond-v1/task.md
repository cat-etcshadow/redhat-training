## Create a network bond with nmcli

Create a network bond for link redundancy.

Your task:

1. Create a bond interface named **bond0** with mode **active-backup**.
2. Assign the static IP **10.10.0.1/24** to bond0.
3. Bring bond0 up and verify with `ip addr show bond0`.

> **Lab note:** This VM has a single NIC, so you cannot add a real slave/port
> (the bond will have no member interfaces). On the real EX200 exam, you would also
> add the second NIC as a slave.
> The grader checks for bond0 existence, mode, and IP — not for slave membership.
