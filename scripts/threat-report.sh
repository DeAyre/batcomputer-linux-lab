#!/bin/bash
LOG=${1:-/var/log/batcave/batcave-access.log}
[ -r "$LOG" ] || { echo "Cannot read $LOG"; exit 1; }
echo "=== THREAT REPORT: $(basename "$LOG") ==="
echo "Total events:   $(wc -l < "$LOG")"
echo "Failed logins:  $(grep -c 'LOGIN FAILED' "$LOG")"
echo "Alerts raised:  $(grep -c '"ALERT"' "$LOG")"
echo
echo "--- Failed logins by user ---"
grep 'LOGIN FAILED' "$LOG" | awk '{print $3}' | sort | uniq -c | sort -rn
echo
echo "--- Top 5 source IPs ---"
awk '{print $NF}' "$LOG" | sort | uniq -c | sort -rn | head -5
echo
echo "--- Most recent 5 alerts ---"
grep '"ALERT"' "$LOG" | sort | tail -5
