#!/usr/bin/env -S bash
set -e

unset HISTFILE

PROC="$$"

fatal() {
    echo -e "\\n$*\\n" >&2

    kill -s TERM $PROC
    exit 1
}

input_value() {
    local name=$1
    local optional=${2:-false}
    local password=${3:-false}
    local boolean=${4:-false}
    local prefix=${5:-true}

    local desc=
    if $prefix; then
        desc="Enter the "
    fi

    desc="$desc$name"

    if $optional; then
        desc="$desc (optional)"
    fi

    local value
    if $boolean; then
        until [ -n "$value" ]; do
            read -r -p "$desc (y/n): " value </dev/tty

            case $value in
            [yY]*)
                value=true

                break

                ;;
            [nN]*)
                value=false

                break

                ;;
            *)
                value=""

                ;;
            esac
        done
    else
        if $password; then
            read -s -r -p "$desc: " value </dev/tty
        else
            read -r -p "$desc: " value </dev/tty
        fi
    fi

    # Check if the variable is either not empty or optional
    if [[ -z $value ]] && ! $optional; then
        fatal "$name can't be empty"
    fi

    echo "$value"
}
