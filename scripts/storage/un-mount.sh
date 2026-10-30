
#!/usr/bin/env bash

set -Eeuo pipefail

# ---- Configuration ----
MOUNT_BASE="/mnt"

# ---- Helpers ----
die() {
    printf '❌ %s\n' "$1" >&2
    exit 1
}

# ---- Header ----
printf '\n==============================\n'
printf '       Disk Unmounter\n'
printf '==============================\n\n'

# ---- STEP 1: Find mounted directories under /mnt ----
mapfile -t MOUNTED < <(
    findmnt -rn -o TARGET |
        awk -v base="$MOUNT_BASE" '
            index($0, base "/") == 1 { print }
        '
)

((${#MOUNTED[@]})) || die "No mounted directories found under $MOUNT_BASE."

# ---- STEP 2: Select mount point ----
echo "Select a mount to unmount:"
PS3="Choose a mount: "

select MOUNT_POINT in "${MOUNTED[@]}"; do
    if [[ -n "${MOUNT_POINT:-}" ]]; then
        break
    fi

    echo "Invalid selection. Try again."
done

printf '\nSelected: %s\n\n' "$MOUNT_POINT"

# ---- STEP 3: Verify mount ----
findmnt -rn --target "$MOUNT_POINT" >/dev/null ||
    die "Mount point is no longer mounted."

# ---- STEP 4: Unmount ----
printf 'Unmounting %s...\n' "$MOUNT_POINT"

sudo umount -- "$MOUNT_POINT" ||
    die "Failed to unmount $MOUNT_POINT. Check whether files are in use."

# ---- STEP 5: Remove mount directory ----
if [[ -d "$MOUNT_POINT" ]]; then
    if sudo rmdir -- "$MOUNT_POINT"; then
        echo "✅ Mount directory removed."
    else
        echo "⚠️ Unmounted successfully, but directory could not be removed."
    fi
fi

# ---- STEP 6: Confirmation ----
printf '\n✅ Successfully unmounted!\n'
printf 'Mount point: %s\n' "$MOUNT_POINT"
