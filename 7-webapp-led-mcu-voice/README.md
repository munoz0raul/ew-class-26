# Class Voice LED (Web UI)

Neste exemplo, a UI responde **somente a comandos de voz** usando **Edge Impulse**. O fluxo é dizer **“Select”** e, em seguida, dizer uma **cor** para acender os **LEDs do Arduino Uno Q** via *device bridge*. A UI fica disponível na porta `8000`.

> Para requisitos da imagem base e visão geral do ambiente, veja
> `../0game-base/README.md`.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir class-voice-led-webui
device:~$ cd class-voice-led-webui
```

### Main Application

```sh
vim class-voice-led-webui.py
```
[class-voice-led-webui.py](class-voice-led-webui.py)

### UI (HTML)

```sh
vim index-class-voice-led-webui.html
```
[index-class-voice-led-webui.html](index-class-voice-led-webui.html)

### Voice Model

The default model is `deployment.eim`:

- [deployment.eim](deployment.eim)
- [model.eim](model.eim)

### Logo Assets

- [arduino.png](arduino.png)
- [edgeimpulse.png](edgeimpulse.png)
- [foundries.png](foundries.png)
- [qualcomm.png](qualcomm.png)

### Dockerfile and Compose

```sh
vim Dockerfile
```
[Dockerfile](Dockerfile)

```sh
vim docker-compose.yml
```
[docker-compose.yml](docker-compose.yml)

## Run with Docker Compose

```sh
device:~$ docker compose up
```

At startup, the service prints:

- `http://0.0.0.0:8000`
- `http://127.0.0.1:8000`
- **Local IPs** (example: `http://192.168.x.x:8000`)

## Voice Flow (Summary)

1. The Edge Impulse runner starts with `deployment.eim`.
2. Say **“Select”** to open the color window.
3. Say **blue, green, red, yellow,** or **purple**.
4. The UI updates and the MCU LEDs turn on via *Bridge*.

## Debugging

### Check the Running Container

```sh
device:~$ docker ps
```

### Check the Logs

```sh
device:~$ docker logs class-voice-led-webui
```

If audio does not work, confirm `/dev/snd` is available and the container is running with `privileged: true` and `group_add: ["audio"]`.

## Notes

- The container uses `network_mode: host` and exposes port `8000`.
- The Arduino Bridge socket must be mounted:
  - `/var/run/arduino-router.sock:/var/run/arduino-router.sock`

## References

- Base image: `../0game-base/README.md`
