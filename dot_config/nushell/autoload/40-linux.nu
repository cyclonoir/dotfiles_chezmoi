# Settings and commands specific to this machine (Linux).

# xdg-open writes handler chatter to stderr even on success, which lands in the
# middle of the prompt; the redirect drops it.
def o [...args] {
    ^xdg-open ...$args err>| ignore
}

# 2J clears the visible screen, 3J clears the scrollback buffer and H homes the
# cursor — a harder reset than `clear`, which leaves scrollback intact.
def cx [] {
    print -n "\e[2J\e[3J\e[H"
    claude --allow-dangerously-skip-permissions
}
