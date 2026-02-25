# LED Voice Classifier (Sysfs)

Neste exemplo, o app **apenas classifica áudio** usando **Edge Impulse** e imprime os resultados no terminal. Quando a classificação detecta uma cor válida, o app ajusta **somente os LEDs de user space** via sysfs.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir led-voice
device:~$ cd led-voice
```

### Main Application

```sh
vim led-voice.py
```
[led-voice.py](led-voice.py)

### Voice Model

The default model is `deployment.eim`:

- [deployment.eim](deployment.eim)
- [deployment.eim](deployment.eim)

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

## Voice Flow (Summary)

1. The Edge Impulse runner starts with `deployment.eim`.
2. The script prints classification scores to the terminal.
3. When a color label crosses `THRESH`, sysfs LEDs are updated.

## Debugging

### Check the Running Container

```sh
device:~$ docker ps
```

### Check the Logs

```sh
device:~$ docker logs led-voice
```

If audio does not work, confirm `/dev/snd` is available and the container is running with `privileged: true` and `group_add: ["audio"]`.

## References

- Base image: `../0game-base/README.md`
