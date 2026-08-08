# Core nushell settings. Aliases, commands, environment variables and tool
# integrations live in autoload/; see env.nu for the load order.

# The sqlite backend records timestamps, exit codes and session ids that the
# plaintext one cannot. Fields are assigned individually rather than replacing
# $env.config.history wholesale, so keys left unset keep following nushell's
# defaults as those change.
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 5_000_000
$env.config.history.sync_on_enter = true
$env.config.history.isolation = false

# `++=` appends. A plain `=` here would silently discard every keybinding
# nushell ships with.
$env.config.keybindings ++= [
    {
        name: fzf_fuzzy_search
        modifier: control
        keycode: char_t
        mode: [emacs vi_normal vi_insert]
        event: {
            send: executehostcommand
            cmd: "fzf --height 40% | commandline edit --insert $in"
        }
    }
]
