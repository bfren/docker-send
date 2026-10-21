use bf
bf env load

# Set environment variables
def main [] {
    # start Send through start.js, which restores util functions removed in Node.js 23 before loading the server
    bf env set NODE_RUN $"(bf env ETC_SRC)/send/server/bin/start.js"

    # return nothing
    return
}
