#!/usr/bin/env bash
dnf module reset nodejs -y &>/dev/null || true
dnf remove -y nodejs 2>/dev/null || true
