FROM debian:trixie-slim AS builder
ENV DEBIAN_FRONTEND=noninteractive

COPY arduino.asc /etc/apt/keyrings/arduino.asc
COPY arduino.list /etc/apt/sources.list.d/arduino.list

RUN chmod 644 /etc/apt/keyrings/arduino.asc

RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates

RUN apt-get update && \
    apt-get install -y \
        arduino-cli \
        build-essential gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN arduino-cli core install arduino:zephyr -v

RUN mkdir -p /app/sketch
COPY sketch.yaml sketch.ino /app/sketch/

RUN arduino-cli compile -b arduino:zephyr:unoq --output-dir "/app/sketch" "/app/sketch"

FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y \
        python3 python3-venv python3-dev python3-pip \
        libgpiod3 bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV VENV=/opt/venv
RUN python3 -m venv $VENV
ENV PATH="$VENV/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel && \
    pip install https://github.com/arduino/app-bricks-py/releases/download/release%2F0.5.0/arduino_app_bricks-0.5.0-py3-none-any.whl && \
    pip install numpy watchdog flask

RUN mkdir -p /app/sketch
# Copy compiled sketch from builder stage
COPY --from=builder /app/sketch/*.elf-zsk.bin /app/sketch/
COPY --from=builder /app/sketch/*.elf /app/sketch/

# Copy application files
COPY openocd /opt/openocd

COPY 6-webapp-led-mcu.py /app/
COPY index.html /app/index.html
COPY *.png /app/

COPY start.sh /app/
RUN chmod +x /app/start.sh
WORKDIR /app

CMD ["/app/start.sh"]
