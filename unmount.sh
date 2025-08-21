#!/bin/sh

# Alapértelmezett csatolási pont alap
SDBASE="/mnt/arkos"

# Csatolási pontok listája (fordított sorrend)
SD_PARTS=("easyroms" "system" "boot")

# Minden csatolási pont külön lecsatolása
for part in "${SD_PARTS[@]}"; do
    MOUNTPOINT="$SDBASE/$part"

    # Ellenőrizzük, hogy a csatolási pont létezik-e
    if [ -d "$MOUNTPOINT" ]; then
        echo "Ellenőrzés: $MOUNTPOINT"
        # Ellenőrizzük, hogy fel van-e csatolva
        if mountpoint -q "$MOUNTPOINT"; then
            echo "Lecsatolás megkezdése: $MOUNTPOINT"
            if sudo umount "$MOUNTPOINT" 2>/dev/null; then
                echo "$MOUNTPOINT sikeresen lecsatolva"
            else
                echo "Hiba: $MOUNTPOINT lecsatolása sikertelen. Ellenőrizd a függőségeket!"
            fi
        else
            echo "$MOUNTPOINT nincs felcsatolva"
        fi
    else
        echo "Hiba: $MOUNTPOINT nem létezik a fájlrendszeren!"
    fi
done

echo "Kész a lecsatolás"
