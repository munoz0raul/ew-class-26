# Embedded World Class 2026
## From Vision to Deployment: Developing Secure AI-Enabled Linux Devices

This hands-on workshop demonstrates how to build real-world embedded Linux products that combine:

- Embedded Linux
- Containerized applications
- Hardware integration
- Edge AI
- Secure deployment workflows
- Device lifecycle management

Instead of focusing on isolated technologies, this workshop follows the full journey of an embedded product — from prototype to production-ready architecture.

---

## Workshop Philosophy

Modern embedded devices are no longer single applications running on custom firmware.

They are:

- Linux-based systems
- running containerized applications
- integrating AI workloads
- remotely updated and managed over time.

This workshop shows how to structure development around:

👉 lifecycle-first engineering.

---

## Hardware Platform

Participants will use:

- Arduino Uno Q (Debian-based Embedded Linux)
- USB peripherals (microphone, networking)
- Containerized applications running locally.

The device ships with Debian to accelerate prototyping.

During the workshop we discuss:

- why Debian is excellent for early development
- why production systems often migrate to custom distributions (e.g. Yocto).

---

## Learning Path

Each lab builds incrementally toward a complete embedded system.

### Phase 1 — Container Fundamentals

1-hello-c  
Build and run your first containerized application.

2-multi  
Learn multi-stage builds and optimized container images.

---

### Phase 2 — Hardware Interaction

3-blinkled  
Access hardware from containers and understand permissions and debugging.

---

### Phase 3 — Application Architecture

4-webapp  
Introduce networked services and web applications.

5-webapp-led  
Connect UI interactions with hardware control.

6-webapp-led-mcu  
Integrate Linux applications with MCU-based systems.

---

### Phase 4 — Edge AI Integration

7-edgeimpulse  
Train and export an AI model using Edge Impulse.

8-led-voice  
Run local AI inference controlling hardware.

---

### Phase 5 — Full System Integration

9-webapp-led-mcu-voice  
Combine UI, AI, and hardware into a complete embedded architecture.

---

### Phase 6 — Production Lifecycle

10-foundriesfactory  
Connect devices to CI/CD workflows and OTA deployment infrastructure.

---

## Key Concepts Covered

- Container-based embedded development
- Application isolation and reproducibility
- Hardware access from containers
- Embedded web services
- AI deployment on Linux devices
- Device lifecycle and secure updates
- CI/CD for embedded systems.

---

## Target Audience

- Embedded Linux developers
- IoT engineers
- AI engineers moving into embedded systems
- Technical leads designing connected products.

---

## Requirements

Participants should bring:

- Laptop with SSH client
- Modern web browser
- Basic familiarity with Linux command line.

---

## Workshop Outcome

By the end of this training you will have:

- Built a working AI-enabled embedded device
- Understood the transition from prototype to production architecture
- Learned a repeatable workflow for embedded Linux development.

---

## Instructor Notes

This repository is structured to be followed sequentially.

Each lab builds on previous concepts.

Avoid skipping ahead unless instructed.