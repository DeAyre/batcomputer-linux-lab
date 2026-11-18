#!/bin/bash
echo "=== SUID files (run as owner) ===";               find / -xdev -perm -4000 -type f 2>/dev/null
echo "=== SGID files ===";                              find / -xdev -perm -2000 -type f 2>/dev/null
echo "=== World-writable files ===";                    find / -xdev -type f -perm -0002 2>/dev/null
echo "=== World-writable dirs WITHOUT sticky bit ==="; find / -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null
echo "=== Files with no owner or group ===";            find / -xdev \( -nouser -o -nogroup \) 2>/dev/null
