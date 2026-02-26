# BlinkLED + WebApp (MCU + Sysfs)


In this example, a Flask web app controls **both** the system LEDs (sysfs) and the MCU LEDs via the Arduino Bridge. The Docker image uses a multi-stage build to compile and flash the MCU firmware before starting the UI. Each color tile acts as a switch: click once to turn on, click again to turn off.


Getting Started

Create and Enter a Directory

> [!NOTE] 
> Run the following commands on the device

```sh
device:~$ mkdir 6-webapp-led-mcu
device:~$ cd 6-webapp-led-mcu
```

Build the Flask App

Start with the `webapp-led-mcu.py` file:

```sh
vim webapp-led-mcu.py
```
[webapp-led-mcu.py](webapp-led-mcu.py)

Create the HTML File

```sh
vim index.html
```
[index.html](index.html)

Assets Folder

All MCU and UI assets are grouped in `assets/`:

- [assets/arduino.png](assets/arduino.png)
- [assets/edgeimpulse.png](assets/edgeimpulse.png)
- [assets/foundries.png](assets/foundries.png)
- [assets/qualcomm.png](assets/qualcomm.png)
- [assets/sketch.yaml](assets/sketch.yaml)
- [assets/sketch.ino](assets/sketch.ino)
- [assets/frames.h](assets/frames.h)
- [assets/arduino.asc](assets/arduino.asc)
- [assets/arduino.list](assets/arduino.list)
- [assets/openocd/](assets/openocd/)

Start Script

```sh
vim start.sh
```
[start.sh](start.sh)

Create the Dockerfile

```sh
vim Dockerfile
```
[Dockerfile](Dockerfile)

Build and Run the Container

With all the files in the same folder, build the container and add the tag `webapp-led-mcu:latest` to it.

```sh
device:~$ docker build --tag webapp-led-mcu:latest .
```

Launch the Container

We must run with `--privileged` so the container can access GPIO and sysfs, and mount the Arduino router socket.

```sh
device:~$ docker run -it --network host -d --rm --name webapp-led-mcu \
    --privileged \
	-v /var/run/arduino-router.sock:/var/run/arduino-router.sock \
	-v /etc/localtime:/etc/localtime:ro \
	webapp-led-mcu:latest
```

Open the page in your browser using the device IP.

Debugging

Check the Running Container

```sh
device:~$ docker ps
```

Check the Logs

```sh
device:~$ docker logs -f webapp-led-mcu
```

If Bridge calls fail, confirm `/var/run/arduino-router.sock` is mounted and the container is running with `--privileged`.

Docker Compose

To simplify container management, create the `docker-compose.yml` file:

```sh
vim docker-compose.yml
```
[docker-compose.yml](docker-compose.yml)

Stop the Running Container

```sh
device:~$ docker rm -f webapp-led-mcu
```

Run the Application with Docker Compose

```sh
device:~$ docker compose up -d
```

Remove the running docker:
```sh
docker:~$ docker rm -f webapp-led-mcu
```
Return One Folder Up

```sh
device:~$ cd ..
```
