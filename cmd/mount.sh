#!/usr/bin/env -S bash -e

unset HISTFILE

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/../version.sh"

repo=$1
mountpoint=$2

cleanup() {
    "$script_dir"/umount.sh "$mountpoint" 2>/dev/null || true
}

trap cleanup EXIT ERR SIGINT SIGTERM

mkdir -p "$mountpoint"

echo "Mounting $repo to \"$mountpoint\"..."
echo

rclone mount -v --allow-other "$repo": "$mountpoint" "${@:3}"
