#!/bin/bash
# =============================================================================
# Mode Switching Script
# =============================================================================
# Switch between quick (development) and full (production) configurations
# without modifying tracked files.
#
# Usage:
#   ./local_config/setup.sh           # Default: quick mode
#   ./local_config/setup.sh --quick   # Switch to quick mode
#   ./local_config/setup.sh --full    # Switch to full mode
#   ./local_config/setup.sh --status  # Show current mode
#   ./local_config/setup.sh --restore # Restore original configs
#
# What this does:
#   1. Backs up original config files to .config_backup/
#   2. Creates symlinks from project root to local_config/<mode>/ versions
#   3. Tracks current mode in .current_mode file
#
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_ROOT/.config_backup"
MODE_FILE="$PROJECT_ROOT/.current_mode"

# Config files to manage (add your project's config files here)
CONFIG_FILES=(
    "config/settings.yml"
    "targets_setup.R"
    # Add more config files as needed
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_status() {
    echo "=== Configuration Status ==="
    if [ -f "$MODE_FILE" ]; then
        current_mode=$(cat "$MODE_FILE")
        echo "Current mode: $current_mode"
    else
        echo "Current mode: not set (using original configs)"
    fi
    echo ""
    echo "Config files:"
    for config in "${CONFIG_FILES[@]}"; do
        config_path="$PROJECT_ROOT/$config"
        if [ -L "$config_path" ]; then
            target=$(readlink "$config_path")
            echo "  $config -> $target (symlink)"
        elif [ -f "$config_path" ]; then
            echo "  $config (original)"
        else
            echo "  $config (missing)"
        fi
    done
}

backup_originals() {
    mkdir -p "$BACKUP_DIR"
    for config in "${CONFIG_FILES[@]}"; do
        config_path="$PROJECT_ROOT/$config"
        backup_path="$BACKUP_DIR/$config"

        # Create backup directory structure
        mkdir -p "$(dirname "$backup_path")"

        # Only backup if original exists and isn't already a symlink
        if [ -f "$config_path" ] && [ ! -L "$config_path" ]; then
            if [ ! -f "$backup_path" ]; then
                cp "$config_path" "$backup_path"
                print_status "Backed up $config"
            fi
        fi
    done
}

restore_originals() {
    for config in "${CONFIG_FILES[@]}"; do
        config_path="$PROJECT_ROOT/$config"
        backup_path="$BACKUP_DIR/$config"

        # Remove symlink if exists
        if [ -L "$config_path" ]; then
            rm "$config_path"
        fi

        # Restore from backup if exists
        if [ -f "$backup_path" ]; then
            cp "$backup_path" "$config_path"
            print_status "Restored $config from backup"
        fi
    done

    rm -f "$MODE_FILE"
    print_status "Restored original configurations"
}

switch_mode() {
    local mode=$1
    local mode_dir="$SCRIPT_DIR/$mode"

    if [ ! -d "$mode_dir" ]; then
        print_error "Mode directory not found: $mode_dir"
        echo "Available modes:"
        ls -d "$SCRIPT_DIR"/*/ 2>/dev/null | xargs -n1 basename | grep -v "^_"
        exit 1
    fi

    # Backup originals first
    backup_originals

    # Create symlinks
    for config in "${CONFIG_FILES[@]}"; do
        config_path="$PROJECT_ROOT/$config"
        mode_config="$mode_dir/$config"

        # Remove existing file/symlink
        if [ -e "$config_path" ] || [ -L "$config_path" ]; then
            rm "$config_path"
        fi

        # Create parent directory if needed
        mkdir -p "$(dirname "$config_path")"

        # Create symlink if mode config exists
        if [ -f "$mode_config" ]; then
            ln -s "$mode_config" "$config_path"
            print_status "Linked $config -> $mode/$config"
        else
            # Fall back to backup/original
            if [ -f "$BACKUP_DIR/$config" ]; then
                cp "$BACKUP_DIR/$config" "$config_path"
                print_warning "$config not in $mode mode, using original"
            fi
        fi
    done

    # Record current mode
    echo "$mode" > "$MODE_FILE"
    print_status "Switched to $mode mode"
}

# =============================================================================
# Main
# =============================================================================

case "${1:-quick}" in
    --status|-s)
        show_status
        ;;
    --restore|-r)
        restore_originals
        ;;
    --quick|-q|quick)
        switch_mode "quick"
        ;;
    --full|-f|full)
        switch_mode "full"
        ;;
    --help|-h)
        echo "Usage: $0 [--quick|--full|--status|--restore]"
        echo ""
        echo "Options:"
        echo "  --quick, -q    Switch to quick (development) mode"
        echo "  --full, -f     Switch to full (production) mode"
        echo "  --status, -s   Show current configuration status"
        echo "  --restore, -r  Restore original configurations"
        echo "  --help, -h     Show this help message"
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
