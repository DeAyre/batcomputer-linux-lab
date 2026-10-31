# Lesson 2: Mapping the Batcave (Linux File System)

Part of the [Batcomputer Linux Lab]

In this lesson I learned how the Linux directory structure is laid out by building the Batcave on top of it. Instead of dumping everything in one folder, I put configs, apps, and logs where Linux expects them to go.

## Environment
- **Host:** Ubuntu PC running VMware Workstation
- **Guest:** Ubuntu Server VM (`batcomputer`)
- **Client:** MacBook, used to SSH into the VM

## What I Built

I created three locations for the Batcave and gave each a job:

| Location | What goes there |
|----------|-----------------|
| `/opt/batcave/` | Applications and project files (computer, gadgets, cases, vault) |
| `/etc/batcave/` | Configuration files |
| `/var/log/batcave/` | Mission logs |

Then I populated them with files and practiced moving around with absolute and relative paths.

The last piece was a live status script, `status.sh`, that reads system info straight from `/proc` and prints a report with the hostname, OS, kernel, CPU count, memory, uptime, and disk usage. The script is in [`scripts/status.sh`](../scripts/status.sh).

```bash
/opt/batcave/computer/status.sh
```

## Issues I Ran Into

### 1. Invalid user error
The lesson plan I was following used the username `alfred`, but when I set up the server I created my account as `penny1`. When I ran `chown`, it gave me an invalid user error because `alfred` doesn't exist on my system.

**Fix:** Easy. I swapped `alfred` for my real username.
```bash
sudo chown -R penny1:penny1 /opt/batcave /etc/batcave /var/log/batcave
```

**Takeaway:** Usernames in a guide are examples. Check `whoami` before you copy and paste.

### 2. Missing directories
When I went to populate the folders with files, some of the case files weren't created, and `cd` into the cases folder said it didn't exist.

I found out the brace expansion in my `mkdir` command got mangled, either from a space after a comma or from the command running in the wrong shell. Since the folders were never created, `touch` had nowhere to put the files.

**Fix:** I deleted the whole `/opt/batcave` directory and rebuilt it, this time writing out each folder path in full instead of using brace expansion.
```bash
sudo rm -rf /opt/batcave
sudo mkdir -p /opt/batcave/computer /opt/batcave/gadgets /opt/batcave/cases /opt/batcave/vault
```

After the rebuild, populating the directories worked.

**Takeaway:** Run `ls` or `tree` after creating things to confirm they're really there before building on top of them.

### 3. Getting my script onto the server (SSH)
For Step 5, I needed to paste the status script into the server, but the VM console wouldn't accept copy and paste. The workaround was to SSH into the VM from my MacBook and paste it from there.

That's where I ran into the biggest problem of the lesson. My VM was on VMware's NAT network, so the VM's private IP wasn't reachable from my Mac. I got a timeout, then a frozen terminal, then a "connection refused" error before I finally got in through a port forward on the PC.

I wrote up the full troubleshooting process separately: [SSH to a VMware NAT VM](troubleshooting/ssh-to-vmware-nat-vm.md).

## Key Takeaways
- A guide's usernames and paths may not match my setup, so I check before running commands.
- If a command depends on a directory, I verify the directory exists first.
- Simple, explicit commands are easier to debug than clever shortcuts.
- Some problems that look like a Linux issue (like SSH not working) turn out to be networking problems.

## Skills Demonstrated
- Linux file system layout and where different kinds of files belong
- Absolute and relative path navigation
- File ownership with `chown`
- Bash scripting that reads from `/proc`
- Troubleshooting by reading errors and checking each step

## Checklist
- [x] Built the Batcave directory structure
- [x] Populated it with config, log, and case files
- [x] Navigated using absolute and relative paths
- [x] Wrote and ran `status.sh`

[← Lesson 1](lesson-01-setup-and-packages.md)
