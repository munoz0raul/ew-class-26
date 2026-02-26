# Lab 7 — Edge Impulse Model Creation (7-edgeimpulse)

## Goal

Learn how to create and train an AI model using Edge Impulse and prepare it for deployment on an Embedded Linux device.

---

## Why this matters

Moving from proof-of-concept to production AI requires:

- structured data pipelines
- reproducible training workflows
- deployment-ready artifacts

Edge Impulse simplifies embedded ML workflows and bridges data collection,
training, optimization, and deployment.

---

## What you will build

In this lab you will:

- create an Edge Impulse project
- upload and label data
- train a model
- export a deployment-ready model for Embedded Linux.

---

## Steps

# Edge Impulse Workflow

In this lab we introduce AI into the embedded workflow.

You will use Edge Impulse to train a model that will later run locally on the device.

> [!NOTE]
> Follow the screenshots in the assets folder for visual guidance.

## 1. Create a Project

Open Edge Impulse Studio:

https://studio.edgeimpulse.com

Create a new project and select:

- Target: Embedded Linux
- Data type: Audio (voice recognition example)

---

## 2. Upload or Collect Data

Upload sample data or record new samples using the Edge Impulse interface.

Typical workflow:

- create classes (example: ON / OFF)
- upload audio samples
- label each recording appropriately

---

## 3. Create the Impulse

Navigate to:

Impulse Design → Create Impulse

Configure:

- Input block (Audio)
- Processing block
- Learning block (Classification)

---

## 4. Generate Features

Run feature generation:

- click Generate Features
- review feature explorer visualization

---

## 5. Train the Model

Open the training section:

- select model parameters
- start training

Observe:

- accuracy
- confusion matrix
- validation metrics

---

## 6. Test the Model

Use Live Classification or testing dataset to validate performance.

Adjust training parameters if necessary.

---

## 7. Deployment

Go to Deployment tab.

Select:

Embedded Linux (AARCH64)

Download the deployment package (.eim file).

This file will be used in the next labs.

---

## Expected result

You should obtain:

- a trained model
- acceptable accuracy for classification
- a downloadable deployment package (.eim).

---

## Transition to next lab

Next we will run the trained model locally and use voice recognition to control hardware.