#!/bin/bash

echo "Gerekli paketleri yüklüyorum..."
pkg update -y && pkg upgrade -y
pkg install x11-repo -y
pkg install wget qemu-system-x86_64 tigervnc xfce4-session -y

# QEMU'yu indirme ve kurma
echo "QEMU dosyalarını indiriyorum..."
QEMU_URL="https://example.com/qemu.tar.xz"
DOWNLOAD_DIR="/storage/emulated/0/qemu"

mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
wget -O qemu.tar.xz $QEMU_URL
tar -xf qemu.tar.xz

EXTRACTED_DIR=$(tar -tf qemu.tar.xz | head -n 1 | cut -d "/" -f1)
cd "$DOWNLOAD_DIR/$EXTRACTED_DIR" || { echo "Hata: QEMU klasörü bulunamadı."; exit 1; }
chmod +x qemu-system-x86_64
mv qemu-system-x86_64 /data/data/com.termux/files/usr/bin/qemu-system-x86_64

echo "QEMU başarıyla kuruldu!"

# VNC Sunucusunu Başlatma
export DISPLAY=:1
echo "VNC sunucusunu başlatıyorum..."
vncserver :1
sleep 2

# XFCE Masaüstü Ortamını Aç
echo "XFCE masaüstünü başlatıyorum..."
xfce4-session &

# Kullanıcıdan ISO dosya yolu al
echo "Lütfen ISO dosyasının tam yolunu girin: "
read iso_path

# Eğer ISO yolu geçerliyse QEMU'yu başlat
if [ -f "$iso_path" ]; then
    echo "QEMU'yu başlatıyorum..."
    qemu-system-x86_64 -cdrom "$iso_path" -boot d -m 2048 -vnc :1
    echo "VNC bağlantısını aç: localhost:5901"
else
    echo "Geçersiz ISO dosyası yolu. Lütfen doğru bir dosya yolu girin."
fi