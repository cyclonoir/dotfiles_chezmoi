def eff [] {
    let file = (fzf --preview 'bat --style=numbers --color=always {}')
    if ($file | is-not-empty) { nvim $file }
}

def n [...args] {
    if ($args | is-empty) { nvim . } else { nvim ...$args }
}

# `--env` so the directory change outlives the command; without it nushell
# discards the caller's environment on return and this becomes a no-op.
def --env dotfiles [] {
    cd (chezmoi source-path)
}

# The trailing slash has to go, or `compress foo/` writes foo/.tar.gz — a
# hidden file inside the directory being archived — instead of foo.tar.gz.
def compress [path: string] {
    let target = ($path | str trim --right --char '/')
    tar -czf $"($target).tar.gz" $target
}
