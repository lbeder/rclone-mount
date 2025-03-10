#!/usr/bin/env -S bash
set -e

export VERSION=0.2

print_version() {
    if ${SKIP_VERSION:-false}; then
        echo
        echo -e "Rclone Mount v$VERSION"
        echo

        echo "Tools:"

        echo "  * $(rclone version | head -n 1)"

        echo
    fi
}
