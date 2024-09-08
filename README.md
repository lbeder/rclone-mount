# rclone-mount

## Installation

### Android

Please make sure to install [Termux]((https://termux.dev/en/)) and then run:

```sh
chmod +x ./install.sh

./install.sh
```

Please note that you'd have to copy the suite into [Termux](https://termux.dev/en/)'s data directory (e.g., the main user's `$HOME`), since most of other partitions aren't marked as `executable`.

### Mac OS

Please make sure to install [Homebrew](https://brew.sh/) and then run:

```sh
chmod +x ./install.sh

./install.sh
```

### Linux

Please run:

```sh
chmod +x ./install.sh

./install.sh
```

### Windows (via Windows Subsystem for Linux)

First of all, make sure to install the [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) via PowerShell:

```powershell
wsl --install
```

List all available Linux distributions and install an Ubuntu/Debian distribution. For example:

```powershell
wsl --list --online

wsl --install Ubuntu-22.04
```

Reboot you machine and reopen the terminal and run `wsl`:

```powershell
wsl
```

Please run:

```sh
chmod +x ./install.sh

./install.sh
```

Please note that you can access or specify Windows files via the `/mnt` prefix. For example, to backup the `C:\Users\user\Desktop\Mount` folder, you'd need to specify it as `/mnt/c/Users/user/Desktop/Mount`

## Upgrade

Please use the `upgrade.sh` to upgrade existing tools and dependencies:

```sh
./upgrade.sh
```

In certain instances, the initially installed version of [Rclone](https://rclone.org/) may be outdated and lack the `selfupdate` feature. In such cases, you should first upgrade or reinstall it by following the  [Rclone Installation Instructions](https://rclone.org/install/)/.

Remember to run `fix-scripts.sh` whenever you add new scripts which sets them as executable and also fixes shebangs (using [termux-fix-shebang](https://wiki.termux.com/wiki/Termux-fix-shebang)) such that they can be executed externally (e.g., via Tasker).

## Mounting

To mount a repository, you can use the `cmd/mount.sh` script and specifying the mountpoint:

```sh
sudo -E ./cmd/mount.sh [REPO] [MOUNTPOINT]
```

Please keep in mind that you will require a root permission to access the mountpoint.

Please note that you'd need to install:

* Termux:
  * `pkg install root-repo`
  * `pkg install libfuse3`
* Android: Install [FUSE](https://github.com/agnostic-apollo/fuse/blob/master/README.md#install-instructions-for-termux-on-android)
* Mac OS: Install [macFUSE](https://osxfuse.github.io/)
* Linux: Install [FUSE](https://github.com/AppImage/AppImageKit/wiki/FUSE)

## Unmounting

Even though the repository will be unmounted automatically, you can also manually unmount a repository using `cmd/umount.sh` script and specifying the mountpoint:

```sh
./cmd/umount.sh [MOUNTPOINT]
```

TODO: fix-scripts is only for Tasker
