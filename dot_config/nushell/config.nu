# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
#

source ~/.zoxide.nu
use ($nu.default-config-dir | path join mise.nu)
source $"($nu.cache-dir)/carapace.nu"

$env.config.history.file_format = "sqlite"

# File system
alias ls = eza -lh --group-directories-first --icons=auto
alias lsa = eza -lha --group-directories-first --icons=auto
alias lt = eza --tree --level=2 --long --icons --git
alias lta = eza --tree --level=2 --long --icons --git -a
alias ff = fzf --preview 'bat --style=numbers --color=always {}'

def eff [] {
    let file = (fzf --preview 'bat --style=numbers --color=always {}')
    if ($file | is-not-empty) { nvim $file }
}

def n [...args] {
    if ($args | is-empty) { nvim . } else { nvim ...$args }
}

def o [...args] {
    ^xdg-open ...$args err>| ignore
}

def cx [] {
    print -n "\e[2J\e[3J\e[H"
    claude --allow-dangerously-skip-permissions
}

# Compression
def compress [path: string] { tar -czf $"($path | str trim --right --char '/').tar.gz" ($path | str trim --right --char '/') }
alias decompress = tar -xzf

# Git
alias g = git
alias gcm = git commit -m
alias gcam = git commit -a -m
alias gcad = git commit -a --amend

# Chezmoi aliases
alias cz = chezmoi
alias cze = chezmoi edit
alias czd = chezmoi diff
alias cza = chezmoi apply
alias czad = chezmoi add
alias czu = chezmoi update
alias czcd = chezmoi cd
alias czs = chezmoi status

# Keybindings
$env.config.keybindings = [
    {
        name: fzf_file
        modifier: control
        keycode: char_t
        mode: [emacs, vi_insert]
        event: {
            send: executehostcommand
            cmd: "fzf --height 40% | commandline edit --insert $in"
        }
    }
]
