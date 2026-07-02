#!/usr/bin/env bash
# container-cache-setup.sh — offline container registry mirror for RHCSA
#
# Runs inside the RHCSA VM (via vm_exec_script) during topology_create.
# Idempotent: safe to re-run against an existing VM.
#
# The real RHCSA exam gives no internet access, but the objectives still
# expect `podman search`, `podman pull <fqdn>`, and `skopeo inspect
# docker://<fqdn>` to work against the real registry names
# (registry.access.redhat.com, registry.redhat.io, docker.io). None of
# those operations honor registries.conf [[registry.mirror]] redirection —
# only `podman pull`-by-tag partially does — so instead this script:
#   1. Points those hostnames at 127.0.0.1 via /etc/hosts.
#   2. Runs a local registry:2 container (--network=host, port 5000)
#      seeded with ubi9/ubi.
#   3. Redirects 127.0.0.1:80 -> :5000 with an nft rule (not a direct bind
#      on :80) so this never competes for port 80 with other tasks, e.g.
#      ch05-selinux/boolean-httpd-v1, which run their own httpd there.
#   4. Marks those registries "insecure" so podman/skopeo speak plain HTTP.
#   5. Relaxes the sigstore signature policy for the two Red Hat hostnames,
#      since the local mirror necessarily serves an unsigned copy.
# Task/solution scripts never need to know any of this — they keep using
# the real FQDNs exactly as written.
set -uo pipefail

if systemctl is-active --quiet rhtr-registry 2>/dev/null \
   && podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null \
   && command -v skopeo &>/dev/null; then
  echo "rhtr-registry already configured"
  exit 0
fi

command -v podman &>/dev/null || dnf install -y podman &>/dev/null
# skopeo is needed by container-inspect-v1; installed here (not in the task's
# own setup.sh) so it's available offline during the actual exam.
command -v skopeo &>/dev/null || dnf install -y skopeo &>/dev/null

if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  if [[ -f /var/cache/rhtr-ubi9.tar ]]; then
    podman load -i /var/cache/rhtr-ubi9.tar &>/dev/null
  else
    podman pull registry.access.redhat.com/ubi9/ubi &>/dev/null \
      && podman save -o /var/cache/rhtr-ubi9.tar registry.access.redhat.com/ubi9/ubi &>/dev/null
  fi
fi
if ! podman image exists registry.access.redhat.com/ubi9/ubi 2>/dev/null; then
  echo "WARN: ubi9/ubi not available — cannot seed local registry mirror" >&2
  exit 1
fi

if ! podman image exists docker.io/library/registry:2 2>/dev/null; then
  podman pull docker.io/library/registry:2 &>/dev/null \
    || { echo "WARN: could not pull registry:2 — local mirror not available" >&2; exit 1; }
fi

# Redirect the real registry FQDNs to our loopback mirror.
grep -q 'rhtr-registry-mirror' /etc/hosts \
  || echo "127.0.0.1 registry.access.redhat.com registry.redhat.io docker.io index.docker.io # rhtr-registry-mirror" >> /etc/hosts

mkdir -p /etc/containers/registries.conf.d
cat > /etc/containers/registries.conf.d/999-rhtr-mirror.conf <<'EOF'
# These hostnames are pointed at 127.0.0.1 in /etc/hosts and served by the
# rhtr-registry mirror (see container-cache-setup.sh). insecure = true so
# podman/skopeo use plain HTTP against it instead of real TLS.
[[registry]]
location = "registry.access.redhat.com"
insecure = true

[[registry]]
location = "registry.redhat.io"
insecure = true

[[registry]]
location = "docker.io"
insecure = true

[[registry]]
location = "index.docker.io"
insecure = true
EOF

# registry.access.redhat.com / registry.redhat.io normally require a
# sigstore-signed image; the local mirror serves an unsigned copy, so
# relax the policy for just those two hostnames.
if command -v jq &>/dev/null && [[ -f /etc/containers/policy.json ]]; then
  jq '.transports.docker["registry.access.redhat.com"] = [{"type":"insecureAcceptAnything"}]
      | .transports.docker["registry.redhat.io"] = [{"type":"insecureAcceptAnything"}]' \
    /etc/containers/policy.json > /etc/containers/policy.json.new \
    && mv /etc/containers/policy.json.new /etc/containers/policy.json
fi

mkdir -p /var/lib/rhtr-registry
# registry:2 runs as a non-root user inside the container; the bind mount
# must be writable by it regardless of that UID, and SELinux (enforcing on
# this VM) needs the container_file_t label or the write is denied.
chmod 777 /var/lib/rhtr-registry
chcon -Rt container_file_t /var/lib/rhtr-registry

cat > /etc/rhtr-registry.nft <<'EOF'
add table ip rhtr_registry
flush table ip rhtr_registry
add chain ip rhtr_registry output { type nat hook output priority -100 ; }
add rule ip rhtr_registry output ip daddr 127.0.0.1 tcp dport 80 redirect to :5000
EOF

cat > /etc/systemd/system/rhtr-registry.service <<'EOF'
[Unit]
Description=RHTR offline container registry mirror
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
NotifyAccess=all
Restart=always
# --network=host: a published port (-p) would go through podman's own
# NAT layer, which stacked with the nft redirect below produced dropped
# connections in testing. Host networking avoids that double-NAT entirely.
ExecStartPre=-/usr/bin/podman rm -f rhtr-registry
ExecStartPre=/usr/sbin/nft -f /etc/rhtr-registry.nft
ExecStart=/usr/bin/podman run --name rhtr-registry --replace --sdnotify=conmon \
  --network=host \
  -v /var/lib/rhtr-registry:/var/lib/registry \
  docker.io/library/registry:2
ExecStop=/usr/bin/podman stop -t 10 rhtr-registry
TimeoutStartSec=60

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now rhtr-registry.service

for _ in $(seq 1 15); do
  curl -sf http://127.0.0.1:5000/v2/ &>/dev/null && break
  sleep 1
done

# --remove-signatures: the source UBI image carries a sigstore signature
# tied to its original reference; keeping it while pushing to a
# self-hosted destination is rejected by podman push.
podman push --tls-verify=false --remove-signatures registry.access.redhat.com/ubi9/ubi:latest &>/dev/null \
  || { echo "WARN: failed to seed local registry with ubi9 image" >&2; exit 1; }

echo "rhtr-registry mirror ready"
