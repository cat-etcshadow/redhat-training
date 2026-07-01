#!/usr/bin/env bash
firewall-cmd --permanent --zone=public \
  --add-forward-port="port=${FROM_PORT}:proto=tcp:toport=${TO_PORT}"
firewall-cmd --reload
