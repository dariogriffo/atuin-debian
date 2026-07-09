atuin_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$atuin_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <atuin_version> <build_version> [architecture]"
    echo "Example: $0 18.17.0 1 arm64"
    echo "Example: $0 18.17.0 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

# Function to map Ubuntu architecture to atuin release name
get_atuin_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "atuin-x86_64-unknown-linux-musl"
            ;;
        "arm64")
            echo "atuin-aarch64-unknown-linux-musl"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to build for a specific architecture
build_architecture() {
    local build_arch=$1
    local atuin_release

    atuin_release=$(get_atuin_release "$build_arch")
    if [ -z "$atuin_release" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64"
        return 1
    fi

    echo "Building for architecture: $build_arch using $atuin_release"

    # Clean up any previous builds for this architecture
    rm -rf "$atuin_release" || true
    rm -f "${atuin_release}.tar.gz" || true

    # Download and extract atuin binary for this architecture
    if ! wget "https://github.com/atuinsh/atuin/releases/download/v${atuin_VERSION}/${atuin_release}.tar.gz"; then
        echo "❌ Failed to download atuin binary for $build_arch"
        return 1
    fi

    if ! tar -xf "${atuin_release}.tar.gz"; then
        echo "❌ Failed to extract atuin binary for $build_arch"
        return 1
    fi

    rm -f "${atuin_release}.tar.gz"

    # Build packages for appropriate Ubuntu distributions
    declare -a arr=("jammy" "noble" "questing" "resolute")

    for dist in "${arr[@]}"; do
        FULL_VERSION="$atuin_VERSION-${BUILD_VERSION}~${dist}_${build_arch}_ubu"
        echo "  Building $FULL_VERSION"

        if ! docker build . -f Dockerfile.ubu -t "atuin-ubuntu-$dist-$build_arch" \
            --build-arg UBUNTU_DIST="$dist" \
            --build-arg atuin_VERSION="$atuin_VERSION" \
            --build-arg BUILD_VERSION="$BUILD_VERSION" \
            --build-arg FULL_VERSION="$FULL_VERSION" \
            --build-arg ARCH="$build_arch" \
            --build-arg ATUIN_RELEASE="$atuin_release"; then
            echo "❌ Failed to build Docker image for $dist on $build_arch"
            return 1
        fi

        id="$(docker create "atuin-ubuntu-$dist-$build_arch")"
        if ! docker cp "$id:/atuin_$FULL_VERSION.deb" - > "./atuin_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb package for $dist on $build_arch"
            return 1
        fi

        if ! tar -xf "./atuin_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb contents for $dist on $build_arch"
            return 1
        fi
    done

    # Clean up extracted directory
    rm -rf "$atuin_release" || true

    echo "✅ Successfully built for $build_arch"
    return 0
}

# Main build logic
if [ "$ARCH" = "all" ]; then
    echo "🚀 Building atuin $atuin_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""

    # All supported architectures
    ARCHITECTURES=("amd64" "arm64")

    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="

        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi

        echo ""
    done

    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la atuin_*.deb
else
    # Build for single architecture
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi
