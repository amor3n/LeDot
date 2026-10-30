
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
printf '         Disk Mounter\n'
printf '==============================\n\n'

# ---- STEP 1: Select disk ----
mapfile -t DISKS < <(
    lsblk -dnpo NAME,SIZE,TYPE |
        awk '$3 == "disk" { printf "%s | %s\n", $1, $2 }'
)

((${#DISKS[@]})) || die "No disks found."

echo "Select a disk:"
PS3="Choose a disk: "

select DISK_ENTRY in "${DISKS[@]}"; do
    if [[ -n "${DISK_ENTRY:-}" ]]; then
        DISK="${DISK_ENTRY%% | *}"
        break
    fi

    echo "Invalid selection. Try again."
done

printf '\nSelected disk: %s\n\n' "$DISK"

# ---- STEP 2: Select partition ----
mapfile -t PARTS < <(
    lsblk -lnpo NAME,SIZE,TYPE "$DISK" |
        awk '$3 == "part" { printf "%s | %s\n", $1, $2 }'
)

((${#PARTS[@]})) || die "No partitions found on $DISK."

echo "Select a partition:"
PS3="Choose a partition: "

select PART_ENTRY in "${PARTS[@]}"; do
    if [[ -n "${PART_ENTRY:-}" ]]; then
        PARTITION="${PART_ENTRY%% | *}"
        break
    fi

    echo "Invalid selection. Try again."
done

printf '\nSelected partition: %s\n\n' "$PARTITION"

# ---- STEP 3: Validate partition ----
[[ -b "$PARTITION" ]] || die "Partition $PARTITION is not connected."

echo "✅ Partition is connected."

# ---- STEP 4: Detect filesystem ----
FS_TYPE=$(lsblk -no FSTYPE "$PARTITION" | xargs)

if [[ -z "$FS_TYPE" ]]; then
    die "Could not detect filesystem type. Aborting to avoid an incorrect mount."
fi

printf 'Detected filesystem: %s\n\n' "$FS_TYPE"

# ---- STEP 5: Check existing mount ----
if findmnt -rn -S "$PARTITION" >/dev/null; then
    CURRENT_MOUNT=$(findmnt -rn -S "$PARTITION" -o TARGET | head -n 1)
    printf '⚠️ Already mounted at: %s\n' "$CURRENT_MOUNT"
    exit 0
fi

# ---- STEP 6: Create mount point ----
MOUNT_POINT="$MOUNT_BASE/$(basename "$PARTITION")"

sudo mkdir -p -- "$MOUNT_POINT"

# ---- STEP 7: Mount partition ----
printf 'Mounting %s...\n' "$PARTITION"

sudo mount -t "$FS_TYPE" -- "$PARTITION" "$MOUNT_POINT" ||
    die "Failed to mount $PARTITION."

# ---- STEP 8: Confirm ----
printf '\n✅ Mounted successfully!\n'
printf 'Device:      %s\n' "$PARTITION"
printf 'Filesystem:  %s\n' "$FS_TYPE"
printf 'Mount point: %s\n' "$MOUNT_POINT"
