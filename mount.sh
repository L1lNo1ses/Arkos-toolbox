#!/bin/sh

SD_BASE="/mnt/arkos"
#mountoljuk a partíciókat
declare -A SD_MOUNTS=(
	["boot/"]="/dev/mmcblk0p1"
	["system/"]="/dev/mmcblk0p2"
	["easyroms/"]="/dev/mmcblk0p3"
)
#alap mappa létrehozás
sudo mkdir -p "$SD_BASE"

for NAME in "${!SD_MOUNTS[@]}"; do
	PART="${SD_MOUNTS[$NAME]}"
	MOUNTPOINT="$SD_BASE/$NAME"
	sudo mkdir -p "$MOUNTPOINT"
	echo "sdkártya felcsatolás: $PART -> $MOUNTPOINT"
	sudo mount "$PART" "$MOUNTPOINT" ||echo "hiba nem sikerült felcsatolni $PART"
done
	echo "kész a csatolás"
