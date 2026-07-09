ARG DEBIAN_DIST=bookworm
FROM debian:bookworm

ARG DEBIAN_DIST
ARG atuin_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION
ARG ARCH
ARG ATUIN_RELEASE

RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/atuin
RUN mkdir -p /output/DEBIAN

COPY ${ATUIN_RELEASE}/atuin /output/usr/bin/
COPY output/DEBIAN/control /output/DEBIAN/
COPY output/copyright /output/usr/share/doc/atuin/
COPY output/changelog.Debian /output/usr/share/doc/atuin/
COPY output/README.md /output/usr/share/doc/atuin/

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/atuin/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/atuin/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/atuin_VERSION/$atuin_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control
RUN sed -i "s/SUPPORTED_ARCHITECTURES/$ARCH/" /output/DEBIAN/control

RUN dpkg-deb --build /output /atuin_${FULL_VERSION}.deb
