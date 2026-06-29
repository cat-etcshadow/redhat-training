#!/usr/bin/env bash
setfacl -m u:auditor:rx,g:contractors:--- /var/data/reports
setfacl -m d:u:auditor:rx,d:g:contractors:--- /var/data/reports
