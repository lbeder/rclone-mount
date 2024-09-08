#!/usr/bin/env -S bash -e

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/version.sh"
SCRIPTS=("./*" "./cmd/*" "./cmd/**/*")

echo "Configuring scripts..."
echo

for scripts in "${SCRIPTS[@]}"; do
    # shellcheck disable=SC2086
    find $scripts -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
done

platform=$(get_platform)

case $platform in
Android)
    echo "Installing dependencies for Android..."
    echo

    pkg update
    pkg install root-repo
    pkg install tsu rclone libfuse3

    answer=
    answer=$(input_value "Do you want to grant Termux storage access permission?" false false true false)
    if $answer; then
        pkg install termux-am
        termux-setup-storage
    fi

    echo

    ;;
Darwin)
    echo "Installing dependencies for Mac OS..."
    echo

    brew update
    brew install rclone libfuse

    ;;
Linux)
    echo "Installing dependencies for Linux..."
    echo

    sudo apt update
    sudo apt install rclone libfuse3

    ;;
WSL)
    echo "Installing dependencies for WSL..."
    echo

    sudo apt update
    sudo apt install rclone libfuse3

    ;;
*)
    fatal "Unsupported platform $platform"

    ;;
esac

print_version
