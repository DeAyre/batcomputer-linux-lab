#!/bin/bash
# 05-permissions.sh: applies the Batcomputer clearance matrix (safe to re-run)
set -e
[ "$EUID" -eq 0 ] || { echo "Run with sudo"; exit 1; }
BASE=/opt/batcave
CONF=/etc/batcave
LOGS=/var/log/batcave
mkdir -p $BASE/briefings $BASE/archive

# top level + scripts
chown penny1:batfamily $BASE
chmod 750 $BASE
chown -R penny1:batfamily $BASE/computer
chmod 750 $BASE/computer
chmod 750 $BASE/computer/*.sh

# config: command only (intel is added via ACL later)
chown -R penny1:command $CONF
chmod 2750 $CONF
find $CONF -type f -exec chmod 640 {} +

# cases: shared workspace. SGID keeps the group, sticky stops deleting each other's files
chgrp -R batfamily $BASE/cases
chmod -R g+rwX $BASE/cases
find $BASE/cases -type d -exec chmod g+s {} +
chmod 3770 $BASE/cases

# gadgets: field ops
chown -R penny1:fieldops $BASE/gadgets
chmod 2770 $BASE/gadgets

# vault and archive: command only
chown -R penny1:command $BASE/vault $BASE/archive
chmod 2770 $BASE/vault $BASE/archive

# logs: service account writes, family reads
chown -R batsvc:batfamily $LOGS
chmod 2750 $LOGS
find $LOGS -type f -exec chmod 640 {} +

# briefings
chown -R penny1:batfamily $BASE/briefings
chmod 2770 $BASE/briefings
echo "Permissions applied."
