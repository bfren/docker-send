use bf
use bf-send
bf env load

# Send is configured via environment variables
def main [] {
    bf-send conf values | items {|key, value| bf env set -P $key $value } | ignore

    # return nothing
    return
}
