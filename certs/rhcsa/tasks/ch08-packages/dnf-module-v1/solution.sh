#!/usr/bin/env bash
dnf module reset nodejs -y
dnf module enable "nodejs:${NODE_STREAM}" -y
dnf install -y nodejs
