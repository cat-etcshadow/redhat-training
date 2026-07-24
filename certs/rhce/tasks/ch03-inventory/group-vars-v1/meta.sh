POINTS=8
TOPIC="inventory"
CHAPTER=3
TITLE="Create group_vars directory with per-group variables"
DIFFICULTY="easy"
RHEL_VERSIONS="9"
# group_vars/all must be a FILE here, but ch09-vault/vault-group-vars-v1
# requires the same path to be a DIRECTORY (group_vars/all/main.yml) —
# mutually exclusive regardless of setup order.
CONFLICTS=("ch09-vault/vault-group-vars-v1")
