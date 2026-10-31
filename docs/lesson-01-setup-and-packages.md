# Lesson 1: Booting the Batcomputer (Setup and Package Management)

Part of the [Batcomputer Linux Lab](../README.md)

This lesson covered getting the server running: building the VM, checking what I'm running, and patching and equipping the system with a base set of tools.

## Environment
- **Host:** Ubuntu PC running VMware Workstation
- **Guest:** Ubuntu Server VM (`batcomputer`) on a NAT network
- **Admin account:** `penny1`

## What I Built

### 1. The VM
I created an Ubuntu Server VM in VMware, named it `batcomputer`, set up my admin account, and installed OpenSSH so I could connect remotely later in the lab.

### 2. System checks
Once I logged in, I checked what I was working with:

```bash
cat /etc/os-release     # Distro and version
uname -r                # Kernel version
echo $SHELL             # Current shell
hostnamectl             # Hostname, OS, kernel, architecture
uptime                  # How long the system has been up
who                     # Who's logged in
```

These commands tell me what I'm running, and they're the first things I'd check on any unfamiliar Linux machine.

### 3. Patching and installing base tools
I updated the package list, upgraded the installed packages, and installed the tools I'd need for the rest of the lab:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y htop tree vim curl wget git
which htop tree vim git   # Confirm they installed
```

### 4. Practicing the install/remove cycle
To get comfortable with `apt`, I removed a package, confirmed it was gone, and installed it again:

```bash
sudo apt remove tree -y
which tree                # Returns nothing once it's removed
sudo apt install tree -y
```

### 5. My first automation script
I wrote a small bash script that updates, upgrades, and cleans up the system in one command. It's in [`scripts/update-batcomputer.sh`](../scripts/update-batcomputer.sh).

```bash
#!/bin/bash
# Keeps the Batcomputer patched and tidy
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
echo "Batcomputer systems updated: $(date)"
```

To run it, I made it executable from the terminal, then ran it:

```bash
chmod +x ~/batcave-scripts/update-batcomputer.sh
~/batcave-scripts/update-batcomputer.sh
```

## Issues I Ran Into
None worth writing up for this lesson. Setup, the system checks, and the package installs all worked on the first try. The problems in this lab started in [Lesson 2](lesson-02-batcave-filesystem.md).

## Key Takeaways
- Check the system first (distro, kernel, shell) before changing anything.
- `apt update` refreshes the package list, and `apt upgrade` installs the updates. They're two separate steps.
- Making a script executable (`chmod +x`) is done in the terminal, not inside the script file.
- Wrapping repeated commands in a script saves time and keeps maintenance consistent.

## Skills Demonstrated
- Building and configuring an Ubuntu Server VM
- Identifying a system's OS, kernel, and shell from the command line
- Package management with `apt` (update, upgrade, install, remove, autoremove)
- Writing and running a basic bash script

## Checklist
- [x] VM boots and I can log in
- [x] Can identify the distro, kernel, and shell
- [x] Base tools installed (`htop`, `tree`, `vim`, `curl`, `wget`, `git`)
- [x] Update script runs cleanly

[Lesson 2 →](lesson-02-batcave-filesystem.md)
