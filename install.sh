#!/usr/bin/env -S bash
set -e

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/version.sh"

# shellcheck disable=SC1091
source "$script_dir/config/_platform.sh"

SCRIPTS=("./*" "./config/*" "./cmd/*" "./cmd/**/*")

echo "Configuring scripts..."
echo

for scripts in "${SCRIPTS[@]}"; do
    # shellcheck disable=SC2086
    find $scripts -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
done

platform=$(get_platform)

# Install platform-specific dependencies
echo "Installing dependencies for $platform..."
echo

case $platform in
Android)
    # Update package lists and install Android dependencies
    pkg update
    pkg install root-repo
    pkg install tsu rclone libfuse3

    # Optionally set up storage access
    answer=
    answer=$(input_value "Do you want to grant Termux storage access permission?" false false true false)
    if $answer; then
        pkg install termux-am
        termux-setup-storage
    fi

    echo
    ;;

Darwin)
    # Install macOS dependencies via Homebrew
    brew update
    brew install rclone libfuse
    ;;

Linux | WSL)
    # Install Linux dependencies via apt
    sudo apt update
    sudo apt install rclone libfuse3
    ;;

*)
    fatal "Unsupported platform $platform"
    ;;
esac

print_version
