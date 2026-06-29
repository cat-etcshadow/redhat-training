## Create a network bond with nmcli

Create a network bond for link redundancy.

Your task:

1. Create a bond interface named **bond0** with mode **active-backup**.
2. Add the second ethernet NIC as a slave/port to bond0.
   (Find it with `nmcli device status` — it will be the NIC that is
   not the primary connected interface.)
3. Assign the static IP **10.10.0.1/24** to bond0.
4. Bring bond0 up and verify with `ip addr show bond0`.
