#!/bin/bash
set -e

SKETCH_DIR="/app/sketch"
APP=${APP:-pingpong}

# Verify if firmware is already flashed
if /opt/openocd/bin/arduino-verify.sh; then
    echo ">>> Firmware already present, skipping flash"
else
    echo ">>> Firmware not present or differs, flashing now..."
    BIN_FILE=$(ls "$SKETCH_DIR"/*.elf-zsk.bin | head -n 1)
    if [ -z "$BIN_FILE" ]; then
        echo "ERROR: No .elf-zsk.bin found"
        exit 1
    fi
    /opt/openocd/bin/arduino-flash.sh "$BIN_FILE"
fi

# Always reset the microcontroller to ensure clean state
echo ">>> Resetting microcontroller..."
/opt/openocd/bin/arduino-reset.sh

echo ">>> Activating virtualenv"
source /opt/venv/bin/activate

echo ">>> Running Python App..."
python /app/webapp-led-mcu.py