
#!/usr/bin/env bash

set -Eeuo pipefail

# Find mounted directories under /mnt
mapfile -t MOUNTED < <(
    findmnt -rn -o TARGET |
        awk '$0 ~ /^\/mnt\// { print }'
)

# Check if any mounted directories exist
if ((${#MOUNTED[@]} == 0)); then
    echo "No mounted directories found under /mnt."
    exit 0
fi

# Display folder selection menu
echo "Select a mounted folder:"
PS3="Choose a folder: "

select FOLDER in "${MOUNTED[@]}"; do
    if [[ -n "${FOLDER:-}" ]]; then
        break
    fi

    echo "Invalid selection. Try again."
done

# Change directory
if cd -- "$FOLDER"; then
    printf '✅ Changed directory to: %s\n' "$PWD"
else
    printf '❌ Failed to change directory: %s\n' "$FOLDER" >&2
    exit 1
fi
