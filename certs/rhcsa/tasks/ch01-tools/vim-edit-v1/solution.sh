#!/usr/bin/env bash
sed -i "s/^HOSTNAME=.*/HOSTNAME=${NEW_HOSTNAME}/" "$CONF_FILE"
sed -i "s/^LISTEN_PORT=.*/LISTEN_PORT=${LISTEN_PORT}/" "$CONF_FILE"
sed -i "s/^TIMEOUT=.*/TIMEOUT=${TIMEOUT_VAL}/" "$CONF_FILE"
sed -i "s/^DEBUG=.*/DEBUG=false/" "$CONF_FILE"
