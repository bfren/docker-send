use bf

# Return the environment variables Send is configured with, built from the BF_SEND_* variables - Send expects whole
# numbers, so durations are converted to seconds and file sizes to bytes
export def values []: nothing -> record {
    # URI is a required value
    if (bf env empty SEND_URI) { bf write error "BF_SEND_URI cannot be empty." conf/values }

    {
        # server
        PORT: "3000"
        BASE_URL: (bf env SEND_URI)
        FILE_DIR: (bf env SEND_DIR "/uploads")
        NODE_ENV: "production"

        # expiry times
        EXPIRE_TIMES_SECONDS: (bf env SEND_EXPIRE "[1hr, 1day, 1wk, 4wk]" | from nuon | each {|x| $x | into duration | seconds } | str join ",")
        DEFAULT_EXPIRE_SECONDS: (bf env SEND_EXPIRE_DEFAULT "1wk" | into duration | seconds)
        MAX_EXPIRE_SECONDS: (bf env SEND_EXPIRE_MAX "4wk" | into duration | seconds)

        # download count
        DOWNLOAD_COUNTS: (bf env SEND_DOWNLOAD_COUNT "[1, 5, 10]" | from nuon | str join ",")
        DEFAULT_DOWNLOADS: (bf env SEND_DOWNLOAD_COUNT_DEFAULT 1 | into string)
        MAX_DOWNLOADS: (bf env SEND_DOWNLOAD_COUNT_MAX 10 | into string)

        # files
        MAX_FILES_PER_ARCHIVE: (bf env SEND_FILES_MAX_PER_ARCHIVE 64 | into string)
        MAX_FILE_SIZE: (bf env SEND_FILES_MAX_SIZE "2gb" | into filesize | $in / 1b | into int | into string)

        # redis - empty values are not set, so Send's defaults are used
        REDIS_USER: (bf env -s SEND_REDIS_USER)
        REDIS_PASSWORD: (bf env -s SEND_REDIS_PASS)
        REDIS_HOST: (bf env -s SEND_REDIS_HOST)
        REDIS_PORT: (bf env SEND_REDIS_PORT 6379 | into string)
        REDIS_DB: (bf env -s SEND_REDIS_DB)
    }
}

# Convert a duration to whole seconds
def seconds []: duration -> string { $in / 1sec | into int | into string }
