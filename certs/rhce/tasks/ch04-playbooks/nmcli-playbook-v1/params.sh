#!/usr/bin/env bash
NAMES=(network.yml nmcli.yml configure-nic.yml networking.yml)
CONN_NAMES=(eth1-static ens4-config backup-nic secondary-nic)
DEVICES=(eth1 ens4 ens5 eth2)
IPS=(192.168.100.10/24 10.0.1.20/24 172.16.0.5/24 192.168.200.15/24)
GATEWAYS=(192.168.100.1 10.0.1.1 172.16.0.1 192.168.200.1)
DNS=(192.168.100.53 10.0.1.53 172.16.0.53 192.168.200.53)
idx=$(( RANDOM % ${#NAMES[@]} ))
nidx=$(( RANDOM % ${#CONN_NAMES[@]} ))
echo "ANSIBLE_DIR=/home/student/ansible"
echo "INVENTORY_FILE=/home/student/ansible/inventory"
echo "PLAYBOOK_FILE=/home/student/ansible/${NAMES[$idx]}"
echo "CONN_NAME=${CONN_NAMES[$nidx]}"
echo "DEVICE=${DEVICES[$nidx]}"
echo "IP_ADDRESS=${IPS[$nidx]}"
echo "GATEWAY=${GATEWAYS[$nidx]}"
echo "DNS_SERVER=${DNS[$nidx]}"
