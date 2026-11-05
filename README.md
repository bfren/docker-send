# Send

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-send) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fsend) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fsend) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-send/build.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/send) - [Quay.io](https://quay.io/repository/bfren/send) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

[Send](https://github.com/timvisee/send) lets you share files with end-to-end encryption and a link that expires - a community fork of Mozilla's discontinued Firefox Send.

It is built on [Node.js](https://github.com/bfren/docker-node) (version 26), with Send built from source when the image is built. Configure it with `BF_SEND_*` variables using friendly values such as `1wk` and `2gb`, and expired uploads are deleted from disk every hour.

Send needs [Redis](https://github.com/bfren/docker-redis) to store details of uploads, and should run behind an HTTPS reverse proxy such as [Caddy Proxy](https://github.com/bfren/docker-caddy-proxy).

## Quickstart

`docker-compose.yml`:

```yaml
services:
  proxy:
    image: quay.io/bfren/caddy-proxy:2
    restart: unless-stopped
    ports:
      - "0.0.0.0:80:80"
      - "0.0.0.0:443:443"
    environment:
      - BF_PROXY_DOMAIN=proxy.example.com
      - BF_PROXY_LETS_ENCRYPT_EMAIL=you@example.com
      - BF_PROXY_AUTO_PRIMARY=send.example.com
      - BF_PROXY_AUTO_UPSTREAM=http://send:3000
    volumes:
      - ./v/ssl:/ssl
      - ./v/sites:/sites

  send:
    image: quay.io/bfren/send:4
    restart: unless-stopped
    environment:
      - BF_SEND_URI=https://send.example.com
      - BF_SEND_REDIS_HOST=redis
    volumes:
      - ./v/uploads:/uploads

  redis:
    image: quay.io/bfren/redis:redis8
    restart: unless-stopped
```

Run `docker compose up -d` and open `https://send.example.com`. Caddy Proxy passes on the WebSocket connections Send uses for uploads automatically - with another proxy, make sure WebSockets are allowed.

## Features

* 🔒 End-to-end encrypted file sharing, with links that expire after a time or a number of downloads
* ⚙️ Limits set with friendly values - `1wk`, `2gb`, `[1hr, 1day, 1wk]`
* 🧹 Expired uploads deleted from disk every hour
* 👤 Runs as `node` (UID 1000), not root
* 🧪 Built-in tests

## Tags

Images are published to Docker Hub (`bfren/send`) and Quay.io (`quay.io/bfren/send`) for `linux/amd64` and `linux/arm64`.

| Tag                | Example       | Use when                                   |
| ------------------ | ------------- | ------------------------------------------ |
| `latest`           |               | You always want the newest image           |
| `MAJOR`            | `4`           | You want updates, but not breaking changes |
| `MINOR`            | `4.0`         | You want fixes only - **recommended**      |
| `VERSION`          | `4.0.0`       | You want to pin this image exactly         |
| `sendX`, `sendX.Y` | `send3.5`     | You want a Send version                    |
| `sendX.Y.Z`        | `send3.5.0`   | You want an exact Send release             |
| `sendX-VERSION`    | `send3-4.0.0` | You want to pin both                       |

This version of the image includes Send 3.5.0, on Node.js 26.

## Configuration

### Ports

| Port   | Purpose |
| ------ | ------- |
| `3000` | Send    |

### Volumes

| Volume     | Purpose                                      |
| ---------- | -------------------------------------------- |
| `/uploads` | Uploaded files (encrypted), owned by `node`. |

### Environment Variables

Durations and sizes use [Nushell's formats](https://www.nushell.sh/book/types_of_data.html), e.g. `30min`, `1day`, `1wk`, `500mb`, `2gb` (Nushell has no months - use `4wk`). Lists are written like `[1, 5, 10]`.

| Variable                         | Values            | Description                                                                 | Default                 |
| -------------------------------- | ----------------- | --------------------------------------------------------------------------- | ----------------------- |
| `BF_SEND_URI`                    | URL               | **Required.** The address Send is used at, e.g. `https://send.example.com`. |                         |
| `BF_SEND_DIR`                    | path              | Where uploads are stored.                                                   | `/uploads`              |
| `BF_SEND_EXPIRE`                 | list of durations | Expiry options shown when uploading.                                        | `[1hr, 1day, 1wk, 4wk]` |
| `BF_SEND_EXPIRE_DEFAULT`         | duration          | Expiry option selected by default.                                          | `1wk`                   |
| `BF_SEND_EXPIRE_MAX`             | duration          | Longest expiry allowed.                                                     | `4wk`                   |
| `BF_SEND_DOWNLOAD_COUNT`         | list of numbers   | Download limit options shown when uploading.                                | `[1, 5, 10]`            |
| `BF_SEND_DOWNLOAD_COUNT_DEFAULT` | number            | Download limit selected by default.                                         | `1`                     |
| `BF_SEND_DOWNLOAD_COUNT_MAX`     | number            | Highest download limit allowed.                                             | `10`                    |
| `BF_SEND_FILES_MAX_PER_ARCHIVE`  | number            | Most files allowed in one upload.                                           | `64`                    |
| `BF_SEND_FILES_MAX_SIZE`         | size              | Largest upload allowed (`2gb` is 2,000,000,000 bytes).                      | `2gb`                   |
| `BF_SEND_REDIS_HOST`             | host name         | Redis server - Send uses `localhost` if this is not set.                    |                         |
| `BF_SEND_REDIS_PORT`             | number            | Redis port.                                                                 | `6379`                  |
| `BF_SEND_REDIS_USER`             | string            | Redis user name.                                                            |                         |
| `BF_SEND_REDIS_PASS`             | string            | Redis password.                                                             |                         |
| `BF_SEND_REDIS_DB`               | number            | Redis database number.                                                      |                         |

See [Alpine + S6](https://github.com/bfren/docker-alpine-s6#environment-variables) for `BF_DEBUG`, `BF_TZ` and the other base image variables.

## How It Works

On every start the `BF_SEND_*` variables are converted into the variables Send reads (`BASE_URL`, `EXPIRE_TIMES_SECONDS`, `MAX_FILE_SIZE` and so on), with durations in seconds and sizes in bytes. Then Send's server runs under S6 as `node`, on port 3000. The container stops if Send crashes, as in the [Node.js](https://github.com/bfren/docker-node) image.

Send stores each upload in `/uploads` as `DAYS-ID`, where `DAYS` is how many days it may be kept. Send forgets an upload when it expires, but leaves the file on disk - so every hour, files older than their `DAYS` are deleted.

The health check is the base image's, which checks cron (and so the hourly cleanup) is running.

## Testing

```sh
./test.nu   # builds the image and runs /test
./run.sh    # builds the image and opens a shell, with Send on 127.0.0.1:3000
```

`/test` runs this image's tests alongside the base images' tests: converting the `BF_SEND_*` variables (defaults, settings, whole numbers and Redis settings), the hourly cleanup, and the installed Send server.

## Troubleshooting

### The container stops straight after starting

Check `docker logs <container>`. `BF_SEND_URI cannot be empty` means it isn't set. Otherwise Send itself failed - often because it can't reach Redis.

### Uploads start but never finish

Send uploads over a WebSocket. Make sure your proxy allows WebSockets (Caddy Proxy does by default), and that `BF_SEND_URI` is the address in your browser, including `https://`.

### Downloads fail after a restart

Send keeps upload details in Redis. If Redis loses its data, uploads can't be found - mount a volume at Redis's `/data` (see [Redis](https://github.com/bfren/docker-redis)).

## FAQs

### Why are expired files still on disk?

Files are deleted by the hourly cleanup, and `DAYS` is whole days, so a file can stay for up to a day after its link expires. It is encrypted, and Send no longer knows about it, so it can't be downloaded.

## Licence

> [MIT](https://mit.bfren.dev/2022)

## Copyright

> Copyright (c) 2022-2026 [bfren](https://bfren.dev) (unless otherwise stated)
