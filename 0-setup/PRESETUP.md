

# 🌐 Booth Router Configuration

## Router Admin Access

Router IP:

    192.168.10.1

Admin Password:

    @Foundries.io@

------------------------------------------------------------------------

## Wi‑Fi Configuration

SSID (2.4GHz):

    Foundries

SSID (5GHz):

    Foundries_5G

Wi‑Fi Password:

    @Foundries123

------------------------------------------------------------------------


# Arduino UNO Q -- Workshop Master Setup Guide

This document consolidates all validated working steps used during
provisioning and workshop preparation.

------------------------------------------------------------------------

# 🌐 Workshop Router Configuration

## Router Admin Access

Router IP:

    192.168.20.1

Admin Password:

    @Foundries.io@

------------------------------------------------------------------------

## Wi‑Fi Configuration

SSID (2.4GHz):

    FoundriesWorkshop

SSID (5GHz):

    FoundriesWorkshop_5G

Wi‑Fi Password:

    @FoundriesWorkshop123

------------------------------------------------------------------------

Recommended:

-   Keep router LAN network as `192.168.20.0/24`
-   Gateway: `192.168.20.1`
-   Enable DHCP for normal workshop mode
-   Use static IPs only when required (e.g., server / registry mirror)

------------------------------------------------------------------------

# 🔁 Reflash Debian Image

Official guide:

https://docs.arduino.cc/tutorials/uno-q/update-image/

Reflash the board before starting the setup to ensure a clean state.

```sh
cd ~/Downloads/arduino-flasher-cli-0.5.0-linux-amd64/
./arduino-flasher-cli flash arduino-unoq-debian-image-20251229-457.tar.zst
```

------------------------------------------------------------------------

# 🧰 Initial Setup via ADB

## 1️⃣ First Boot -- Mandatory Password Setup

After flashing, the board requires setting a password.

Set it to `arduino` (workshop default):

``` bash
adb shell "printf '%s\n%s\n' 'arduino' 'arduino' | passwd"
```

------------------------------------------------------------------------

## 2️⃣ Connect to Wi-Fi

``` bash
adb shell "nmcli dev wifi connect 'FoundriesWorkshop' password '@FoundriesWorkshop123'"

adb shell "nmcli dev wifi connect 'Foundries' password '@Foundries.io123'"
```

Verify:

``` bash
adb shell "ip addr show wlan0"
```

------------------------------------------------------------------------

# 🔐 Enable SSH (CRITICAL STEP)

After fresh flash, SSH service fails because host keys are missing.

Generate host keys:

``` bash
adb shell "echo 'arduino' | sudo -S ssh-keygen -A"
```

Enable and start SSH:

``` bash
adb shell "echo 'arduino' | sudo -S systemctl enable ssh"
adb shell "echo 'arduino' | sudo -S systemctl start ssh"
```

Verify:

``` bash
adb shell "echo 'arduino' | sudo -S systemctl status ssh --no-pager"
adb shell "ss -ltnp | grep ':22' || true"
```

Expected:

    Server listening on 0.0.0.0 port 22.

------------------------------------------------------------------------

## 3️⃣ Test SSH

From your computer:

``` bash
ssh arduino@<BOARD_IP>
```

Password:

    arduino

------------------------------------------------------------------------

# 🌐 Static IP Configuration (Optional)

Set static IP example:

``` bash
adb shell "echo 'arduino' | sudo -S nmcli connection modify 'FoundriesWorkshop' ipv4.method manual ipv4.addresses 192.168.20.20/24 ipv4.gateway 192.168.20.1 ipv4.dns 8.8.8.8"
```

Restart connection:

``` bash
adb shell "echo 'arduino' | sudo -S nmcli connection down 'FoundriesWorkshop'"
adb shell "echo 'arduino' | sudo -S nmcli connection up 'FoundriesWorkshop'"
```

------------------------------------------------------------------------

## Revert Back to DHCP

``` bash
adb shell "echo 'arduino' | sudo -S nmcli connection modify 'FoundriesWorkshop' ipv4.method auto"
adb shell "echo 'arduino' | sudo -S nmcli connection down 'FoundriesWorkshop'"
adb shell "echo 'arduino' | sudo -S nmcli connection up 'FoundriesWorkshop'"
```

------------------------------------------------------------------------

# 🐳 Docker Registry Mirror -- Workshop Setup

## 1️⃣ Server Setup (Laptop)

``` bash
mkdir registry-mirror
cd registry-mirror
```

### config.yml

``` yaml
version: 0.1

log:
  level: info

http:
  addr: 0.0.0.0:5000

storage:
  filesystem:
    rootdirectory: /var/lib/registry

proxy:
  remoteurl: https://registry-1.docker.io
```

### docker-compose.yml

``` yaml
services:
  registry-mirror:
    image: registry:2
    container_name: registry-mirror
    restart: always
    ports:
      - "5000:5000"
    volumes:
      - ./config.yml:/etc/docker/registry/config.yml:ro
      - registry-data:/var/lib/registry

volumes:
  registry-data:
```

Start:

``` bash
docker compose up -d
```

Verify:

``` bash
curl http://localhost:5000/v2/
```

Expected:

    {}

------------------------------------------------------------------------

## 2️⃣ Configure Clients

Add to `/etc/hosts`:
``` sh
echo "192.168.20.10   rauls-server" | sudo tee -a /etc/hosts >/dev/null
```

Edit `/etc/docker/daemon.json`:

``` sh
sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "2"
  },
  "registry-mirrors": ["http://rauls-server:5000"],
  "insecure-registries": ["rauls-server:5000"]
}
EOF
```

Restart Docker:

``` bash
sudo systemctl restart docker
```

Via ADB:

```sh
adb shell "echo 'arduino' | sudo -S sh -c \"grep -q 'rauls-server' /etc/hosts || echo '192.168.20.10   rauls-server' >> /etc/hosts\""
adb shell "echo 'arduino' | sudo -S sh -c 'cat > /etc/docker/daemon.json <<\"EOF\"
{
  \"log-driver\": \"json-file\",
  \"log-opts\": {
    \"max-size\": \"10m\",
    \"max-file\": \"2\"
  },
  \"registry-mirrors\": [\"http://rauls-server:5000\"],
  \"insecure-registries\": [\"rauls-server:5000\"]
}
EOF'"
adb shell "echo 'arduino' | sudo -S systemctl restart docker"
adb shell "echo 'arduino' | sudo -S docker info | grep -i mirror -A2"
```

------------------------------------------------------------------------

## 3️⃣ Validate Mirror

On one board:

``` bash
docker pull debian:trixie-slim
```

On server:

``` bash
docker logs -f registry-mirror
```

------------------------------------------------------------------------

## 4️⃣ Pre-Warm Cache (Before Workshop)

``` bash
docker pull debian:trixie-slim
docker pull registry:2
docker pull python:3
```

------------------------------------------------------------------------

# 🖥 Prevent Screen Sleep

``` bash
sudo mkdir -p /etc/X11/xorg.conf.d
sudo nano /etc/X11/xorg.conf.d/10-monitor.conf
```
```sh
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
```

Adb Command:

```sh
adb shell "echo 'arduino' | sudo -S sh -c 'mkdir -p /etc/X11/xorg.conf.d && cat > /etc/X11/xorg.conf.d/10-monitor.conf <<\"EOF\"
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
```

------------------------------------------------------------------------

# ✅ Final Workshop State

-   Router configured (192.168.20.1)\
-   Wi‑Fi SSIDs active\
-   Board freshly flashed\
-   Wi‑Fi connected\
-   SSH enabled and working\
-   Password: `arduino`\
-   Optional static IP\
-   Docker mirror operational\
-   Cache pre-warmed\
-   Screen sleep disabled

Workshop-ready and validated.

# Script

```sh
chmod +x ./uno_q_provision.sh

# default (DHCP, SSID FoundriesWorkshop, senha @FoundriesWorkshop123, password arduino)
./uno_q_provision.sh

# escolher SSID/senha
./uno_q_provision.sh --ssid FoundriesWorkshop_5G --wifi-pass '@FoundriesWorkshop123'

# IP fixo
./uno_q_provision.sh --static-ip 192.168.20.20 --gateway 192.168.20.1 --dns 8.8.8.8

# configurar mirror docker + /etc/hosts
./uno_q_provision.sh --configure-mirror --server-ip 192.168.20.10 --mirror-host rauls-server
```






# Fioup


```sh
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg


curl -L https://fioup.foundries.io/pkg/deb/dists/stable/Release.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fioup-stable.gpg

echo 'deb [signed-by=/etc/apt/trusted.gpg.d/fioup-stable.gpg] https://fioup.foundries.io/pkg/deb stable main' | sudo tee /etc/apt/sources.list.d/fioup.list


sudo apt update
sudo apt install fioup

sudo mkdir -p /var/sota
sudo chown -R $USER /var/sota

sudo usermod -aG docker $USER

sudo fioup register --api-token <TOKEN> --factory <FACTORY_NAME> --name <DEVICE_IP> --apps pingpong-webui
```


```sh
adb shell "echo 'arduino' | sudo -S apt update"
adb shell "echo 'arduino' | sudo -S apt install -y apt-transport-https ca-certificates curl gnupg"
adb shell "echo 'arduino' | sudo -S sh -c 'curl -L https://fioup.foundries.io/pkg/deb/dists/stable/Release.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/fioup-stable.gpg'"
adb shell "echo 'arduino' | sudo -S sh -c \"echo 'deb [signed-by=/etc/apt/trusted.gpg.d/fioup-stable.gpg] https://fioup.foundries.io/pkg/deb stable main' > /etc/apt/sources.list.d/fioup.list\""
adb shell "echo 'arduino' | sudo -S apt update"
adb shell "echo 'arduino' | sudo -S apt install -y fioup"
adb shell "echo 'arduino' | sudo -S mkdir -p /var/sota"
adb shell "echo 'arduino' | sudo -S chown -R arduino /var/sota"
adb shell "echo 'arduino' | sudo -S usermod -aG docker arduino"
adb shell "fioup register --api-token 3afb43511c93da9a31100e181d2b17cf81f61230 --factory demo-2026-arduino --name qualcomm-1 --apps home-ai-webui"

adb shell "echo 'arduino' | sudo -S sed -i '/^\[uptane\]/a polling_seconds = \"10\"' /var/sota/sota.toml"
adb shell "grep -A3 '^\[uptane\]' /var/sota/sota.toml"


Register to demo-ew-class-26
6bda2775bd62c39a5e9e2eee0f67982fa59803e0

Register demo-2026-arduino
3afb43511c93da9a31100e181d2b17cf81f61230
```

## Desktop icon


```sh
DESKTOP_FILE="/home/arduino/Desktop/App.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat << 'EOF' > "$DESKTOP_FILE"
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

chmod 644 "$DESKTOP_FILE"
```

```sh
DESKTOP_FILE="/home/arduino/Desktop/App.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat << 'EOF' > "$DESKTOP_FILE"
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

chmod 644 "$DESKTOP_FILE"
```

# Auto Start

```sh
adb shell "echo 'arduino' | sudo -S sh -c 'cat > /etc/xdg/autostart/kiosk.desktop <<\"EOF\"
[Desktop Entry]
Type=Application
Name=Kiosk
Exec=chromium --kiosk http://localhost:8000
X-GNOME-Autostart-enabled=true
EOF'"
```

```sh
sudo sh -c 'cat > /etc/xdg/autostart/kiosk.desktop << "EOF"
[Desktop Entry]
Type=Application
Name=Kiosk
Exec=chromium --kiosk --noerrdialogs --disable-infobars http://localhost:8000
X-GNOME-Autostart-enabled=true
EOF'
```


## DISABLE APPLABS

```sh

adb shell "echo 'arduino' | sudo -S rm /etc/xdg/autostart/ArduinoAppLab.desktop"

```

## Auto Login


```sh
sudo mkdir -p /etc/lightdm/lightdm.conf.d

sudo tee /etc/lightdm/lightdm.conf.d/50-autologin.conf >/dev/null <<'EOF'
[Seat:*]
autologin-user=arduino
autologin-user-timeout=0
EOF

sudo reboot
```

```sh
adb shell "echo 'arduino' | sudo -S mkdir -p /etc/lightdm/lightdm.conf.d"

adb shell "echo 'arduino' | sudo -S sh -c 'cat > /etc/lightdm/lightdm.conf.d/50-autologin.conf <<\"EOF\"
[Seat:*]
autologin-user=arduino
autologin-user-timeout=0
EOF'"

adb shell "echo 'arduino' | sudo -S reboot"
```

