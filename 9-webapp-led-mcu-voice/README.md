# LED Voice Classifier WebUI (MCU + Sysfs)

In this example, the UI responds **only to voice commands** using **Edge Impulse**. The flow is to say **“Select”** and then say a **color** to light the **Arduino Uno Q LEDs** via the *device bridge*. The UI is available on port `8000`.

Getting Started

Create and Enter a Directory

> [!NOTE] 
> Run the following commands on the device

```sh
device:~$ mkdir 9-webapp-led-mcu-voice
device:~$ cd 9-webapp-led-mcu-voice
```

Main Application

```sh
vim webapp-led-mcu-voice.py
```
[webapp-led-mcu-voice.py](webapp-led-mcu-voice.py)

UI (HTML)

```sh
vim index.html
```
[index.html](index.html)

Voice Model

The default model is `deployment.eim`:

- [deployment.eim](deployment.eim)

Logo Assets

- [assets/arduino.png](assets/arduino.png)
- [assets/edgeimpulse.png](assets/edgeimpulse.png)
- [assets/foundries.png](assets/foundries.png)
- [assets/qualcomm.png](assets/qualcomm.png)

Dockerfile and Compose

```sh
vim Dockerfile
```
[Dockerfile](Dockerfile)

```sh
vim docker-compose.yml
```
[docker-compose.yml](docker-compose.yml)

Run with Docker Compose

```sh
device:~$ docker compose up
```

At startup, the service prints:

- `http://0.0.0.0:8000`
- `http://127.0.0.1:8000`
- **Local IPs** (example: `http://192.168.x.x:8000`)

Voice Flow (Summary)

1. The Edge Impulse runner starts with `deployment.eim`.
2. Say **“Select”** to open the color window.
3. Say **blue, green, red, yellow,** or **purple**.
4. The UI updates and the MCU LEDs turn on via *Bridge*.

Debugging

Check the Running Container

```sh
device:~$ docker ps
```

Check the Logs

```sh
device:~$ docker logs class-voice-led-webui
```

If audio does not work, confirm `/dev/snd` is available and the container is running with `privileged: true` and `group_add: ["audio"]`.

Notes

- The container uses `network_mode: host` and exposes port `8000`.
- The Arduino Bridge socket must be mounted:
  - `/var/run/arduino-router.sock:/var/run/arduino-router.sock`

References

- Base image: `../0game-base/README.md`
