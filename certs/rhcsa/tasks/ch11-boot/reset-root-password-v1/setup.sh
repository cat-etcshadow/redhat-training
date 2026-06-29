#!/usr/bin/env bash
# Lock root with an unknown password so candidate must reset it
echo 'root:UnknownPassword!@#' | chpasswd
# Record the setup timestamp so grade.sh can check it changed
date +%s > /tmp/rhtr_setup_epoch
