   #!/bin/bash
   # Batcomputer status report
   echo "===== BATCOMPUTER STATUS ====="
   echo "Host:    $(hostname)"
   echo "OS:      $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
   echo "Kernel:  $(uname -r)"
   echo "CPUs:    $(grep -c ^processor /proc/cpuinfo)"
   echo "Memory:  $(awk '/MemTotal/ {printf "%.0f MB", $2/1024}' /proc/meminfo)"
   echo "Uptime:  $(uptime -p)"
   echo "Disk /:  $(df -h / | awk 'NR==2 {print $3 " used of " $2}')"
   echo "=============================="


   cat /opt/batcave/computer/status.sh
