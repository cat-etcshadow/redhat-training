## Hint

- `podman search <term>` — searches all registries in `registries.conf`
- `podman pull registry.access.redhat.com/ubi9/ubi` — always use fully qualified names to avoid ambiguity
- `podman tag <source> <new-name>:<tag>` — create an alias (no data is copied)
- Tags and aliases share the same image ID — verify with `podman images`
- `/etc/containers/registries.conf` — system-wide registry config
- `~/.config/containers/registries.conf` — per-user override
- `unqualified-search-registries` controls where short names (e.g. `ubi9`) are searched
