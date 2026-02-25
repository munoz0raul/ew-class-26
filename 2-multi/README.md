# Multi-stage Container

[Project files](.)

A multi-stage container is a powerful Docker feature that enables you to build smaller, more efficient, and more secure container images. Here's a simple explanation of why multi-stage containers are interesting and why they matter:

A multi-stage container utilizes multiple stages (or steps) in a single Dockerfile to:

Build the application (e.g., compile code, install dependencies).
Copy only the necessary files (e.g., the compiled binary or runtime files) to the final image.
Discard the rest (e.g., build tools, intermediate files).

This results in a smaller and cleaner final image.


> [!NOTE] 
> Run the following commands on the device

Create and enter a directory called multi:
```sh
device:~$ mkdir multi
device:~$ cd multi
```

You can also create each file by following the instructions below or use the following instructions to learn each file function:

To build a multi-stage, you need a hellowold.c file:

```sh
vim helloworld.c
```
[helloworld.c](helloworld.c)


Unlike normal distribution, a Docker Container usually runs one app per container. The file start.sh will be the shell script executed when running the Docker Image.

```sh
vim start.sh
```
[start.sh](start.sh)

A quick explanation of this Dockerfile:

FROM AS builder: It starts from a Debian distro in the first stage and it is named as builder. Everything included in this distribution version will be available.

RUN: echo “Final Stage” is the last command on the first stage.

FROM AS final-stage: It starts a new image from a Debian distro and it is named as final-stage. Everything included in this distribution version will be available.

RUN: apt-get update now is NOT installing build-essentials package.

COPY --from=builder /app/helloworld /app/: is copying the helloworld binary from the first stage container builder to the second stage container.

```sh
vim Dockerfile
```
[Dockerfile](Dockerfile)

With all the files in the same folder, build the container and add the tag multi-stage:latest to it. Make sure to copy the dot after the latest.

> [!NOTE] 
> The Docker commands must be done in your multi-stage folder.

```sh
device:~$ docker build --tag multi-stage:latest .
```

Listing all Docker Images installed on your machine:
```sh
device:~$ docker image ls
```

Launch the container with -d to detach it and --name to specify a name.
```sh
docker run -it --rm --name multi-stage -d multi-stage
```

Check for the running container:
```sh
device:~$ docker ps
CONTAINER ID   IMAGE         COMMAND           CREATED          STATUS          PORTS     NAMES
f95415ab19d0   multi-stage   "/app/start.sh"   About a minute ago   Up About a minute             multi-stage
```

Now let’s jump inside the container and see what is installed there:
```sh
device:~$ docker exec -it multi-stage /bin/bash
```

Now inside the container, check the files installed inside the Docker Image:
```sh
docker:~$ ls -l
-rwxr-xr-x 1 root root 70440 Feb 15 00:32 helloworld
-rwxr-xr-x 1 root root    55 Feb 15 00:28 start.sh
```

Check if gcc is installed inside the container:
```sh
docker:~$ type gcc
bash: type: gcc: not found
```

Exit the container:
```sh
docker:~$ exit
```

Return one folder:
```sh
device:~$ cd ..
```