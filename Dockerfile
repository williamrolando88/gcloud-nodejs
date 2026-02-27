# syntax=docker/dockerfile:1

# Build arg for Node.js major version (e.g. 22, 24)
ARG NODE_VERSION=22

FROM google/cloud-sdk:latest

ARG NODE_VERSION

LABEL org.opencontainers.image.title="gcloud-nodejs"
LABEL org.opencontainers.image.description="Google Cloud SDK with Node.js ${NODE_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/williammorales/gcloud-nodejs"

# Install Node.js via NodeSource
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable pnpm via corepack (ships with Node.js 16.10+)
RUN corepack enable && corepack prepare pnpm@latest --activate

# Verify installs
RUN gcloud --version && node --version && npm --version && pnpm --version

CMD ["bash"]
