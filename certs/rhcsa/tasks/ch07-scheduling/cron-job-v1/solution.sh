#!/usr/bin/env bash
# Add crontab entry for reporter
(crontab -l -u reporter 2>/dev/null; echo "30 2 * * * /usr/local/bin/daily-report.sh") \
  | crontab -u reporter -
