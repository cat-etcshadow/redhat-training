#!/usr/bin/env bash
semanage fcontext -a -t public_content_t '/srv/ftp/pub(/.*)?'
restorecon -Rv /srv/ftp/pub
