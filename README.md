# gcloud-nodejs

Docker image combining [Google Cloud SDK](https://cloud.google.com/sdk) with [Node.js](https://nodejs.org), built automatically every week to stay current with the latest `gcloud` releases.

## Available tags

| Tag      | Node.js    | Base                      |
| -------- | ---------- | ------------------------- |
| `node22` | 22 LTS     | `google/cloud-sdk:latest` |
| `node24` | 24 LTS     | `google/cloud-sdk:latest` |

## Usage

```bash
docker pull williamrolando88/gcloud-nodejs:node22
docker pull williamrolando88/gcloud-nodejs:node24
```

### Quick start

```bash
docker run --rm -it williamrolando88/gcloud-nodejs:node22 bash
```

### Example: authenticate and run a Node script

```bash
docker run --rm -it \
  -v "$HOME/.config/gcloud:/root/.config/gcloud" \
  williamrolando88/gcloud-nodejs:node22 \
  bash -c "node --version && gcloud --version"
```

### Use as a base image

```dockerfile
FROM williamrolando88/gcloud-nodejs:node22

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
CMD ["node", "index.js"]
```

## Build locally

```bash
# Node 22
docker build --build-arg NODE_VERSION=22 -t gcloud-nodejs:node22 .

# Node 24
docker build --build-arg NODE_VERSION=24 -t gcloud-nodejs:node24 .
```

## CI/CD setup

The workflow requires the following configured in your GitHub repository:

| Type   | Name              | Description                                                                           |
| ------ | ----------------- | ------------------------------------------------------------------------------------- |
| Secret | `DOCKERHUB_TOKEN` | Docker Hub access token ([create one here](https://hub.docker.com/settings/security)) |

The Docker Hub username (`williamrolando88`) is hardcoded in the workflow.

Images are rebuilt:

- On every push to `main` / `master`
- Every Monday at 06:00 UTC (to pick up new `gcloud` releases)
- Manually via the **Run workflow** button

## What's included

- All tools from `google/cloud-sdk:latest` (`gcloud`, `gsutil`, `bq`, `kubectl`, …)
- Node.js (version controlled by tag)
- `npm` (bundled with Node.js)
- `pnpm` (latest, enabled via corepack)

## Known issues

These are documented but will not be fixed, since this image is going to be deprecated soon.

- **Tags are mutable.** `node22` and `node24` are overwritten on every rebuild (at least weekly). There are no date- or SHA-based tags, so consumers can't pin a specific build.
- **Builds are not reproducible.** The base image (`google/cloud-sdk:latest`) and pnpm (`pnpm@latest`) are unpinned, so two builds of the same commit can differ.
- **No Node 26 tag.** Only Node 22 and 24 are built.
- **The "Image digest" workflow step doesn't print the digest.** It only echoes the tags again.
- **The `org.opencontainers.image.source` label is wrong.** It points to `github.com/williammorales/gcloud-nodejs`, but the repository is `github.com/williamrolando88/gcloud-nodejs`.
