adb shell "printf '%s\n%s\n' 'arduino' 'arduino' | passwd"
adb shell "nmcli dev wifi connect 'FoundriesWorkshop' password '@FoundriesWorkshop123'"
adb shell "ip addr show wlan0"
adb shell "echo 'arduino' | sudo -S ssh-keygen -A"
adb shell "echo 'arduino' | sudo -S systemctl enable ssh"
adb shell "echo 'arduino' | sudo -S systemctl start ssh"
adb shell "ss -ltnp | grep ':22' || true"
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

adb shell "echo 'arduino' | sudo -S rm /etc/xdg/autostart/ArduinoAppLab.desktop"


adb shell "echo 'arduino' | sudo -S hostnamectl set-hostname uno-q-01"
adb shell "echo 'arduino' | sudo -S sed -i 's/127.0.1.1.*/127.0.1.1    uno-q-02/' /etc/hosts"


sudo apt install -y apt-transport-https ca-certificates curl gnupg
curl -L https://fioup.foundries.io/pkg/deb/dists/stable/Release.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fioup-stable.gpg
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/fioup-stable.gpg] https://fioup.foundries.io/pkg/deb stable main' | sudo tee /etc/apt/sources.list.d/fioup.list
sudo apt update
sudo apt install -y fioup
sudo mkdir -p /var/sota
sudo chown -R $USER /var/sota
sudo usermod -aG docker $USER
echo "192.168.20.10   rauls-server" | sudo tee -a /etc/hosts >/dev/null
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

sudo shutdown -r now

