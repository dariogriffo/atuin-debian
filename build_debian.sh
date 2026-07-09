#!/bin/bash
set -euo pipefail

# Upstream Linux architectures for atuin (https://github.com/atuinsh/atuin):
#   amd64  -> atuin-x86_64-unknown-linux-gnu.tar.gz (or -musl variant)
#   arm64  -> atuin-aarch64-unknown-linux-gnu.tar.gz (or -musl variant)
#
# amd64 and arm64 only.
# TODO: implement atuin build

atuin_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$atuin_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <atuin_version> <build_version> [architecture]"
    echo "Example: $0 1.2.3 1 arm64"
    echo "Example: $0 1.2.3 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

echo "build_debian.sh for atuin is not implemented yet."
exit 1
