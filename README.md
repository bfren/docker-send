# Docker Send

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-send) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fsend) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fsend)<br/>
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-send/dev?label=build)

[Docker Repository](https://hub.docker.com/r/bfren/send) - [bfren ecosystem](https://github.com/bfren/docker)

Comes with [Send](https://github.com/timvisee/send), a community fork of Mozilla's discontinued [Firefox Send](https://github.com/mozilla/send).  Should be used behind a proxy server, e.g. [Nginx Proxy](https://github.com/bfren/docker-nginx-proxy).

You need to ensure you allow websockets, e.g. if you are using [Nginx Proxy](https://github.com/bfren/docker-nginx-proxy) add a file to the proxy configuration like so:

```bash
# in proxy image volume: /sites

# create file: DOMAIN.d/websockets.conf (where DOMAIN is the Send domain)
include helpers/proxy-params-websockets.conf;

# then run this on the host
docker exec proxy nginx-reload
```

## Contents

* [Ports](#ports)
* [Volumes](#volumes)
* [Environment Variables](#environment-variables)
* [Licence / Copyright](#licence)

## Ports

* 3000

## Volumes

| Volume     | Purpose                         |
| ---------- | ------------------------------- |
| `/uploads` | Persistent storage for uploads. |

See the [Node](https://github.com/bfren/docker-node) image for other configuration details.

## Environment Variables

| Variable                           | Values  | Description                                                                                             | Default                                  |
| ---------------------------------- | ------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| `SEND_BASE_URI`                    | string  | Set the base URI from which Send will be accessed.                                                      | *None* - required                        |
| `SEND_FILE_DIR`                    | string  | Path to uploads storage directory.                                                                      | /uploads                                 |
| `SEND_MAX_FILE_SIZE`               | integer | Maximum file size in bytes (default: 2GB).                                                              | 2147483648 (2GB)                         |
| `SEND_MAX_FILES_PER_ARCHIVE`       | integer | Maximum files per archive (default: 64).                                                                | 64                                       |
| `SEND_MAX_EXPIRE_SECONDS`          | integer | Maximum upload expiry time in seconds (default: 7 days).                                                | 604800 (7 days)                          |
| `SEND_MAX_DOWNLOADS`               | integer | Maximum number of downloads (default: 100).                                                             | 10                                       |
| `SEND_DOWNLOAD_COUNTS`             | string  | Comma-separated download limit options to show in UI dropdown (default: 1, 5, 10).                      | 1,5,10                                   |
| `SEND_DEFAULT_DOWNLOAD_COUNT`      | integer | Default download limit in UI (default: 1).                                                              | 1                                        |
| `SEND_EXPIRE_TIMES_SECONDS`        | string  | Comma-separated expiry time options to show in UI dropdown in seconds (default: 1 hour, 1 day, 1 week). | 3600,86400,604800 (1 day, 1 day, 1 week) |
| `SEND_DEFAULT_EXPIRE_TIME_SECONDS` | integer | Default expiry time in UI (default: 1 day).                                                             | 86400 (1 day)                            |

## Licence

> [MIT](https://mit.bfren.dev/2022)

## Copyright

> Copyright (c) 2022 [bfren](https://bfren.dev) (unless otherwise stated)
