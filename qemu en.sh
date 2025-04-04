#!/bin/bash

echo "Installing necessary packages..."
pkg update -y && pkg upgrade -y
pkg install x11-repo -y
pkg install wget qemu-system-x86_64 tigervnc xfce4-session -y

# Downloading and installing QEMU
echo "Downloading QEMU files..."
QEMU_URL="https://example.com/qemu.tar.xz"
DOWNLOAD_DIR="/storage/emulated/0/qemu"

mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
wget -O qemu.tar.xz $QEMU_URL
tar -xf qemu.tar.xz

EXTRACTED_DIR=$(tar -tf qemu.tar.xz | head -n 1 | cut -d "/" -f1)
cd "$DOWNLOAD_DIR/$EXTRACTED_DIR" || { echo "Error: QEMU folder not found."; exit 1; }
chmod +x qemu-system-x86_64
mv qemu-system-x86_64 /data/data/com.termux/files/usr/bin/qemu-system-x86_64

echo "QEMU has been successfully installed!"

# Starting the VNC Server
export DISPLAY=:1
echo "Starting VNC server..."
vncserver :1
sleep 2

# Starting the XFCE Desktop Environment
echo "Starting XFCE desktop environment..."
xfce4-session &

# Ask the user for the ISO file path
echo "Please enter the full path of the ISO file: "
read iso_path

# If the ISO path is valid, start QEMU
if [ -f "$iso_path" ]; then
    echo "Starting QEMU..."
    qemu-system-x86_64 -cdrom "$iso_path" -boot d -m 2048 -vnc :1
    echo "Open VNC connection at: localhost:5901"
else
    echo "Invalid ISO file path. Please provide a valid file path."
fi