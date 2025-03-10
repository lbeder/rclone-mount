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

# Detect the current platform
platform=$(get_platform)

# Handle unmounting based on platform
case $platform in
Android | Linux | WSL)
    fusermount3 -uz "$mountpoint" || true
    ;;

Darwin)
    umount "$mountpoint" || true
    ;;

*)
    fatal "Unsupported platform $platform"
    ;;
esac
