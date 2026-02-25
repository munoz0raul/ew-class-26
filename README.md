
# Mastering Docker for Embedded Linux Development

This training shows how to build, run, and debug containerized apps on **embedded Linux** using **Docker**. We focus on practical workflows that move from “Hello World” to real hardware access, culminating in web UIs that control LEDs on the **Arduino Uno Q** running **Debian**.

The material is split into small, progressive examples. Each folder is a self‑contained lab with its own README and files. Together, they build a full mental model of Docker in embedded systems: images, containers, multi‑stage builds, device access, and orchestration.

## Training goals

By the end, you will be able to:

- Build and run Docker images on embedded Linux.
- Create multi‑stage Dockerfiles to reduce image size.
- Use Docker Compose for repeatable workflows.
- Access hardware (GPIO, LEDs, audio) from containers safely.
- Deploy a web UI that controls MCU LEDs via the Arduino Bridge.

## Target hardware

- **Board:** Arduino Uno Q
- **OS:** Debian (embedded Linux)
- **Use cases:** sysfs LEDs, MCU LED control via Bridge, web UI control, and voice‑driven LED selection.

## Repository structure

Start from the top and follow the sequence:

- [1-hello-c](1-hello-c/) — Minimal C app and Docker basics.
- [2-multi](2-multi/) — Multi‑stage container intro.
- [3-blinkled](3-blinkled/) — Sysfs LED control and debugging permissions.
- [4-webapp](4-webapp/) — Flask web app and port mapping.
- [5-webapp-led](5-webapp-led/) — Web UI controlling sysfs LEDs.
- [6-webapp-led-mcu](6-webapp-led-mcu/) — Multi‑stage build + MCU flashing + Bridge LED control.
- [7-webapp-led-mcu-voice](7-webapp-led-mcu-voice/) — Voice‑driven UI with Edge Impulse.
- [0game-base](0game-base/) — Shared runtime used by voice/MCU examples.

## How to use this training

Each folder contains a README with the exact steps and file links. Follow them in order, because each example builds on the previous one.

If you are running on the target board:

- Use SSH to access the board.
- Build and run the containers on the board itself.
- For hardware access, run containers with the required privileges/devices listed in each lab.

## Course conclusion

This training demonstrates how Docker can be safely and effectively used on embedded Linux without losing access to hardware. By the final example, you will have a full end‑to‑end flow: **multi‑stage builds**, **MCU firmware flashing**, **Bridge control**, and **web/voice interfaces**—all running in containers on **Debian** for the **Arduino Uno Q**.

If you complete all labs in order, you will be ready to design and ship real embedded Docker applications with clean, maintainable workflows.
