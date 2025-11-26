use bf

# Remove all expired files from uploads directory
export def main [] {
    # parse uploaded files stored as DAYS-REF, where DAYS is the number of days to keep the file for
    let files = bf env -P FILE_DIR
        | ls --full-paths
        | each {|x|
            $x.name
                | path basename
                | parse "{days}-{ref}"
                | into record
                | insert path { $x.name }
                | insert modified { $x.modified }
        }

    # remove any files that have passed their expiry date
    let removed = $files
        | where {|x| $x.days? != null }
        | each {|x|
            let expiry = $x.days
                | into int
                | into duration --unit day
                | $x.modified + $in
            if $expiry > (date now) {
                bf write debug $"File ($x.days)-($x.ref) expires on ($expiry)." cleanup
            } else {
                bf write $"File ($x.days)-($x.ref) expired on ($expiry)." cleanup
                rm --force $x.name
                $x.name
            }
        }

    # output action taken
    if ($removed | length) == 0 {
        bf write "No files were removed." cleanup
    } else {
        bf write $"($removed | length) files were removed." cleanup
    }

    return
}
