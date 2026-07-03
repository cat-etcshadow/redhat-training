#!/usr/bin/env bash
systemctl isolate rescue.target
sleep 2
systemctl isolate multi-user.target
