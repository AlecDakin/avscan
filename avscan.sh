#!/bin/bash
# Simple script to run a AV scan against directories
# Using clamdscan is faster than clamscan, but does require
# a daemon to be running
# Freshclam also runs as a daemon and updates the AV definitions
# twice a day - see freshclam.conf

RESULT="$( nice -n 19 clamdscan --fdpass -m /home /storage | grep Infected )"
INFECTED="$( echo $RESULT | grep -v 0 | wc -l )"

# Only email if there is a problem
# but always send a telegram
telegram-send -g --pre "$(hostname) AV Scan complete - $RESULT"
if [ "$INFECTED" -ne 0 ]; then
  echo -e "AV Scan complete - $RESULT" | mail -s "$hostname AV Scan result" support@dynacomitsupport.co.uk mrabee@laltexlondon.com
  logger "AV Scan complete - $RESULT"
  telegram-send -g "$(hostname)" -f /var/log/clamav/clamav.log
fi

### EOF ###
