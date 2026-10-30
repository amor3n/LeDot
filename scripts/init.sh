
#!/usr/bin/env bash

set -Eeuo pipefail

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────

LEDOTS_DIR="${HOME}/LeDot"
NIXOS_DIR="${LEDOTS_DIR}/etc.nixos"

HW_CONFIG="${NIXOS_DIR}/hardware-configuration.nix"
SYSTEM_CONFIG="${NIXOS_DIR}/configuration.nix"

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

info() {
    printf '\n\033[1;34m%s\033[0m\n' "$1"
}

success() {
    printf '\033[1;32m✓ %s\033[0m\n' "$1"
}

error() {
    printf '\033[1;31m✗ %s\033[0m\n' "$1" >&2
}

# ─────────────────────────────────────────────
# Hardware Configuration
# ─────────────────────────────────────────────

generate_hardware_config() {
    local tmp_file

    tmp_file=$(mktemp "${NIXOS_DIR}/.hardware-configuration.XXXXXX")

    if sudo nixos-generate-config --show-hardware-config > "$tmp_file"; then
        mv -f -- "$tmp_file" "$HW_CONFIG"
        success "Hardware configuration generated."
    else
        rm -f -- "$tmp_file"
        error "Failed to generate hardware configuration."
        return 1
    fi
}

setup_hardware_config() {
    if [[ ! -f "$HW_CONFIG" ]]; then
        info "Generating Hardware Configuration"
        generate_hardware_config
        return
    fi

    info "Hardware configuration already exists:"
    printf '  %s\n\n' "$HW_CONFIG"

    PS3="Select an option: "

    select choice in \
        "Delete and regenerate" \
        "Cancel initialization" \
        "Skip generation"; do

        case "$REPLY" in
            1)
                info "Regenerating Hardware Configuration"
                generate_hardware_config
                break
                ;;
            2)
                error "Initialization cancelled."
                exit 1
                ;;
            3)
                success "Skipping hardware configuration."
                break
                ;;
            *)
                error "Invalid option. Try again."
                ;;
        esac
    done
}

# ─────────────────────────────────────────────
# System Rebuild
# ─────────────────────────────────────────────

rebuild_system() {
    info "Rebuilding Dot Configuration"

    sudo nixos-rebuild switch \
        -I "nixos-config=${SYSTEM_CONFIG}"

    success "NixOS rebuild completed successfully."
}

# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────

main() {
    info "Initializing Dot Configuration"

    [[ -d "$NIXOS_DIR" ]] || {
        error "NixOS configuration directory not found: $NIXOS_DIR"
        exit 1
    }

    [[ -f "$SYSTEM_CONFIG" ]] || {
        error "configuration.nix not found: $SYSTEM_CONFIG"
        exit 1
    }

    setup_hardware_config
    rebuild_system

    printf '\n'
    info "Initialization Complete"

    printf '%s\n' \
        "You can now run:" \
        "" \
        "  nixos-rebuild-switch" \
        "    → Rebuild NixOS using ~/LeDot/etc.nixos" \
        "" \
        "  home-user-switch" \
        "    → Apply your dotfile changes from ~/LeDot/home.user"
}

main "$@"
