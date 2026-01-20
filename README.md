# Docker Send

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-send) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fsend) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fsend) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-send/dev.yml?branch=main)

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

For `nu` duration and filesize types, visit [here](https://www.nushell.sh/book/types_of_data.html).

| Variable                          | Values                | Description                                                                           | Default               |
| --------------------------------- | --------------------- | ------------------------------------------------------------------------------------- | --------------------- |
| `BF_SEND_URI`                     | string                | Set the base URI from which Send will be accessed.                                    | *None* - required     |
| `BF_SEND_DIR`                     | string                | Path to uploads storage directory.                                                    | /uploads              |
| `BF_SEND_DOWNLOAD_COUNT`          | nuon integer list     | Comma-separated download limit options to show in UI dropdown.                        | [1, 5, 10]            |
| `BF_SEND_DOWNLOAD_COUNT_DEFAULT`  | integer               | Default download limit in UI (default: 1).                                            | 1                     |
| `BF_SEND_DOWNLOAD_COUNT_MAX`      | integer               | Maximum number of downloads (default: 100).                                           | 10                    |
| `BF_SEND_EXPIRE`                  | nuon duration list    | Comma-separated expiry time options to show in UI dropdown in seconds (default: ).    | [1hr, 1day, 1wk, 4wk] |
| `BF_SEND_EXPIRE_DEFAULT`          | nu duration           | Default expiry time in UI (default: 1day).                                            | 1wk                   |
| `BF_SEND_EXPIRE_MAX`              | nu duration           | Maximum upload expiry time in seconds.                                                | 4wk                   |
| `BF_SEND_FILES_MAX_PER_ARCHIVE`   | integer               | Maximum files per archive (default: 64).                                              | 64                    |
| `BF_SEND_FILES_MAX_SIZE`          | integer               | Maximum file size in bytes (default: 2gb).                                            | 2gb                   |
| `BF_SEND_REDIS_DB`                | integer               | Redis database number.                                                                | *None* - optional     |
| `BF_SEND_REDIS_HOST`              | string                | Redis server host.                                                                    | *None* - optional     |
| `BF_SEND_REDIS_PASS`              | string                | Redis authentication password.                                                        | *None* - optional     |
| `BF_SEND_REDIS_PORT`              | integer               | Redis server port.                                                                    | *None* - optional     |
| `BF_SEND_REDIS_USER`              | string                | Redis authentication username.                                                        | *None* - optional     |

## Licence

> [MIT](https://mit.bfren.dev/2022)

## Copyright

> Copyright (c) 2022-2026 [bfren](https://bfren.dev) (unless otherwise stated)
