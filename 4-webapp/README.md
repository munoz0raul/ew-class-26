# Web Application (port)

Flask is a lightweight and flexible micro web framework for Python, designed to make it easy to build web applications quickly.
A "Hello World" example in Flask is the simplest way to demonstrate how Flask works. It involves creating a basic web application that displays the text "Hello, World!" when accessed in a web browser.
When running a Flask application inside a Docker container, we need to map the container's port to the host machine's port so that the application can be accessed from outside the container. This is done using the -p flag in the docker run command.

Start by creating a new directory:

> [!NOTE] 
> Note: Run the following commands on the device

```sh
device:~$ mkdir webapp
device:~$ cd webapp
```

To build the Flask app, start with the webapp.py file:

```sh
device:~$ vim webapp.py
```
[webapp.py](webapp.py)

A quick explanation of this Dockerfile:

RUN apt-get update and install: Install python3-pip package.

RUN pip: install Flask.

CMD: runs Python3 with the argument webapp.py.

```sh
device:~$ vim Dockerfile
```
[Dockerfile](Dockerfile)

With all the files in the same folder, build the container and add the tag webapp:latest to it. Make sure to copy the dot after the latest.

> [!NOTE] 
> The Docker commands must be done in your webapp folder.

```sh
device:~$ docker build --tag webapp:latest .
```

Listing all Docker Images installed on your machine:

```sh
device:~$ docker image ls
```

Launch the container with -d to detach it and --name to specify a name.
Note that we are using -p to share the port 9900 from the docker with the host.

```sh
device:~$ docker run -it -p 9900:9900 -d --rm --name webapp webapp
d948ce65d5d7ffe6a214211e946ba939db7f05994191763bde82e4f5e0ad4a8a
```

Check the running images:
```sh
device:~$ docker ps
```

Check the logs of the running image
```sh
device:~$ docker logs webapp
 * Serving Flask app 'webapp'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:9900
 * Running on http://172.17.0.3:9900
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 557-327-635
```

Use your browser with the board IP to check the page result:

```sh
host:~$ curl http://192.168.15.97:9900
Hello, World!
```

To simplify container management, let’s create the docker-compose YAML for this app:

```sh
device:~$ docker-compose.yml
```
[docker-compose.yml](docker-compose.yml)

Stop the running container
```sh
device:~$ docker stop webapp
```

Running Docker Compose App:
```sh
device:~$ docker compose up
[+] Building 0.0s (0/0)                                                                        
[+] Running 2/2
 ✔ Network flask_default     Created                                                      0.2s 
 ✔ Container flask-webapp-1  Created                                                      0.1s 
Attaching to flask-webapp-1
flask-webapp-1  |  * Serving Flask app 'webapp'
flask-webapp-1  |  * Debug mode: on
flask-webapp-1  | WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
flask-webapp-1  |  * Running on all addresses (0.0.0.0)
flask-webapp-1  |  * Running on http://127.0.0.1:9900
flask-webapp-1  |  * Running on http://172.19.0.2:9900
flask-webapp-1  | Press CTRL+C to quit
flask-webapp-1  |  * Restarting with stat
flask-webapp-1  |  * Debugger is active!
flask-webapp-1  |  * Debugger PIN: 125-324-034
flask-webapp-1  | 192.168.15.14 - - [16/Feb/2025 00:21:38] "GET / HTTP/1.1" 200 -
```

Test it again using curl or your browser.
Return one folder:

```sh
device:~$ cd ..
```