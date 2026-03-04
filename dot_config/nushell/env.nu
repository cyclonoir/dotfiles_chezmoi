# env.nu
#
# Installed by:
# version = "0.109.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.OMARCHY_PATH = ($env.HOME | path join ".local/share/omarchy")
$env.PATH = ($env.PATH | prepend ($env.OMARCHY_PATH | path join "bin") | append ($env.HOME | path join ".local/bin"))
$env.EDITOR = "nvim"
$env.SUDO_EDITOR = "nvim"
$env.BAT_THEME = "ansi"

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir ($nu.cache-dir)
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"