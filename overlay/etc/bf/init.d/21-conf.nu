use bf
bf env load

# Send is configured via environment variables
def main [] {
    bf env show
    # URI is a required value
    if (bf env empty SEND_URI) { bf write error "BF_SEND_URI cannot be empty." }

    # server
    bf env set -P PORT 3000
    bf env set -P BASE_URL (bf env SEND_URI)
    bf env set -P FILE_DIR (bf env SEND_DIR "/uploads")
    bf env set -P NODE_ENV "production"

    # expiry times
    bf env set -P EXPIRE_TIMES_SECONDS (bf env SEND_EXPIRE "[1hr, 1day, 1wk, 4wk]" | from nuon | each {|x| $x | into duration | $in / 1sec } | str join ",")
    bf env set -P DEFAULT_EXPIRE_SECONDS (bf env SEND_EXPIRE_DEFAULT "1wk" | into duration | $in / 1sec)
    bf env set -P MAX_EXPIRE_SECONDS (bf env SEND_EXPIRE_MAX "4wk" | into duration | $in / 1sec)

    # download count
    bf env set -P DOWNLOAD_COUNTS (bf env SEND_DOWNLOAD_COUNT "[1, 5, 10]" | from nuon | str join ",")
    bf env set -P DEFAULT_DOWNLOADS (bf env SEND_DOWNLOAD_COUNT_DEFAULT 1)
    bf env set -P MAX_DOWNLOADS (bf env SEND_DOWNLOAD_COUNT_MAX 10)

    # files
    bf env set -P MAX_FILES_PER_ARCHIVE (bf env SEND_FILES_MAX_PER_ARCHIVE 64)
    bf env set -P MAX_FILE_SIZE (bf env SEND_FILES_MAX_SIZE "2gb" | into filesize | $in / 1b)

    # redis
    bf env set -P REDIS_USER (bf env -s SEND_REDIS_USER)
    bf env set -P REDIS_PASSWORD (bf env -s SEND_REDIS_PASS)
    bf env set -P REDIS_HOST (bf env -s SEND_REDIS_HOST)
    bf env set -P REDIS_PORT (bf env SEND_REDIS_PORT 6379)
    bf env set -P REDIS_DB (bf env -s SEND_REDIS_DB)

    # return nothing
    return
}
