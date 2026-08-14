FROM ubuntu:26.04 AS source

ADD --checksum=sha256:eb590691841f7fad3fc3ad8fd5db4ccb87849fe7948e62b28ece7a4ee48cc851 https://github.com/Open-Wine-Components/umu-launcher/releases/download/1.4.4/umu-launcher-1.4.4-zipapp.tar /tmp/umu.tar
ADD --checksum=sha256:3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986 https://raw.githubusercontent.com/Open-Wine-Components/umu-launcher/cf3d1b107147480c447ffbfb3f789dc74335074c/LICENSE /tmp/LICENSE

RUN mkdir -p /out && \
    tar -xf /tmp/umu.tar --strip-components=1 -C /out

FROM ghcr.io/containerpak/wine:main

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=source /out/umu-run /usr/local/bin/umu-run
COPY --from=source /tmp/LICENSE /usr/local/share/licenses/umu-launcher/LICENSE

RUN apt update && apt install -y --no-install-recommends \
    bzip2 curl gzip python3 tar xz-utils zstd && \
    chmod 0755 /usr/local/bin/umu-run && \
    cpak-clean-junk

ENV PATH="/usr/local/bin:/usr/bin:/bin"

ENTRYPOINT ["/usr/local/bin/umu-run"]
