use bf

# Remove all expired files from uploads directory
export def main [] {
    # for each file in uploads directory, if it has expired, delete it
    bf env -P FILE_DIR | ls --full-paths | select name modified | each {|x|
        # get the expiry date and time of this file
        # Send stores files as DAYS-REF, where DAYS is the number of days to keep the file for
        let days = $x.name | path basename | parse "{days}-{ref}" | get days | into int | into duration --unit day
        let expiry = $x.modified + $days

        # if the expiry time has passed, delete the file
        if $expiry > (date now) {
            bf write debug $"File ($x.name) expires on ($expiry)." cleanup
        } else {
            bf write $"File ($x.name) expired on ($expiry)." cleanup
            rm -f $x.name
        }
    }
}
