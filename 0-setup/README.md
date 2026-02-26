# 0 — Setup Guide

This section prepares your device and development environment before starting the hands-on labs.

The goal is to ensure all participants begin from the same baseline configuration.

---

## Hardware Platform

We will use the Arduino Uno Q running Debian-based Embedded Linux.

Official resources:

- https://www.arduino.cc/product-uno-q
- https://docs.arduino.cc/hardware/uno-q/
- https://docs.arduino.cc/resources/datasheets/ABX00162-datasheet.pdf

---

## Hardware Setup

Before powering the device, connect:

- USB-C power supply
- USB-C hub
- Ethernet cable
- Microphone (USB audio device)
- Optional peripherals provided during the workshop

Recommended connection order:

1. Connect USB-C hub to the board
2. Connect microphone to USB-A port
3. Connect Ethernet cable
4. Connect power supply

---

## Network Connectivity

The workshop environment provides wired network access.

The board should obtain an IP address via DHCP automatically.

To verify:

```sh
ip addr
```

---

## SSH Access

You will connect to the device remotely via SSH.

### Linux

```sh
ssh USER@DEVICE_IP
```

### macOS

Use Terminal:

```sh
ssh USER@DEVICE_IP
```

### Windows

Option 1 — Windows Terminal / PowerShell:

```sh
ssh USER@DEVICE_IP
```

Option 2 — PuTTY

---

## Debian Console Basics

The device runs a Debian-based distribution.

Useful commands:

```sh
ls
cd
ip addr
sudo
```

Check system information:

```sh
uname -a
cat /etc/os-release
```

---

## Changing WiFi via Console

List available interfaces:

```sh
ip link
```

Check wireless configuration tools available (example):

```sh
nmcli
```

Example workflow:

```sh
nmcli device wifi list
nmcli device wifi connect SSID password PASSWORD
```

(Exact steps may vary depending on environment.)

---

## Verify Microphone

Check audio devices:

```sh
arecord -l
```

---

## Install / Verify Git

Check if git is installed:

```sh
git --version
```

If not installed:

```sh
sudo apt update
sudo apt install git
```

---

## Clone Workshop Repository

```sh
git clone https://github.com/munoz0raul/ew-class-26
cd ew-class-26
```

---

## Verify Docker

Ensure Docker is available:

```sh
docker --version
docker info
```

---

## Ready for Lab 1

You are ready when:

- SSH works
- Ethernet connectivity confirmed
- Repository cloned
- Docker working
- Microphone detected

Proceed to:

```sh
1-hello-c
```