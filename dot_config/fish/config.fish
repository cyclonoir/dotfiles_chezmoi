# fish config for every Linux machine. Functions live one per file in functions/, loaded on first use.
# Work-only ones live in work/, which conf.d/work.fish adds on work machines (chezmoi leaves both out
# elsewhere). mise and starship are started by conf.d/dev-setup.fish, which dev-setup manages.

set -gx EDITOR nvim
set -gx SUDO_EDITOR nvim
# The "ansi" theme paints with the terminal's own 16 colors, so bat and delta (and vivid's LS_COLORS
# below) follow the desktop palette and never need regenerating when it changes.
set -gx BAT_THEME ansi

if status is-interactive
    zoxide init fish --cmd cd | source
    # fzf first: ctrl-t inserts a file path, alt-c changes directory. atuin then takes ctrl-r and up.
    fzf --fish | source
    atuin init fish | source
    set -gx LS_COLORS (vivid generate ansi)

    # File system
    alias ls 'eza -lh --group-directories-first --icons=auto'
    alias lsa 'eza -lha --group-directories-first --icons=auto'
    alias lt 'eza --tree --level 3 --long --git --git-ignore --group-directories-first --icons=auto'
    alias lta 'eza --tree --level 3 --long --git --all --group-directories-first --icons=auto'
    alias ff "fzf --preview 'bat --style=numbers --color=always {}'"

    # Abbreviations expand as you type them, so your history keeps the full command.
    # Git
    abbr -a g git
    abbr -a gcm git commit -m
    abbr -a gcam git commit -a -m
    abbr -a gcad git commit -a --amend
    abbr -a lg lazygit

    # chezmoi
    abbr -a cz chezmoi
    abbr -a cze chezmoi edit
    abbr -a czd chezmoi diff
    abbr -a cza chezmoi apply
    abbr -a czad chezmoi add
    abbr -a czu chezmoi update
    abbr -a czcd chezmoi cd
    abbr -a czs chezmoi status

    # Archives
    abbr -a decompress tar -xzf

    # .NET
    abbr -a build dotnet build -maxcpucount:6 -p:EnableSourceControlManagerQueries=false
end
