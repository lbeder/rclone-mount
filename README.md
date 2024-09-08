# rclone-mount

## Overview

This project is a versatile backup solution that combines the power of [Restic](https://restic.net/) and [Rclone](https://rclone.org/) to safeguard your data on Android, Linux, Mac OS, or Windows (via Windows Subsystem for Linux)  (via [Termux](https://termux.dev/en/)) systems.

## Mounting

To mount the recent snapshot of your data, you can use the `cmd/mount.sh` script and specifying the mountpoint:

```sh
sudo -E ./cmd/mount.sh [MOUNTPOINT]
```

Please keep in mind that you will require a root permission to access the mountpoint.

Please note that you'd need to install:

* Termux:
  * `pkg install root-repo`
  * `pkg install libfuse3`
* Android: Install [FUSE](https://github.com/agnostic-apollo/fuse/blob/master/README.md#install-instructions-for-termux-on-android)
* Mac OS: Install [macFUSE](https://osxfuse.github.io/)
* Linux: Install [FUSE](https://github.com/AppImage/AppImageKit/wiki/FUSE)
