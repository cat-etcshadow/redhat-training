## Create a new NetworkManager connection profile with nmcli

Your task:

1. Create a new NetworkManager connection profile named **{{CON_NAME}}**,
   of type `dummy`, for interface **{{IFACE_NAME}}**.

2. Configure it with a static IPv4 address of **{{IP_ADDR}}** (method
   manual).

3. Set the profile to **not** auto-connect at boot.

4. Bring the connection up manually and verify the address is applied to
   **{{IFACE_NAME}}**.
