#!/usr/bin/env -S bash
set -e

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/version.sh"

# shellcheck disable=SC1091
source "$script_dir/config/_platform.sh"

platform=$(get_platform)

# Get platform name for display
platform_name=$(get_platform_name)

echo "Updating dependencies for $platform_name..."
echo

case $platform in
Android)
    pkg update
    pkg upgrade tsu rclone libfuse3
    ;;

Darwin)
    brew update
    brew upgrade rclone libfuse
    ;;

Linux | WSL)
    sudo apt update
    sudo apt upgrade rclone libfuse3
    ;;

*)
    fatal "Unsupported platform $platform"
    ;;
esac

rclone selfupdate

print_version
