#!/usr/bin/env -S bash
set -e

unset HISTFILE

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/../version.sh"

# shellcheck disable=SC1091
source "$script_dir/../config/_platform.sh"

# Get mountpoint from first argument
mountpoint=$1

echo "Umounting \"$mountpoint\"..."
echo

# Detect current platform
platform=$(get_platform)

# Handle unmounting based on platform
case $platform in
Android)
    fusermount3 -uz "$mountpoint" 2>/dev/null || true

    ;;
Darwin)
    umount "$mountpoint" 2>/dev/null || true

    ;;
Linux)
    fusermount3 -uz "$mountpoint" 2>/dev/null || true

    ;;
WSL)
    fusermount3 -uz "$mountpoint" 2>/dev/null || true

    ;;
*)
    fatal "Unsupported platform $platform"

    ;;
esac
