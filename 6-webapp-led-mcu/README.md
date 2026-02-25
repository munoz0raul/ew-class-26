# BlinkLED + WebApp (Shared volumes)

In this example, the webapp container will write a file containing a variable (e.g., 1 or 0). The blinkled container, running a shell script, will continuously read this file and update the LED status based on the variable's value. By using a shared volume, both containers can access the same file, enabling real-time communication and synchronization between the web application and the LED control logic.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

# WebApp LED (Sysfs)

In this example, a Flask web app controls the system LEDs directly through sysfs. When you click a color on the UI, the app writes to `/sys/class/leds/*/brightness` and turns the LED on/off. This builds on the previous examples by adding a modern UI while keeping the LED control in user space.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir webapp-led
device:~$ cd webapp-led
```

### Build the Flask App
# WebApp LED (MCU + Sysfs)

In this example, the web app controls both the system LEDs (sysfs) and the microcontroller LEDs through the Arduino Bridge. The Docker image uses a multi-stage build to compile and flash the MCU firmware before starting the Flask UI.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir webapp-led-mcu
device:~$ cd webapp-led-mcu
```

### Build the Flask App

Start with the `6-webapp-led-mcu.py` file:

```sh
vim 6-webapp-led-mcu.py
```
[6-webapp-led-mcu.py](6-webapp-led-mcu.py)

# WebApp LED (MCU + Sysfs)

In this example, the web app controls both the system LEDs (sysfs) and the microcontroller LEDs through the Arduino Bridge. The Docker image uses a multi-stage build to compile and flash the MCU firmware before starting the Flask UI.

## Getting Started

### Create and Enter a Directory

*Note: Run the following commands on the device*

```sh
device:~$ mkdir webapp-led-mcu
device:~$ cd webapp-led-mcu
```

### Build the Flask App

Start with the `6-webapp-led-mcu.py` file:

```sh
vim 6-webapp-led-mcu.py
```
[6-webapp-led-mcu.py](6-webapp-led-mcu.py)

### Create the HTML File

```sh
vim index.html
```
[index.html](index.html)

### Assets Folder

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

### Start Script

```sh
vim start.sh
```
[start.sh](start.sh)

### Create the Dockerfile

```sh
vim Dockerfile
```
[Dockerfile](Dockerfile)

## Build and Run the Container

With all the files in the same folder, build the container and add the tag `webapp-led-mcu:latest` to it.

```sh
device:~$ docker build --tag webapp-led-mcu:latest .
```

### Launch the Container

We must run with `--privileged` so the container can access GPIO and sysfs, and mount the Arduino router socket.

```sh
device:~$ docker run -it -p 9900:9900 -d --rm --name webapp-led-mcu --privileged \
	-v /var/run/arduino-router.sock:/var/run/arduino-router.sock \
	-v /etc/localtime:/etc/localtime:ro \
	webapp-led-mcu:latest
```

If flashing fails, add GPIO devices:

```sh
device:~$ docker run -it -p 9900:9900 -d --rm --name webapp-led-mcu --privileged \
	--device /dev/gpiochip0:/dev/gpiochip0 \
	--device /dev/gpiochip1:/dev/gpiochip1 \
	--device /dev/gpiochip2:/dev/gpiochip2 \
	-v /var/run/arduino-router.sock:/var/run/arduino-router.sock \
	-v /etc/localtime:/etc/localtime:ro \
	webapp-led-mcu:latest
```

Open the page in your browser using the device IP:

```sh
host:~$ curl http://192.168.15.97:9900
```

## Debugging

### Check the Running Container

```sh
device:~$ docker ps
```

### Check the Logs

```sh
device:~$ docker logs webapp-led-mcu
```

If Bridge calls fail, confirm `/var/run/arduino-router.sock` is mounted and the container is running with `--privileged`.

## Docker Compose

To simplify container management, create the `docker-compose.yml` file:

```sh
vim docker-compose.yml
```
[docker-compose.yml](docker-compose.yml)

### Stop the Running Container

```sh
device:~$ docker stop webapp-led-mcu
```

### Run the Application with Docker Compose

```sh
device:~$ docker compose up -d
```

### Return One Folder Up

```sh
device:~$ cd ..
```
