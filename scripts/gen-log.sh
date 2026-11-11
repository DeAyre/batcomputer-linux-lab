#!/bin/bash
# Generates 200 fake Batcave access-log lines for analysis practice
USERS=(bruce alfred dick barbara tim damian jason gordon)
ACTIONS=("LOGIN OK" "LOGIN FAILED" "FILE ACCESS" "CASE OPENED" "CASE CLOSED" "ALERT")
OUT=/var/log/batcave/batcave-access.log
for i in $(seq 1 200); do
  u=${USERS[$RANDOM % ${#USERS[@]}]}
  a=${ACTIONS[$RANDOM % ${#ACTIONS[@]}]}
  ip="10.0.0.$((RANDOM % 20 + 1))"
  echo "$(date -d "-$((RANDOM % 10000)) minutes" '+%Y-%m-%d %H:%M:%S') $u \"$a\" $ip" >> "$OUT"
done
