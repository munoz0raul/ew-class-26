# 10 - FoundriesFactory: From Prototype to Production

Up to this point in the workshop, we have:

- Built and run Docker containers on an embedded Linux device
- Learned about container isolation and multi-stage builds
- Interacted with hardware from inside containers
- Trained and exported AI models using Edge Impulse
- Integrated AI inference into real applications running on the device

Now comes the real challenge:

👉 **How do we take this project to production?**

Building a working demo is one thing.  
Maintaining, securing, and scaling thousands of devices in the field is another.

---

## The Production Challenge

When moving from prototype to production, we must think about:

- Security hardening
- Secure Boot
- Device identity
- CVE monitoring and patching
- SBOM (Software Bill of Materials)
- OTA (Over-The-Air) updates
- Fleet management
- Continuous integration and testing
- Long-term maintenance
- Manufacturing provisioning
- Key management and update signing

Manually managing these aspects does not scale.

This is where **FoundriesFactory** comes in.

---

## What is FoundriesFactory?

FoundriesFactory is a cloud-based platform designed to manage the full lifecycle of embedded Linux devices.

It provides:

- Secure Embedded Linux (Yocto-based)
- Automated CI/CD pipelines
- CVE scanning and patch management
- SBOM generation
- Secure Boot integration
- TUF-based secure OTA updates
- Device identity and provisioning
- Fleet monitoring and management
- Scalable product development infrastructure

Instead of treating Linux, containers, updates, and security as separate problems, FoundriesFactory integrates them into a unified workflow.

---

## Why This Matters

In real-world IoT and edge AI deployments:

- Devices must remain secure for years
- Vulnerabilities must be patched quickly
- Updates must be cryptographically signed
- Devices must have unique identities
- Teams must manage fleets remotely
- CI/CD must validate builds automatically

Without automation and infrastructure, maintaining a fleet becomes risky and expensive.

FoundriesFactory solves this by combining:

- Yocto-based secure Linux foundations
- Containerized application workflows
- Cloud-based CI/CD
- Secure update frameworks (TUF)
- Built-in device management

---

## Intermediate Step: Fioup

Before using the full FoundriesFactory OTA system, we will introduce **Fioup**.

Fioup is a lightweight tool that enables container-based device management and updates.

It allows:

- Device registration to a Factory
- Container update management
- Remote application deployment
- Simplified fleet control

This is a practical intermediate step to demonstrate fleet management using containers.

---

## Installing Fioup

Follow the official installation guide:

https://github.com/foundriesio/fioup/blob/main/docs/install.md

On your device, install fioup and verify it is available:

```bash
fioup --version
```

---

## Registering the Device

Each device must be registered to the Factory.

Follow:

https://github.com/foundriesio/fioup/blob/main/docs/register-device.md

You will:

1. Authenticate against the Factory
2. Register your device
3. Associate it with your Factory instance

After registration, your device should appear online in the FoundriesFactory dashboard.

---

## Updating Devices

Once devices are registered, you can:

- Push container updates
- Trigger updates remotely
- Monitor update status

Guide:

https://github.com/foundriesio/fioup/blob/main/docs/update-device.md

---

## Live Demonstration

At this stage:

- All devices should appear online in the Factory
- We will deploy a containerized application to all devices simultaneously
- The update will propagate through the fleet
- Devices will update securely and consistently

This demonstrates:

- Fleet-wide deployment
- Remote device management
- Secure update distribution
- Production-ready infrastructure

---

## Key Takeaway

What we built during this workshop is not just a demo.

By combining:

- AI model training (Edge Impulse)
- Containerized applications
- Secure Embedded Linux
- CI/CD pipelines
- OTA infrastructure
- Device identity management

We now have a complete workflow:

**From vision to production-ready embedded AI devices.**

This is how modern embedded Linux products are built at scale.