use std/assert
use bf-send


#======================================================================================================================
# values
#======================================================================================================================

# Return the Send configuration with BF_SEND_URI and $vars set
def values_with [vars: record = {}]: nothing -> record {
    with-env ({BF_SEND_URI: "https://send.test"} | merge $vars) { bf-send conf values }
}

export def values__fail_without_uri [] {
    assert error { bf-send conf values }
}

export def values__use_defaults [] {
    let result = values_with

    assert equal "3000" $result.PORT
    assert equal "https://send.test" $result.BASE_URL
    assert equal "/uploads" $result.FILE_DIR
    assert equal "production" $result.NODE_ENV
    assert equal "3600,86400,604800,2419200" $result.EXPIRE_TIMES_SECONDS
    assert equal "604800" $result.DEFAULT_EXPIRE_SECONDS
    assert equal "2419200" $result.MAX_EXPIRE_SECONDS
    assert equal "1,5,10" $result.DOWNLOAD_COUNTS
    assert equal "1" $result.DEFAULT_DOWNLOADS
    assert equal "10" $result.MAX_DOWNLOADS
    assert equal "64" $result.MAX_FILES_PER_ARCHIVE
    assert equal "2000000000" $result.MAX_FILE_SIZE
    assert equal "6379" $result.REDIS_PORT
}

export def values__convert_durations_and_sizes_to_whole_numbers [] {
    # dividing a duration or file size gives a decimal in Nushell, which Send does not expect
    let result = values_with {
        BF_SEND_EXPIRE: "[30min, 2day]"
        BF_SEND_EXPIRE_DEFAULT: "30min"
        BF_SEND_EXPIRE_MAX: "2day"
        BF_SEND_FILES_MAX_SIZE: "500mb"
    }

    assert equal "1800,172800" $result.EXPIRE_TIMES_SECONDS
    assert equal "1800" $result.DEFAULT_EXPIRE_SECONDS
    assert equal "172800" $result.MAX_EXPIRE_SECONDS
    assert equal "500000000" $result.MAX_FILE_SIZE
}

export def values__use_settings [] {
    let result = values_with {
        BF_SEND_DIR: "/data"
        BF_SEND_DOWNLOAD_COUNT: "[1, 2, 3]"
        BF_SEND_DOWNLOAD_COUNT_DEFAULT: "2"
        BF_SEND_DOWNLOAD_COUNT_MAX: "3"
        BF_SEND_FILES_MAX_PER_ARCHIVE: "8"
    }

    assert equal "/data" $result.FILE_DIR
    assert equal "1,2,3" $result.DOWNLOAD_COUNTS
    assert equal "2" $result.DEFAULT_DOWNLOADS
    assert equal "3" $result.MAX_DOWNLOADS
    assert equal "8" $result.MAX_FILES_PER_ARCHIVE
}

export def values__pass_redis_settings [] {
    let result = values_with {
        BF_SEND_REDIS_HOST: "redis"
        BF_SEND_REDIS_PORT: "6380"
        BF_SEND_REDIS_USER: "send"
        BF_SEND_REDIS_PASS: "secret"
        BF_SEND_REDIS_DB: "2"
    }

    assert equal "redis" $result.REDIS_HOST
    assert equal "6380" $result.REDIS_PORT
    assert equal "send" $result.REDIS_USER
    assert equal "secret" $result.REDIS_PASSWORD
    assert equal "2" $result.REDIS_DB
}

export def values__leave_unset_redis_settings_empty [] {
    # empty values are not saved by 'bf env set', so Send uses its own defaults (e.g. localhost)
    let result = values_with

    assert equal "" $result.REDIS_HOST
    assert equal "" $result.REDIS_PASSWORD
}
