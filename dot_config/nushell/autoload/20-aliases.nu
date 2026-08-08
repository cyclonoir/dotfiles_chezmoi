# File system
alias ls = eza -lh --group-directories-first --icons=auto
alias lsa = eza -lha --group-directories-first --icons=auto
alias lt = eza --tree --level 3 --long --git --git-ignore --group-directories-first --icons=auto
alias lta = eza --tree --level 3 --long --git --all --group-directories-first --icons=auto
alias ff = fzf --preview 'bat --style=numbers --color=always {}'

# Git
alias g = git
alias gcm = git commit -m
alias gcam = git commit -a -m
alias gcad = git commit -a --amend
alias lg = lazygit

# Chezmoi
alias cz = chezmoi
alias cze = chezmoi edit
alias czd = chezmoi diff
alias cza = chezmoi apply
alias czad = chezmoi add
alias czu = chezmoi update
alias czcd = chezmoi cd
alias czs = chezmoi status

# Archives
alias decompress = tar -xzf
