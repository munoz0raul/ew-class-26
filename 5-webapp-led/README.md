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

Start with the `webapp-led.py` file:

```sh
vim webapp-led.py
```
[webapp-led.py](webapp-led.py)

### Create the HTML File

```sh
vim index.html
```
[index.html](index.html)

### Add the Logo Assets

These files are used in the header:

- [arduino.png](arduino.png)
- [edgeimpulse.png](edgeimpulse.png)
- [foundries.png](foundries.png)
- [qualcomm.png](qualcomm.png)

### Create the Dockerfile

```sh
vim Dockerfile
```
[Dockerfile](Dockerfile)

## Build and Run the Container

With all the files in the same folder, build the container and add the tag `webapp-led:latest` to it.

```sh
device:~$ docker build --tag webapp-led:latest .
```

### Launch the Container

We must run with `--privileged` so the container can write to `/sys/class/leds/*`.

```sh
device:~$ docker run -it -p 9900:9900 -d --rm --name webapp-led --privileged webapp-led:latest
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
device:~$ docker logs webapp-led
```

If you see permission errors writing to `/sys/class/leds/*`, verify the container was started with `--privileged`.

## Docker Compose

To simplify container management, create the `docker-compose.yml` file:

```sh
vim docker-compose.yml
```
[docker-compose.yml](docker-compose.yml)

### Stop the Running Container

```sh
device:~$ docker stop webapp-led
```

### Run the Application with Docker Compose

```sh
device:~$ docker compose up -d
```

### Return One Folder Up

```sh
device:~$ cd ..
```
### Check the Logs of the Running Image
