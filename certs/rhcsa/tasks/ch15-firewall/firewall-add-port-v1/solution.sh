#!/usr/bin/env bash
firewall-cmd --permanent --add-port="$TCP_PORT/tcp"
firewall-cmd --permanent --add-port="$UDP_START-$UDP_END/udp"
firewall-cmd --reload
