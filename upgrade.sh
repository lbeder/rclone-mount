#!/usr/bin/env -S bash -e

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/version.sh"

# shellcheck disable=SC1091
source "$script_dir/config/_platform.sh"

platform=$(get_platform)

case $platform in
Android)
    echo "Updating dependencies for Android..."
    echo

    pkg update
    pkg upgrade tsu rclone libfuse3

    ;;
Darwin)
    echo "Updating dependencies for Mac OS..."
    echo

    brew update
    brew upgrade rclone libfuse

    ;;
Linux)
    echo "Updating dependencies for Linux..."
    echo

    sudo apt update
    sudo apt upgrade rclone libfuse3

    ;;
WSL)
    echo "Updating dependencies for WSL..."
    echo

    sudo apt update
    sudo apt upgrade rclone libfuse3

    ;;
*)
    fatal "Unsupported platform $platform"

    ;;
esac

restic self-update
rclone selfupdate

print_version
