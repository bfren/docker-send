use std/assert
use bf-send


#======================================================================================================================
# cleanup
#======================================================================================================================

# Create an uploads directory with files last modified $days_ago days ago, and return its path
def uploads [files: list<string>, days_ago: int]: nothing -> string {
    let dir = mktemp --directory
    let modified = (date now) - ($days_ago * 1day) | format date "%Y%m%d%H%M"
    for x in $files {
        "data" | save $"($dir)/($x)"
        ^touch -t $modified $"($dir)/($x)"
    }
    $dir
}

export def cleanup__removes_expired_files [] {
    # Send names files DAYS-ID, where DAYS is how many days the file is kept for
    let dir = uploads ["1-expired" "2-expired"] 3

    bf-send cleanup $dir

    assert equal [] (ls $dir | get name)
}

export def cleanup__keeps_files_that_have_not_expired [] {
    let dir = uploads ["7-current" "30-current"] 3

    bf-send cleanup $dir

    assert equal ["30-current" "7-current"] (ls $dir | get name | path basename | sort)
}

export def cleanup__ignores_other_files [] {
    let dir = uploads ["readme.txt" "no_days"] 100

    bf-send cleanup $dir

    assert equal ["no_days" "readme.txt"] (ls $dir | get name | path basename | sort)
}

export def cleanup__uses_file_dir_by_default [] {
    let dir = uploads ["1-expired" "7-current"] 3

    with-env {FILE_DIR: $dir} { bf-send cleanup }

    assert equal ["7-current"] (ls $dir | get name | path basename)
}
