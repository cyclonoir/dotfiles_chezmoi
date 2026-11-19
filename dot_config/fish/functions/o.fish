function o --wraps xdg-open --description 'Open files or URLs in their default app'
    # xdg-open writes handler chatter to stderr even on success, which lands in the middle of the
    # prompt; the redirect drops it.
    xdg-open $argv 2>/dev/null
end
