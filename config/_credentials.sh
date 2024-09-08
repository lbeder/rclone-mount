#!/usr/bin/env -S bash -e

unset HISTFILE

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC1091
source "$script_dir/_platform.sh"

PROC="$$"

fatal() {
    echo -e "\\n$*\\n" >&2

    kill -s TERM $PROC
    exit 1
}

export CONFIG_DIR=~/.config/backup
export RCLONE_CONFIG="$CONFIG_DIR/rclone.conf"

get_profile() {
    echo "$BACKUP_PROFILE"
}

get_profile_dir() {
    echo "$CONFIG_DIR/$(get_profile)"
}

get_profiles() {
    profiles=()

    while IFS= read -r -d '' dir; do
        profiles+=("$(basename "$dir")")
    done < <(find "$(get_profile_dir)" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

list_profiles() {
    local profiles=()
    get_profiles profiles

    if ((${#profiles[@]} != 0)); then
        echo "Existing backup profiles:"

        for profile in "${profiles[@]}"; do
            echo "- $profile"
        done

        echo
    fi
}

get_credentials_path() {
    echo "$(get_profile_dir)/credentials.json"
}

encrypt() {
    local value=$1
    echo "$value" | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:"$BACKUP_MASTER_PASSWORD" -A || fatal
}

decrypt() {
    local value=$1
    echo "$value" | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:"$BACKUP_MASTER_PASSWORD" -A || fatal
}

reset_credentials() {
    local profile_dir=
    profile_dir=$(get_profile_dir)

    if [ -d "$profile_dir" ]; then
        local profile
        profile=$(get_profile)

        echo

        local answer=
        answer=$(input_value "Profile \"$profile\" already exists. Do you want to delete it?" false false true false)
        if $answer; then
            rm -rf "$profile_dir"
        else
            fatal "Aborting"
        fi

        echo
    fi

    mkdir -p "$(get_profile_dir)"
    echo "{}" >"$(get_credentials_path)"
}

verify_credentials() {
    if [ ! -d "$(get_profile_dir)" ]; then
        fatal "profile \"$(get_profile)\" doesn't exist"
    fi

    local credentials_path=
    credentials_path=$(get_credentials_path)

    if [ ! -f "$credentials_path" ]; then
        fatal "$credentials_path file doesn't exist"
    fi
}

set_key() {
    local key=$1
    local value=$2

    verify_credentials

    local credentials_path=
    credentials_path=$(get_credentials_path)

    jq -e -r ".$key = \"$value\"" "$credentials_path" | sponge "$credentials_path" || fatal "Failed parsing credentials"
}

get_key() {
    local key=$1

    verify_credentials

    local credentials_path
    credentials_path=$(get_credentials_path)

    jq -e -r ".$key" "$credentials_path" || fatal "Failed parsing credentials"
}

set_credentials() {
    local key=$1
    local value=$2

    set_key "$key" "$(encrypt "$value")"
}

get_credentials() {
    local key=$1

    decrypt "$(get_key "$key")"
}

set_rclone_credentials() {
    local key=$1
    local value=$2

    set_credentials "$key" "$(echo "$value" | rclone obscure -)"
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

input_credentials() {
    local name=$1
    local key=$2
    local optional=$3
    local boolean=$4
    local prefix=$5

    set_credentials "$key" "$(input_value "$name" "$optional" false "$boolean" "$prefix")"
}

input_profile() {
    if [ -z "$BACKUP_PROFILE" ]; then
        BACKUP_PROFILE="$(input_value "profile name")"
        export BACKUP_PROFILE
    fi
}

select_profile() {
    if [ -z "$BACKUP_PROFILE" ]; then
        local profiles=()
        get_profiles profiles

        local profile_count=${#profiles[@]}

        if ((${#profiles[@]} == 0)); then
            fatal "No backup profiles exist"
        else
            echo "Please select the backup profile to use:"
            echo

            for i in "${!profiles[@]}"; do
                echo "$((i + 1))) ${profiles[$i]}"
            done

            echo

            read -r -p "Profile: " index </dev/tty

            if ((index >= 1)) && ((index <= profile_count)); then
                echo

                local profile=${profiles[$((index - 1))]}
                echo "Selected profile: \"$profile\""
                echo

                BACKUP_PROFILE="$profile"
                export BACKUP_PROFILE
            else
                fatal "Invalid option"
            fi
        fi
    fi

}

input_rclone_credentials() {
    local name=$1
    local key=$2
    local optional=$3
    local boolean=$4
    local prefix=$5

    set_rclone_credentials "$key" "$(input_value "$name" "$optional" false "$boolean" "$prefix")"
}

input_master_password() {
    local verify=${1:-false}

    if [ -z "$BACKUP_MASTER_PASSWORD" ]; then
        local password=
        password="$(input_value "backup master password" false true)"

        echo

        if $verify; then
            local password2
            password2="$(input_value "backup master password again" false true)"

            echo
            echo

            if [ "$password" != "$password2" ]; then
                fatal "Passwords don't match!"
            fi
        fi

        BACKUP_MASTER_PASSWORD=$password
        export BACKUP_MASTER_PASSWORD
    fi
}
