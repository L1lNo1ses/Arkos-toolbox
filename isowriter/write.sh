#!/bin/sh
# ArkOS img kicsomagolása és írása a fix /dev/mmcblk0 eszközre
# Több fájl esetén a legújabbat használja, a régi .img.xz-eket törli
# Látványosabb progress a dd-hez

TARGET="/dev/mmcblk0"

# Script könyvtárának meghatározása
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Összes .img.xz fájl listázása
FILES=($(ls -1t "$SCRIPT_DIR"/*.img.xz 2>/dev/null))

if [ ${#FILES[@]} -eq 0 ]; then
    echo "Hiba: nem található .img.xz fájl a script könyvtárában!"
    exit 1
fi

# A legújabb fájl kiválasztása
LATEST="${FILES[0]}"
echo "A legújabb fájl kiválasztva: $LATEST"

# Régi fájlok törlése
if [ ${#FILES[@]} -gt 1 ]; then
    echo "Régi fájlok törlése..."
    for f in "${FILES[@]:1}"; do
        echo "Törlés: $f"
        rm -f "$f"
    done
fi

# Kicsomagolás és írás
echo "Kicsomagolás és írás folyamatban a $TARGET eszközre..."
# A pv-vel látványos progress-bar (ha nincs pv, simán dd status=progress)
if command -v pv &> /dev/null; then
    xz -dc "$LATEST" | pv | sudo dd of="$TARGET" bs=4M conv=fsync
else
    xz -dc "$LATEST" | sudo dd of="$TARGET" bs=4M status=progress conv=fsync
fi

# Ellenőrzés
sync
echo "Kész! Az írás befejeződött."
