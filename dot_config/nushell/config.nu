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

# Chezmoi aliases
alias cz = chezmoi
alias cze = chezmoi edit
alias czd = chezmoi diff
alias cza = chezmoi apply
alias czad = chezmoi add
alias czu = chezmoi update
alias czcd = chezmoi cd
alias czs = chezmoi status
