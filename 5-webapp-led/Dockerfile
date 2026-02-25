FROM debian:trixie-slim AS builder

#Install packages
RUN apt-get update && \
        apt-get install -y --no-install-recommends python3-pip && \
        rm -rf /var/lib/apt/lists/*
RUN pip install --break-system-packages flask flask_restful
RUN mkdir -p /app/
COPY webapp-led.py /app/
COPY index.html /app/index.html
COPY *.png /app/

WORKDIR /app/
CMD ["python3", "webapp-led.py"]
