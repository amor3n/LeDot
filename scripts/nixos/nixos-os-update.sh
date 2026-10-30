
#!/usr/bin/env bash
set -Eeuo pipefail

# -----------------------------------------------
# Configuration
# -----------------------------------------------
readonly DOTS="${HOME}/LeDot"
readonly NIXOS_CONFIG="${DOTS}/etc/nixos/configuration.nix"
readonly CHANNEL_ALIAS="nixos"
readonly CHANNEL_URL="https://channels.nixos.org/"
readonly REBUILD_CMD="nixos-rebuild"

# -----------------------------------------------
# Logging
# -----------------------------------------------
info()    { printf 'ℹ️  %s\n' "$*"; }
success() { printf '✅ %s\n' "$*"; }
error()   { printf '❌ %s\n' "$*" >&2; }

die() {
    error "$*"
    exit 1
}

# -----------------------------------------------
# Cleanup
# -----------------------------------------------
cleanup() {
    sudo -k
}

trap cleanup EXIT

# -----------------------------------------------
# Dependency checks
# -----------------------------------------------
check_dependencies() {
    local cmd

    for cmd in curl sudo nix-channel "$REBUILD_CMD"; do
        command -v "$cmd" >/dev/null 2>&1 ||
            die "Required command not found: $cmd"
    done

    [[ -f "$NIXOS_CONFIG" ]] ||
        die "NixOS configuration not found: $NIXOS_CONFIG"
}

# -----------------------------------------------
# Authenticate
# -----------------------------------------------
authenticate() {
    info "Please enter your password to continue."

    sudo -v || die "Authentication failed."
    success "Authentication successful."
}

# -----------------------------------------------
# Find latest stable NixOS channel
# -----------------------------------------------
get_latest_channel() {
    local latest

    info "Checking latest NixOS stable release..."

    latest=$(
        curl --fail --silent --show-error \
            "$CHANNEL_URL" |
        grep -oE 'nixos-[0-9]{2}\.[0-9]{2}' |
        sort -Vu |
        tail -n 1
    ) || die "Failed to retrieve NixOS release information."

    [[ -n "$latest" ]] ||
        die "Could not determine the latest stable channel."

    printf '%s' "$latest"
}

# -----------------------------------------------
# Update channel
# -----------------------------------------------
update_channel() {
    local latest="$1"

    info "Switching to $latest..."

    sudo nix-channel --add \
        "https://nixos.org/channels/$latest" \
        "$CHANNEL_ALIAS"

    info "Updating NixOS channel..."
    sudo nix-channel --update

    success "Channel updated: $latest"
}

# -----------------------------------------------
# Rebuild system
# -----------------------------------------------
rebuild_system() {
    info "Rebuilding NixOS system..."

    sudo "$REBUILD_CMD" switch \
        -I "nixos-config=$NIXOS_CONFIG"

    success "NixOS system rebuilt successfully."
}

# -----------------------------------------------
# Main
# -----------------------------------------------
main() {
    printf '\n%s\n' "------------------------------------"
    printf '%s\n\n' "       NixOS System Updater"
    printf '%s\n' "------------------------------------"

    check_dependencies
    authenticate

    local latest
    latest="$(get_latest_channel)"

    success "Latest stable release: $latest"

    update_channel "$latest"
    rebuild_system

    printf '\n%s\n' "------------------------------------"
    success "NixOS update complete!"
    info "Reboot when ready."
    printf '%s\n' "------------------------------------"
}

main "$@"
