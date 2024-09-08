#!/usr/bin/env -S bash -e

unset HISTFILE

get_platform() {
    local platform=
    platform=$(uname -s)

    if [ "$platform" == "Linux" ]; then
        if [ -f "/system/build.prop" ]; then
            platform="Android"
        elif [ -n "$WSL_DISTRO_NAME" ]; then
            platform="WSL"
        fi
    fi

    echo "$platform"
}
