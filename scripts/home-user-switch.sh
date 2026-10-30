
#!/usr/bin/env bash

set -Eeuo pipefail

# ==================================================
# Configuration
# ==================================================

LEDOTS_DIR="${HOME}/LeDot"
LEDOTS_HOME_DIR="${LEDOTS_DIR}/home.user"
LEDOTS_CONFIG_DIR="${LEDOTS_HOME_DIR}/.config"

TARGET_HOME="${HOME}"
TARGET_CONFIG="${HOME}/.config"

MODE="interactive"

# ==================================================
# Logging
# ==================================================

log() {
    printf '%s\n' "$*"
}

info() {
    log "ℹ️  $*"
}

success() {
    log "✅ $*"
}

warning() {
    log "⚠️  $*"
}

error() {
    log "❌ $*" >&2
}

# ==================================================
# Error Handling
# ==================================================

cleanup() {
    sudo -k 2>/dev/null || true
}

on_error() {
    local exit_code=$?
    error "An unexpected error occurred (line ${BASH_LINENO[0]})."
    exit "$exit_code"
}

trap cleanup EXIT
trap on_error ERR

# ==================================================
# Usage
# ==================================================

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTION]

Options:
  --skip-all-existing   Skip existing files and directories.
  --replace-all         Replace existing files and directories.
  -h, --help            Display this help message.

Without an option, interactive mode is enabled.
EOF
}

# ==================================================
# Argument Parsing
# ==================================================

parse_args() {
    if (( $# > 1 )); then
        error "Too many arguments."
        usage
        exit 1
    fi

    case "${1:-}" in
        --skip-all-existing)
            MODE="skip"
            ;;
        --replace-all)
            MODE="replace"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        "")
            MODE="interactive"
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
}

# ==================================================
# Requirements
# ==================================================

check_requirements() {
    [[ -d "$LEDOTS_HOME_DIR" ]] || {
        error "Dotfiles directory not found: $LEDOTS_HOME_DIR"
        exit 1
    }

    command -v sudo >/dev/null 2>&1 || {
        error "sudo is required but not installed."
        exit 1
    }

    info "Please authenticate to continue."

    if ! sudo -v; then
        error "Authentication failed."
        exit 1
    fi
}

# ==================================================
# Symlink Management
# ==================================================

is_correct_link() {
    local source="$1"
    local target="$2"

    [[ -L "$target" ]] || return 1

    [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]
}

create_symlink() {
    local source="$1"
    local target="$2"
    local name
    local choice

    name="$(basename "$source")"

    # Skip correctly configured symlinks.
    if is_correct_link "$source" "$target"; then
        success "$target is already linked correctly."
        return 0
    fi

    # Handle existing targets.
    if [[ -e "$target" || -L "$target" ]]; then
        case "$MODE" in
            skip)
                info "Skipping existing target: $target"
                return 0
                ;;

            replace)
                warning "Replacing: $target"
                ;;

            interactive)
                warning "$name already exists:"
                log "  $target"
                log ""
                log "[1] Delete and replace"
                log "[2] Skip"
                log ""

                if [[ ! -t 0 ]]; then
                    error "Interactive mode requires a terminal."
                    return 1
                fi

                read -rp "Choose an option [1/2]: " choice

                case "$choice" in
                    1)
                        ;;
                    2)
                        info "Skipping: $target"
                        return 0
                        ;;
                    *)
                        error "Invalid option. Aborting."
                        return 1
                        ;;
                esac
                ;;
        esac

        rm -rfv -- "$target"
    fi

    # Create parent directory if necessary.
    mkdir -p -- "$(dirname "$target")"

    # Create symlink.
    ln -s -- "$source" "$target"

    success "Linked: $source → $target"
}

# ==================================================
# Directory Synchronization
# ==================================================

sync_directory() (
    local source_dir="$1"
    local target_dir="$2"
    local excluded="${3:-}"
    local item
    local name

    [[ -d "$source_dir" ]] || {
        warning "Directory does not exist: $source_dir"
        return 0
    }

    mkdir -p -- "$target_dir"

    info "Synchronizing: $source_dir"
    log ""

    # Include hidden files, excluding . and ..
    shopt -s nullglob dotglob

    for item in "$source_dir"/*; do
        name="$(basename "$item")"

        # Skip excluded entries.
        [[ "$name" == "$excluded" ]] && continue

        create_symlink "$item" "$target_dir/$name"
    done

    log ""
)

# ==================================================
# Main
# ==================================================

main() {
    parse_args "$@"

    check_requirements

    log ""
    log "======================================"
    log "🔗 Applying Home Configurations"
    log "======================================"
    log ""

    # Synchronize home directory.
    # Includes hidden files such as .zshrc.
    # .config is handled separately.
    sync_directory "$LEDOTS_HOME_DIR" "$TARGET_HOME" ".config"

    # Synchronize ~/.config.
    # Also includes hidden files and directories.
    sync_directory "$LEDOTS_CONFIG_DIR" "$TARGET_CONFIG"

    log ""
    log "======================================"
    success "Dotfiles synchronization complete."
    log "======================================"
    log ""
}

main "$@"
