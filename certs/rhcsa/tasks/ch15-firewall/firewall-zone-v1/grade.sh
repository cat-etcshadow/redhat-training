#!/usr/bin/env bash
set -euo pipefail
errors=0
fail() { echo "FAIL: $*"; (( errors++ )); }

firewall-cmd --get-zones 2>/dev/null | grep -qw "$ZONE_NAME" \
  || fail "Zone '$ZONE_NAME' does not exist"

firewall-cmd --zone="$ZONE_NAME" --list-sources 2>/dev/null | grep -qw "$ZONE_SOURCE" \
  || fail "Source $ZONE_SOURCE not assigned to zone $ZONE_NAME"

firewall-cmd --zone="$ZONE_NAME" --list-services 2>/dev/null | grep -qw "$ZONE_SVC1" \
  || fail "Service $ZONE_SVC1 not added to zone $ZONE_NAME"

firewall-cmd --zone="$ZONE_NAME" --list-services 2>/dev/null | grep -qw "$ZONE_SVC2" \
  || fail "Service $ZONE_SVC2 not added to zone $ZONE_NAME"

# Confirm permanent (survives reload)
firewall-cmd --permanent --zone="$ZONE_NAME" --list-sources 2>/dev/null | grep -qw "$ZONE_SOURCE" \
  || fail "Zone $ZONE_NAME source $ZONE_SOURCE is not permanent (missing --permanent flag?)"

[[ $errors -eq 0 ]] && exit 0 || exit 1
