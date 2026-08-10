FROM ghcr.io/containerpak/wine:main

ARG DEBIAN_FRONTEND=noninteractive
ARG UMU_VERSION=1.4.4

RUN apt update && apt install -y --no-install-recommends \
    bzip2 curl gzip python3 tar xz-utils zstd && \
    mkdir -p /usr/local/share/licenses/umu-launcher && \
    mkdir -p /tmp/umu && \
    curl -fsSL "https://github.com/Open-Wine-Components/umu-launcher/releases/download/${UMU_VERSION}/umu-launcher-${UMU_VERSION}-zipapp.tar" \
    | tar -x --strip-components=1 -C /tmp/umu && \
    install -Dm755 /tmp/umu/umu-run /usr/local/bin/umu-run && \
    curl -fsSL "https://raw.githubusercontent.com/Open-Wine-Components/umu-launcher/cf3d1b107147480c447ffbfb3f789dc74335074c/LICENSE" \
    -o /usr/local/share/licenses/umu-launcher/LICENSE && \
    rm -rf /tmp/umu && \
    cpak-clean-junk

ENV PATH="/usr/local/bin:/app/bin:/usr/bin:/bin"

ENTRYPOINT ["/usr/local/bin/umu-run"]
