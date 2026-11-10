#!/bin/bash
# 03-create-user.sh: creates the Bat Family roster (safe to re-run)

if [ "$EUID" -ne 0 ]; then echo "Run with sudo"; exit 1; fi

GROUP_LIST=(batfamily command intel fieldops allies)
for g in "${GROUP_LIST[@]}"; do
	getent group "$g" >/dev/null || groupadd "$g"
done

# username|full name|secondary groups
ROSTER=(
	"bruce|Bruce Wayne (Batman)|batfamily,command"
	"alfred|Alfred Pennyworth (Butler)|batfamily,command,intel"
	"dick|Dick Grayson (Nightwing)|batfamily,fieldops"
	"barbara|Barbara Gordon (Oracle)|batfamily,intel"
	"tim|Tim Drake (Red Robin)|batfamily,intel,fieldops"
	"damian|Damian Wayne (Robin)|batfamily,fieldops"
	"jason|Jason Todd (Red Hood)|batfamily,fieldops"
	"gordon|James Gordon (Commissioner)|allies"
)

for entry in "${ROSTER[@]}"; do
	IFS='|' read -r user fullname grps <<< "$entry"
	if id "$user" &>/dev/null; then
		echo "[skip] $user exits, making sure groups are set"
		usermod -aG "$grps" "$user"  
	else 
		useradd -m -s /bin/bash -c "$fullname" -G "$grps" "$user"
		echo "[new] $user created"
	fi
done

getent passwd batsvc >/dev/null || \
	useradd --system --no-create-home --shell /usr/sbin/nologin \
		-c "Batcomputer service account" batsvc

# The sysadmin joins the family so it can read group-protected files later

[ -n "$SUDO_USER" ] && usermod -aG batfamily "$SUDO_USER"
echo "DONE."



