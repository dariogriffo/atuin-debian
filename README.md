![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/atuin-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/atuin-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/atuin-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/atuin-debian?display_date=published_at)

# atuin for Debian

This repository contains build scripts to produce the _unofficial_ Debian packages
(.deb) for [atuin](https://github.com/atuinsh/atuin) hosted at [debian.griffo.io](https://debian.griffo.io)

<p align="center">
⭐⭐⭐ Love using atuin on Debian? Show your support by starring this repo or buying me a coffee! ⭐⭐⭐
</p>

Currently supported Debian distros are:
- Bookworm (v12)
- Trixie (v13)
- Forky (v14)
- Sid (testing)

**Upstream architectures:** amd64 and arm64 only.

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the atuin source code, see
[atuin](https://github.com/atuinsh/atuin).

## Install/Update

📖 **Step-by-step install guide:** [Debian](https://debian.griffo.io/install-latest-atuin-in-debian.html) · [Ubuntu](https://debian.griffo.io/install-latest-atuin-in-ubuntu.html)

### The Debian way

```sh
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
sudo apt update
sudo apt install -y atuin
```

### Manual Installation

1. Download the .deb package for your Debian version available on
   the [Releases](https://github.com/dariogriffo/atuin-debian/releases) page.
2. Install the downloaded .deb package.

```sh
sudo dpkg -i <filename>.deb
```
## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Building

### Build for single architecture
```sh
./build.sh <atuin_version> <build_version> <architecture>
# Example: ./build.sh 1.2.3 1 arm64
```

### Build for all architectures
```sh
./build.sh <atuin_version> <build_version> all
# Example: ./build.sh 1.2.3 1 all
```

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [x] Set up a debian mirror for easier updates
- [x] Multi-architecture support (amd64, arm64)

## Disclaimer

- This repo is not open for issues related to atuin. This repo is only for _unofficial_ Debian packaging.
