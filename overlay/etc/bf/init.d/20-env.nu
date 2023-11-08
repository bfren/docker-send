use bf
bf env load

# Set environment variables
def main [] {
    # use src directory as run file
    bf env set NODE_RUN $"(bf env ETC_SRC)/send/server/bin/prod.js"

    # return nothing
    return
}
