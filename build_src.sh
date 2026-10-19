#!/bin/bash
set -euo pipefail

atuin_VERSION=$1
BUILD_VERSION=$2

if [ -z "$atuin_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <atuin_version> <build_version>"
    echo "Example: $0 18.17.0 1"
    exit 1
fi

PACKAGE_NAME="atuin"
ORIG_TARBALL="${PACKAGE_NAME}_${atuin_VERSION}.orig.tar.gz"
BUILD_DIR="${PACKAGE_NAME}-${atuin_VERSION}"

echo "Creating the source package for atuin ${atuin_VERSION}-${BUILD_VERSION}..."

# Download upstream source tarball (shared .orig.tar.gz across all distributions)
if [ ! -f "$ORIG_TARBALL" ]; then
    echo "Downloading upstream source from GitHub..."
    wget -q "https://github.com/atuinsh/atuin/archive/refs/tags/v${atuin_VERSION}.tar.gz" -O "$ORIG_TARBALL"
    echo "  ✅ Downloaded $ORIG_TARBALL"
else
    echo "  ✅ Using existing $ORIG_TARBALL"
fi

build_source_package() {
    local FULL_VERSION="${atuin_VERSION}-${BUILD_VERSION}~griffo"

    echo "  Building source package ${FULL_VERSION}..."

    # Clean and recreate build directory from orig tarball
    rm -rf "$BUILD_DIR"
    tar -xf "$ORIG_TARBALL"
    # GitHub archives extract as atuin-18.x.y/ which matches our BUILD_DIR

    # Copy Debian packaging directory
    cp -r debian "$BUILD_DIR/"

    # Generate the changelog (overwrites placeholder)
    cat > "$BUILD_DIR/debian/changelog" << EOF
atuin (${FULL_VERSION}) stable; urgency=medium

  * New upstream release ${atuin_VERSION}.

 -- Dario Griffo <dariogriffo@gmail.com>  $(date -R)
EOF

    # Build source package (.dsc + .debian.tar.xz); reuses existing .orig.tar.gz
    dpkg-source -b "$BUILD_DIR"

    rm -rf "$BUILD_DIR"
    echo "    ✅ ${FULL_VERSION}"
}

echo ""
# One source package for every suite, as with the binaries (see build_debian.sh).
build_source_package

echo ""
echo "🎉 Source packages created successfully!"
echo ""
echo "Generated files:"
ls -la "${PACKAGE_NAME}_"*.dsc "${PACKAGE_NAME}_"*.orig.tar.gz "${PACKAGE_NAME}_"*.debian.tar.xz 2>/dev/null || true
