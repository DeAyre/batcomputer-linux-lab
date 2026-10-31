# Troubleshooting: SSH from a Mac to a VMware NAT VM

Part of the [Batcomputer Linux Lab](../../README.md) | Related: [Lesson 2](../lesson-02-batcave-filesystem.md)

## Why I needed SSH
While building the status script in Lesson 2, I needed to paste it into my Ubuntu Server VM. The VM console wouldn't accept copy and paste, so I decided to SSH into it from my MacBook instead. That turned into the hardest problem of the lesson.

## Environment
| Component | Details |
|-----------|---------|
| Host | Ubuntu PC running VMware Workstation |
| Guest | Ubuntu Server VM (`batcomputer`) on a NAT network |
| Client | MacBook (Terminal, built-in OpenSSH) |

## What went wrong

### 1. "Operation timed out"
My first attempt was this, from my MacBook:
```bash
ssh penny1@172.16.169.x
# ssh: connect to host 172.16.169.x port 22: Operation timed out
```
I was confused, because SSH from the Ubuntu PC to that same address worked fine. So I knew the VM and its SSH server were healthy.

**Cause:** My VM was on VMware's NAT network. The 172.16.169.x address only exists inside a private network on the PC. The PC can see it, but my Mac can't, so the connection never got anywhere. Nothing was broken on the VM. I was trying to reach it from the wrong side.

### 2. The frozen terminal
After I set up a port forward and tried again, my Mac's terminal froze.

It wasn't a crash. SSH was waiting on a connection that was never going to answer, so it just hung until I closed the window. That told me I was dealing with a network problem, not a password or SSH config problem.

### 3. "Connection refused" on port 2222
Once I used the PC's real LAN IP with port 2222, the error changed:
```bash
ssh -p 2222 penny1@<PC-LAN-IP>
# ssh: connect to host <PC-LAN-IP> port 2222: Connection refused
```
That was actually progress. The two errors mean different things:

| Error | What it means |
|-------|---------------|
| Operation timed out | My traffic never arrives (wrong network, routing, or something silently dropping it) |
| Connection refused | My traffic arrived, but nothing was listening on that port |

So my Mac could reach the PC. The problem was that the port forward wasn't active yet.

## Things I ruled out along the way
- **VM and SSH server:** SSH from the PC to the VM worked, so both were fine.
- **Firewall on the PC:** `ufw` showed inactive, so it wasn't blocking anything.

## The fix
Since the Mac can't reach the VM directly, it has to go through the PC. I set up a port forward in VMware so traffic sent to the PC on port 2222 gets passed to the VM on port 22:

```
Mac  ->  PC LAN IP : 2222  ->  VMware NAT forward  ->  VM : 22
```

1. **Added the NAT port forward in VMware:**
   - Host port: `2222`
   - Type: TCP
   - VM IP: the VM's current NAT address
   - VM port: `22`
2. **Rechecked the forward settings and restarted VMware's networking** on the PC:
   ```bash
   sudo vmware-networks --stop
   sudo vmware-networks --start
   ```
3. **Connected from the Mac using the PC's address, not the VM's:**
   ```bash
   ssh -p 2222 penny1@<PC-LAN-IP>
   ```

After that, port 2222 started listening and SSH connected.

## What I took away from it
- **Read the error first.** A timeout and a refusal point to different problems.
- **A NAT'd VM isn't reachable from other devices.** You have to go through the host with a port forward, or use bridged networking.
- **Test from both ends.** Trying the PC first showed me the VM was fine, which narrowed the problem to the network path.
- **Be careful which address you use.** The VM's address and the PC's address are different things, and the port number goes with the PC.

## Alternative I didn't use: bridged networking
Switching the VM's network adapter to Bridged gives it an address on my home network, so the Mac could SSH straight to it on port 22 with no port forward. I went with the port forward, but bridged is a simpler option if the host is on a wired connection.

## Quick reference
```bash
# On the VM: get its IP
ip -4 addr show

# On the PC: confirm something is listening on the forwarded port
sudo ss -tlnp | grep 2222

# On the PC: check whether the firewall is active
sudo ufw status

# On the Mac: connect through the PC
ssh -p 2222 penny1@<PC-LAN-IP>
```

## Notes
- The forward points to the VM's current IP. If the VM's address changes after a reboot, the forward needs to be updated to match.
- I left the real IP addresses out of this doc on purpose.
