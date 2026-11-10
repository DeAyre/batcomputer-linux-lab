#!/bin/bash
# Shows every regular user: UID, name, groups, and (if run as root) lock status
#
echo "=== BAT FAMILY ROSTER ==="
printf "%-10s %-6s %-6s %-32s %s \n" USER UID STATE NAME GROUPS
getent passwd | awk -F: -v OFS=: '$3>=1000 && $3<65534 {print $1,$3,$5}' | sort -t: -k2 -n |
	while IFS=: read -r user uid name; do
		name=${name%%,*}
		grps=$(id -nG "$user" | tr ' ' ',')
		state="-"
		[ "$EUID" -eq 0 ] && state=$(passwd -S "$user" | awk '{print $2}')
		printf "%-10s %-6s %-6s %32s %s\n" "$user" "$uid" "$state" "$name" "$grps"
	done

