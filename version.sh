#!/usr/bin/env -S bash -e

export VERSION=0.1

print_version() {
    if ${SKIP_VERSION:-false}; then
        exit 1
    fi

    echo
    echo -e "Rclone Mount v$VERSION"
    echo

    echo "Tools:"

    echo "  * $(rclone version | head -n 1)"

    echo
}
