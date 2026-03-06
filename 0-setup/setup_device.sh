#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./setup_device.sh \
    --user arduino \
    --password arduino \
    --ssid Foundries \
    --wifi-pass '@Foundries.io123' \
    [--serial SERIAL]

Parameters:
  --user         Target username
  --password     Target user password
  --ssid         Wi-Fi SSID
  --wifi-pass    Wi-Fi password
  --serial       adb device serial (optional)
EOF
}

USER_NAME=""
USER_PASSWORD=""
WIFI_SSID=""
WIFI_PASSWORD=""
ADB_SERIAL=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)
      USER_NAME="${2:-}"
      shift 2
      ;;
    --password)
      USER_PASSWORD="${2:-}"
      shift 2
      ;;
    --ssid)
      WIFI_SSID="${2:-}"
      shift 2
      ;;
    --wifi-pass)
      WIFI_PASSWORD="${2:-}"
      shift 2
      ;;
    --serial)
      ADB_SERIAL="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown parameter: $1" >&2
      usage
      exit 1
      ;;
  esac
done

[[ -n "$USER_NAME"     ]] || { echo "Missing --user"; exit 1; }
[[ -n "$USER_PASSWORD" ]] || { echo "Missing --password"; exit 1; }
[[ -n "$WIFI_SSID"     ]] || { echo "Missing --ssid"; exit 1; }
[[ -n "$WIFI_PASSWORD" ]] || { echo "Missing --wifi-pass"; exit 1; }

ADB=(adb)
if [[ -n "$ADB_SERIAL" ]]; then
  ADB+=(-s "$ADB_SERIAL")
fi

echo "[INFO] Checking adb connection..."
"${ADB[@]}" get-state >/dev/null

REMOTE_SCRIPT="$(mktemp)"
cleanup() {
  rm -f "$REMOTE_SCRIPT"
}
trap cleanup EXIT

cat > "$REMOTE_SCRIPT" <<'REMOTE_EOF'
#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[REMOTE] $*"
}

sudo_do() {
  printf '%s\n' "$USER_PASSWORD" | sudo -S -p '' "$@"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "[ERROR] Command not found on target: $1" >&2
    exit 1
  }
}

require_cmd sudo
require_cmd passwd
require_cmd nmcli
require_cmd systemctl
require_cmd apt
require_cmd curl
require_cmd gpg
require_cmd date

log "Validating sudo access..."
if printf '%s\n' "$USER_PASSWORD" | sudo -S -p '' -v 2>/dev/null; then
  log "Sudo validated; skipping password change."
else
  log "Setting user password..."
  printf '%s\n%s\n' "$USER_PASSWORD" "$USER_PASSWORD" | passwd
fi

log "Connecting to Wi-Fi..."
if sudo_do nmcli -t -f NAME connection show | grep -Fxq "$WIFI_SSID"; then
  if ! sudo_do nmcli connection up "$WIFI_SSID"; then
    log "Existing Wi-Fi profile failed; recreating with WPA-PSK..."
    sudo_do nmcli connection delete id "$WIFI_SSID" >/dev/null 2>&1 || true
    sudo_do nmcli connection add type wifi ifname wlan0 con-name "$WIFI_SSID" ssid "$WIFI_SSID"
    sudo_do nmcli connection modify "$WIFI_SSID" wifi-sec.key-mgmt wpa-psk
    sudo_do nmcli connection modify "$WIFI_SSID" wifi-sec.psk "$WIFI_PASSWORD"
    sudo_do nmcli connection up "$WIFI_SSID"
  fi
else
  if ! sudo_do nmcli dev wifi connect "$WIFI_SSID" password "$WIFI_PASSWORD"; then
    log "Direct connect failed; creating Wi-Fi profile with WPA-PSK..."
    sudo_do nmcli connection add type wifi ifname wlan0 con-name "$WIFI_SSID" ssid "$WIFI_SSID"
    sudo_do nmcli connection modify "$WIFI_SSID" wifi-sec.key-mgmt wpa-psk
    sudo_do nmcli connection modify "$WIFI_SSID" wifi-sec.psk "$WIFI_PASSWORD"
    sudo_do nmcli connection up "$WIFI_SSID"
  fi
fi

log "Generating SSH host keys..."
sudo_do ssh-keygen -A

log "Enabling and starting SSH service..."
sudo_do systemctl enable ssh
sudo_do systemctl start ssh

log "Configuring X11 monitor settings..."
sudo_do mkdir -p /etc/X11/xorg.conf.d
cat <<'EOF' | sudo_do tee /etc/X11/xorg.conf.d/10-monitor.conf >/dev/null
Section "Monitor"
    Identifier "Monitor0"
    Option "DPMS" "false"
EndSection

Section "ServerFlags"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
    Option "BlankTime" "0"
EndSection
EOF

log "Ensuring system time is synchronized..."
if command -v timedatectl >/dev/null 2>&1; then
  sudo_do timedatectl set-ntp true || true
  sudo_do systemctl restart systemd-timesyncd || true
  for _ in {1..10}; do
    if timedatectl show -p SystemClockSynchronized --value 2>/dev/null | grep -q '^yes$'; then
      break
    fi
    sleep 2
  done
fi
date

log "Installing apt dependencies..."
sudo_do apt update || { log "apt update failed, retrying after time sync..."; sleep 5; sudo_do apt update; }
sudo_do apt install -y apt-transport-https ca-certificates curl gnupg

log "Adding fioup apt repository..."
FIOUP_GPG_TMP="$(mktemp -p /tmp)"
curl -fsSL https://fioup.foundries.io/pkg/deb/dists/stable/Release.gpg \
  | gpg --batch --yes --no-tty --dearmor -o "$FIOUP_GPG_TMP"
sudo_do install -m 0644 "$FIOUP_GPG_TMP" /etc/apt/trusted.gpg.d/fioup-stable.gpg
rm -f "$FIOUP_GPG_TMP"

FIOUP_LIST_TMP="$(mktemp -p /tmp)"
printf '%s\n' "deb [signed-by=/etc/apt/trusted.gpg.d/fioup-stable.gpg] https://fioup.foundries.io/pkg/deb stable main" > "$FIOUP_LIST_TMP"
sudo_do install -m 0644 "$FIOUP_LIST_TMP" /etc/apt/sources.list.d/fioup.list
rm -f "$FIOUP_LIST_TMP"

sudo_do apt update || { log "apt update failed after adding fioup repo; retrying..."; sleep 5; sudo_do apt update; }
if ! apt-cache show fioup >/dev/null 2>&1; then
  log "fioup package not found after repo update."
  log "Contents of /etc/apt/sources.list.d/fioup.list:"
  sudo_do cat /etc/apt/sources.list.d/fioup.list || true
  exit 1
fi
sudo_do apt install -y fioup


log "Creating desktop launcher..."
mkdir -p "/home/$USER_NAME/Desktop"
cat > "/home/$USER_NAME/Desktop/App.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=App
Comment=
Exec=chromium --kiosk http://localhost:8000
Icon=audio-input-microphone
Path=
Terminal=false
StartupNotify=false
EOF

chmod 644 "/home/$USER_NAME/Desktop/App.desktop"
sudo_do chown "$USER_NAME:$USER_NAME" "/home/$USER_NAME/Desktop/App.desktop"

log "Creating kiosk autostart entry..."
cat <<'EOF' | sudo_do tee /etc/xdg/autostart/kiosk.desktop >/dev/null
[Desktop Entry]
Type=Application
Name=Kiosk
Exec=chromium --kiosk http://localhost:8000
X-GNOME-Autostart-enabled=true
EOF

log "Removing old autostart entry if present..."
sudo_do rm -f /etc/xdg/autostart/ArduinoAppLab.desktop

log "Configuring LightDM autologin..."
sudo_do mkdir -p /etc/lightdm/lightdm.conf.d
cat <<EOF | sudo_do tee /etc/lightdm/lightdm.conf.d/50-autologin.conf >/dev/null
[Seat:*]
autologin-user=$USER_NAME
autologin-user-timeout=0
EOF

log "Rebooting device..."
sudo_do reboot
REMOTE_EOF

echo "[INFO] Pushing remote script to target..."
"${ADB[@]}" push "$REMOTE_SCRIPT" /tmp/setup-device.sh >/dev/null

echo "[INFO] Executing remote setup..."
"${ADB[@]}" shell \
  "export USER_NAME=$(printf '%q' "$USER_NAME"); \
   export USER_PASSWORD=$(printf '%q' "$USER_PASSWORD"); \
   export WIFI_SSID=$(printf '%q' "$WIFI_SSID"); \
   export WIFI_PASSWORD=$(printf '%q' "$WIFI_PASSWORD"); \
   chmod +x /tmp/setup-device.sh && /tmp/setup-device.sh"