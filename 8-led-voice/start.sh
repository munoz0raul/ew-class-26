#!/bin/bash
set -e

echo ">>> Activating virtualenv"
source /opt/venv/bin/activate

echo ">>> Running Audio Classifier..."
python /app/led-voice.py