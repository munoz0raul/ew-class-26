# LED Voice Classifier (Sysfs)

In this example, the app **only classifies audio** using **Edge Impulse** and prints the results in the terminal. When a valid color is detected, it updates **only the user-space LEDs** via sysfs.

Getting Started

Create and Enter a Directory

> [!NOTE] 
> Run the following commands on the device

```sh
device:~$ mkdir 8-led-voice
device:~$ cd 8-led-voice
```

Main Application

```sh
vim led-voice.py
```
[led-voice.py](led-voice.py)

Voice Model

The default model is `deployment.eim`:

- [deployment.eim](deployment.eim)

Dockerfile and Compose

```sh
vim Dockerfile
```
[Dockerfile](Dockerfile)

Build and Run the Container

With all the files in the same folder, build the container and add the tag `led-voice:latest` to it.

```sh
device:~$ docker build --tag led-voice:latest .
```

Launch the Container

We must run with `--privileged` so the container can access GPIO and sysfs, and mount the Arduino router socket.

```sh
device:~$ docker run -it -d --name led-voice \
  --privileged \
  --device /dev/snd:/dev/snd \
  --group-add audio \
  -e THRESH=0.70 \
  -e PA_ALSA_DEVICE=0 \
  -e PA_ALSA_CARD=1 \
  -e PA_ALSA_PLUGHW=1 \
  led-voice:latest
```
Debugging

Check the Running Container

```sh
device:~$ docker ps
```

Check the Logs

```sh
device:~$ docker logs -f led-voice
```

Speak the following worlds in the microphone:
```sh
blue green purple red yellow
```

Check the logs:
```sh
Result (21 ms.) blue: 0.00	green: 0.00	purple: 0.00	red: 0.00	yellow: 0.00	
Result (22 ms.) blue: 0.00	green: 0.00	purple: 0.00	red: 0.00	yellow: 0.00	
Result (21 ms.) blue: 0.03	green: 0.07	purple: 0.04	red: 0.02	yellow: 0.00	
Result (21 ms.) blue: 0.01	green: 0.90	purple: 0.00	red: 0.01	yellow: 0.00	
Result (21 ms.) blue: 0.03	green: 0.93	purple: 0.00	red: 0.02	yellow: 0.00	
Result (21 ms.) blue: 0.03	green: 0.90	purple: 0.00	red: 0.02	yellow: 0.00
```

Check if the color changes.

Docker Compose

To simplify container management, create the `docker-compose.yml` file:

```sh
vim docker-compose.yml
```
[docker-compose.yml](docker-compose.yml)

Stop the Running Container

```sh
device:~$ docker rm -f led-voice
```

Run with Docker Compose

```sh
device:~$ docker compose up
```

Voice Flow (Summary)

1. The Edge Impulse runner starts with `deployment.eim`.
2. The script prints classification scores to the terminal.
3. When a color label crosses `THRESH`, sysfs LEDs are updated.

Debugging

Check the Running Container

```sh
device:~$ docker ps
```

Check the Logs

```sh
device:~$ docker logs -f led-voice
```

If audio does not work, confirm `/dev/snd` is available and the container is running with `privileged: true` and `group_add: ["audio"]`.

Remove the running docker:
```sh
docker:~$ docker rm -f led-voice
```
Return One Folder Up

```sh
device:~$ cd ..
```
