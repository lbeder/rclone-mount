#!/usr/bin/env -S bash
set -e

unset HISTFILE

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/../version.sh"

# Get repository and mountpoint from arguments
repo=$1
mountpoint=$2

# Track if cleanup has been called to avoid multiple unmounts
cleanup_called=0

# Cleanup function to unmount on exit
cleanup() {
    if [ "$cleanup_called" -eq 0 ]; then

        # Attempt to unmount and suppress errors
        "$script_dir"/umount.sh "$mountpoint" 2>/dev/null || true

        cleanup_called=1
    fi
}

# Set up cleanup trap for various exit conditions
trap cleanup EXIT ERR SIGINT SIGTERM

# Create mountpoint directory if it doesn't exist
mkdir -p "$mountpoint"

echo "Mounting $repo to \"$mountpoint\"..."
echo

# Mount the repository using rclone (--allow-other enables access for all users)
rclone mount -v --allow-other "$repo" "$mountpoint" "${@:3}"
