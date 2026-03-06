#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <hostname>"
  echo "Example: $0 uno-q-01"
  exit 1
fi

HOSTNAME_ARG="$1"
WIFI_SSID="FoundriesWorkshop"
WIFI_PASS="@FoundriesWorkshop123"
USER_PASS="arduino"

echo "==> Waiting for device via adb"
until adb get-state >/dev/null 2>&1; do
  sleep 2
done
adb wait-for-device

echo "==> Validating sudo access"
if adb shell "printf '%s\n' '$USER_PASS' | sudo -S -p '' -v" >/dev/null 2>&1; then
  echo "==> Sudo validated; skipping password change"
else
  echo "==> Setting initial password"
  adb shell "printf '%s\n%s\n' '$USER_PASS' '$USER_PASS' | passwd"
fi

echo "==> Connecting to Wi-Fi"
WIFI_RETRIES=10
WIFI_DELAY=3
if adb shell "nmcli -t -f DEVICE,STATE dev | grep -Eq '^(wlan0|wlx[^:]+):connected'" >/dev/null 2>&1; then
  echo "==> Wi-Fi already connected"
else
  for attempt in $(seq 1 "$WIFI_RETRIES"); do
    if adb shell "nmcli dev wifi connect '$WIFI_SSID' password '$WIFI_PASS'" >/dev/null 2>&1; then
      echo "==> Wi-Fi connected"
      break
    fi
    if [[ "$attempt" -eq "$WIFI_RETRIES" ]]; then
      echo "==> Wi-Fi connect failed after ${WIFI_RETRIES} attempts; continuing"
    else
      echo "==> Wi-Fi not ready, retrying (${attempt}/${WIFI_RETRIES})..."
      sleep "$WIFI_DELAY"
    fi
  done
fi

echo "==> Showing wlan0 IP"
adb shell "ip addr show wlan0"

echo "==> Generating SSH host keys"
adb shell "echo '$USER_PASS' | sudo -S ssh-keygen -A"

echo "==> Enabling and starting SSH"
adb shell "echo '$USER_PASS' | sudo -S systemctl enable ssh"
adb shell "echo '$USER_PASS' | sudo -S systemctl start ssh"

echo "==> Verifying SSH is listening"
adb shell "ss -ltnp | grep ':22' || true"

echo "==> Installing fioup and configuring docker (best effort)"
{
  printf '%s\n' "$USER_PASS"
  cat <<'EOF'
set -euo pipefail

echo "==> [device] apt update"
apt update
echo "==> [device] installing apt deps"
apt install -y apt-transport-https ca-certificates curl gnupg
echo "==> [device] adding fioup repo"
curl -fsSL https://fioup.foundries.io/pkg/deb/dists/stable/Release.gpg \
  | gpg --batch --yes --no-tty --dearmor -o /etc/apt/trusted.gpg.d/fioup-stable.gpg

cat > /etc/apt/sources.list.d/fioup.list <<'FIOUP'
deb [signed-by=/etc/apt/trusted.gpg.d/fioup-stable.gpg] https://fioup.foundries.io/pkg/deb stable main
FIOUP

echo "==> [device] apt update (fioup)"
apt update
echo "==> [device] installing fioup"
apt install -y fioup

echo "==> [device] configuring docker mirror"
grep -q rauls-server /etc/hosts || echo '192.168.20.10   rauls-server' >> /etc/hosts
cat > /etc/docker/daemon.json <<'DOCKER'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "2"
  },
  "registry-mirrors": ["http://rauls-server:5000"],
  "insecure-registries": ["rauls-server:5000"]
}
DOCKER
EOF
} | adb shell "sudo -S -p '' bash -s" || true

echo "==> Creating post-setup script on device"
adb shell "echo '$USER_PASS' | sudo -S -p '' install -d /home/arduino" || true
{
  printf '%s\n' "$USER_PASS"
  cat <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo ">> sudo mkdir -p /var/sota"
sudo mkdir -p /var/sota
echo ">> sudo chown -R $USER /var/sota"
sudo chown -R "$USER" /var/sota
echo ">> sudo usermod -aG docker $USER"
sudo usermod -aG docker "$USER"

echo "Done. Re-login (or reboot) to apply docker group changes."
EOF
} | adb shell "sudo -S -p '' sh -c 'cat > /home/arduino/post_sota_setup.sh'" || true
adb shell "echo '$USER_PASS' | sudo -S -p '' chmod +x /home/arduino/post_sota_setup.sh" || true
adb shell "echo '$USER_PASS' | sudo -S -p '' chown arduino:arduino /home/arduino/post_sota_setup.sh" || true

echo "==> Disabling screen sleep"
adb shell "echo '$USER_PASS' | sudo -S sh -c 'mkdir -p /etc/X11/xorg.conf.d && cat > /etc/X11/xorg.conf.d/10-monitor.conf <<\"EOF\"
Section \"Monitor\"
    Identifier \"Monitor0\"
    Option \"DPMS\" \"false\"
EndSection

Section \"ServerFlags\"
    Option \"StandbyTime\" \"0\"
    Option \"SuspendTime\" \"0\"
    Option \"OffTime\" \"0\"
    Option \"BlankTime\" \"0\"
EndSection
EOF'"

echo "==> Removing ArduinoAppLab autostart"
adb shell "echo '$USER_PASS' | sudo -S rm -f /etc/xdg/autostart/ArduinoAppLab.desktop"

echo "==> Setting hostname"
adb shell "echo '$USER_PASS' | sudo -S hostnamectl set-hostname '$HOSTNAME_ARG'"
adb shell "echo '$USER_PASS' | sudo -S sed -i 's/127.0.1.1.*/127.0.1.1    $HOSTNAME_ARG/' /etc/hosts"

echo "==> Final IP address"
adb shell "ip addr show wlan0"

echo "==> Done"
echo "Hostname set to: $HOSTNAME_ARG"



