#!/usr/bin/env -S bash -e

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/config/_platform.sh"

CONFIG_DIR=~/.config/backup
SCRIPTS=("./*" "./config/*" "./cmd/*" "./cmd/**/*" "./templates/*" "$CONFIG_DIR/*/hooks")

echo "Configuring scripts..."
echo

for scripts in "${SCRIPTS[@]}"; do
    # shellcheck disable=SC2086
    find $scripts -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true
done

platform=$(get_platform)

case $platform in
Android)
    # Fix termux shebangs such that it'd be possible to execute the scripts from tasker
    for scripts in "${SCRIPTS[@]}"; do
        # shellcheck disable=SC2086
        find $scripts -type f -name "*.sh" -exec termux-fix-shebang {} + 2>/dev/null || true
    done

    ;;
Darwin) ;;
Linux) ;;
WSL) ;;
*)
    fatal "Unsupported platform $platform"

    ;;
esac
