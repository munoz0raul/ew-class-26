# Lab 7 — Building an Edge AI Model with Edge Impulse

In the previous labs we focused on:

- building Embedded Linux applications
- packaging applications with containers
- interacting with hardware devices
- designing real-world system workflows

Now we introduce the missing piece:

👉 **Edge AI**

In this lab you will learn how to:

- create an Edge Impulse project
- explore an existing dataset
- understand the impulse pipeline
- train a simple keyword recognition model
- export a model that will later be integrated into our containerized application.

This lab focuses on **understanding the workflow**, not on deep ML theory.

---

## Goal

By the end of this lab you will:

- understand how Edge Impulse structures an ML pipeline
- know how models are trained for embedded deployment
- export a Linux-ready inference package.

---

## Step 1 — Clone the base project

Open the public project:

👉 https://studio.edgeimpulse.com/public/913211/latest

Click:

**Clone this project**

Select:

- Personal project
- Any project name

Example:

Embedded World 2026 - YourName

---

![Clone project](assets/edgeimpulse-10.png)

---

## Step 2 — Explore the dataset

Navigate to:
Data acquisition


You will see:

- pre-recorded audio samples
- multiple labels (keywords)

This dataset is already prepared so we can focus on the pipeline instead of data collection.

---

![Dataset view](assets/edgeimpulse-1.png)

---

## Step 3 — Understanding the Impulse

Navigate to:
Impulse design

An impulse consists of:

1. Input data (audio)
2. DSP feature extraction (MFE)
3. Machine learning model
4. Output classification

This pipeline converts raw audio into features that a neural network can understand.

---

![Impulse design](assets/edgeimpulse-7.png)

---

## Step 4 — Generate Features

Open the MFE block and click:
Generate features


This step:

- transforms raw audio into spectral features
- prepares training data for the neural network.

---

![Feature generation](assets/edgeimpulse-2.png)

---

After completion, inspect:

- Feature explorer visualization
- Class separation

---

![Feature explorer](assets/edgeimpulse-3.png)

---

## Step 5 — Train the Model

Open:
Transfer learning (Keyword spotting)


Click:
Start training

The model will:

- train using transfer learning
- optimize for embedded inference.

---

![Training result](assets/edgeimpulse-4.png)

---

After training, inspect:

- Accuracy
- Confusion matrix
- Model performance metrics

---

## Step 6 — Configure Target Device

Set the target device to:
Arduino UNO Q (Qualcomm QRB2210)

This step helps Edge Impulse estimate:

- memory usage
- latency
- inference performance.

---

![Target configuration](assets/edgeimpulse-8.png)

---

## Step 7 — Build Deployment Package

Navigate to:
Deployment

Select:

Linux (AARCH64)

Then click:
Build


This generates:

- a Linux-compatible inference package.

---

![Deployment](assets/edgeimpulse-9.png)

---

Download the generated archive.

We will use this package in the next lab.

---

## What just happened?

You built a full Edge AI pipeline:


```sh
Raw audio
↓
Feature extraction
↓
Neural network training
↓
Embedded-optimized model
↓
Linux deployment artifact
```

In the next lab we will:

👉 integrate this model into a containerized Embedded Linux application.

---

## Troubleshooting

If training fails:

- verify project cloned correctly
- ensure features were generated first
- refresh browser if training UI becomes stuck.

---

## Key Takeaway

Edge Impulse allows developers to focus on system integration instead of low-level ML engineering.

In this workshop we use it as:

👉 a fast path from prototype to deployable edge AI workloads.