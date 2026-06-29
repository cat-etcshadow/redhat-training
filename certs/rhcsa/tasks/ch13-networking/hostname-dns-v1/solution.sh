#!/usr/bin/env bash
hostnamectl set-hostname server1.example.com
echo "192.168.1.10  server1.example.com  server1" >> /etc/hosts
