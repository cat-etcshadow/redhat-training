#!/usr/bin/env bash
chgrp -R "$WEB_GROUP" "$WEB_ROOT"
find "$WEB_ROOT" -type d -exec chmod 2775 {} +
find "$WEB_ROOT" -type f -exec chmod 0664 {} +
