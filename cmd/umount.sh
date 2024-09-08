#!/usr/bin/env -S bash -e

unset HISTFILE

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/version.sh"

# shellcheck disable=SC1091
source "$script_dir/config/_platform.sh"

echo "Umounting \"$mountpoint\"..."
echo

mountpoint=$1

platform=$(get_platform)

case $platform in
Android)
    fusermount -uz "$mountpoint"

    ;;
Darwin)
    umount "$mountpoint"

    ;;
Linux)
    fusermount -uz "$mountpoint"

    ;;
WSL)
    fusermount -uz "$mountpoint"

    ;;
*)
    fatal "Unsupported platform $platform"

    ;;
esac
