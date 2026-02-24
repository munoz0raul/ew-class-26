# Hello World C / No Display

https://github.com/munoz0raul/ew-class-26/tree/main/hello-c

When working with Docker, you first build a Docker Image. A Docker image is all the files necessary to run an application. For training and testing, people usually base images around Ubuntu or Debian Linux. These distributions come with the apt package management tool that handles installation, dependencies, and removal.

Since this is an embedded training, we will demonstrate the classic 'Hello World' project.
However, there is a challenge: an embedded Linux distribution is optimized for embedded systems. It is lightweight and does not come with a compiler, such as GCC.

On the other hand, if this distribution supports Docker Containers, you can use Docker to build it.

> [!NOTE] 
> Run the following commands on the device

Create and enter a directory called hello-c:
```sh
device:~$ mkdir hello-c
device:~$ cd hello-c
```

> [!WARNING] 
> Spaces are essential on some files. When copying and pasting the file content, use the GitHub page or download the reference example:

To build a Hello World application, you need a helloworld.c file:

> [!NOTE] 
> If you are not familiar with vim, it is a free text editor. The way it works is: press (esc) as many times as you want, which brings you to the command prompt (bottom screen). If you press (i or a) it allows you to insert/append.
> When you finish, you can press (esc) again and type (:wq) to write and quit.

```sh
vim helloworld.c  (i) to insert
```
https://github.com/munoz0raul/ew-class-26/blob/main/hello-c/helloworld.c

```sh
(esc) (:wq)
```

Unlike a normal distribution, a Docker Container usually runs one app per container. The file start.sh will be the shell script executed when running the Docker Image.

```sh
vim start.sh
```
https://github.com/munoz0raul/ew-class-26/blob/main/hello-c/start.sh

The Dockerfile is where you specify all the commands to be executed before the final application is built. Here is where you specify packages to install, and the files you want to COPY from your host machine to the Docker Image.

A quick explanation of this Dockerfile:

FROM: It is starting from a Debian stable-slim distro. Everything included in this distribution version will be available.

RUN apt-get update and install: Install build-essential package.

> [!NOTE] 
> The build-essential package is a meta-package that includes everything needed to compile software. This includes the GNU/g++ compiler collection, GNU debugger (gdb), and other libraries and tools needed for compiling a program

COPY: helloworld.c and start.sh from the host to the Docker Image.
WORKDIR: move to the specified directory.
RUN: runs the gcc to build the helloworld.c file creating the helloworld executable.
ENTRYPOINT: The command docker will run when starting the Docker Image.

```sh
vim Dockerfile
```
https://github.com/munoz0raul/ew-class-26/blob/main/hello-c/Dockerfile

With all the files in the same folder, build the container and add the tag hello-c:latest to it. Make sure to copy the dot after the latest.

> [!NOTE] 
> The Docker commands must be done in your hello-c folder.

```sh
device:~$ docker build --tag hello-c:latest .
```

Listing all Docker Images installed on your machine:
```sh
device:~$ docker image ls
```

Launching the container:
```sh
device:~$ docker run -it --rm hello-c:latest
hello, world!
```

## What is Docker Compose?
Docker Compose is a tool that defines and runs multi-container Docker applications. It uses a YAML file (docker-compose.yml) to configure the application's services, networks, and volumes.

Service Definition: Define each service (container) in the application.
Networking: Automatically create a network for communication between services.
Volumes: Define persistent storage for containers.
Dependency Management: Start services in the correct order based on dependencies.

The Compose file is a YAML file defining services, networks, and volumes for a Docker application.

Create your Docker Compose YAML:

```sh
vim docker-compose.yml
```
https://github.com/munoz0raul/ew-class-26/blob/main/hello-c/docker-compose.yml

Running Docker Compose App
```sh
device:~$ docker compose up -d
[+] Building 0.0s (0/0)                                                                        
[+] Running 1/1
 ✔ Container hello-c-hello-c-1  Started 
```

Check the running containers:
```sh
device:~$ docker ps
CONTAINER ID   IMAGE            COMMAND           CREATED              STATUS          PORTS     NAMES
c0fee9005c0d   hello-c:latest   "/app/start.sh"   About a minute ago   Up 44 seconds             hello-c-hello-c-1
```

Read the container logs:
```sh
device:~$ docker logs c0fee9005c0d
hello, world!
hello, world!
hello, world!
hello, world!
```

## Accessing a Running Container's Terminal with docker exec

The docker exec command executes a command within a running Docker container. It allows you to interact with a container without stopping or restarting it.

### Identify the Running Container

Before using docker exec, you need to know the name or ID of the running container. Use the following command to list all running containers:

```sh
device:~$ docker ps
CONTAINER ID   IMAGE            COMMAND           CREATED              STATUS         PORTS     NAMES
beda4f352d11   hello-c:latest   "/app/start.sh"   About a minute ago   Up 9 seconds             hello-c-hello-c-1
```

### Access the Container's Shell
To access the container's terminal shell, use the -it flags with docker exec:

-i: Keeps the input stream open (interactive mode).
-t: Allocates a pseudo-TTY (terminal).

Run the following command:

```sh
device:~$ docker exec -it hello-c-hello-c-1 /bin/bash
```

Now inside the container, check the files installed inside the Docker Image:
```sh
docker:~$ ls -l
-rwxr-xr-x 1 root root 70440 Feb 15 00:32 helloworld
-rw-r--r-- 1 root root    83 Feb 15 00:27 helloworld.c
-rwxr-xr-x 1 root root    55 Feb 15 00:28 start.sh
```

Check if gcc is installed inside the container:
```sh
docker:~$ type gcc
gcc is /usr/bin/gcc
```

Return one folder:
```sh
device:~$ cd ..