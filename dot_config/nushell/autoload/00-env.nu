# Environment variables for this machine (Linux).

$env.EDITOR = "nvim"
$env.SUDO_EDITOR = "nvim"
$env.BAT_THEME = "ansi"

# Lets carapace serve completions that were only ever written for these other
# shells; it shells out to them on demand, so they have to be installed.
$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"

# Installed tools to leave out of refresh-tool-init anyway. Adding "atuin"
# here keeps nushell's built-in ctrl-r instead of atuin's history search.
$env.NU_TOOL_INIT_SKIP = []

$env.OMARCHY_PATH = ($nu.home-dir | path join ".local/share/omarchy")
$env.PATH = (
    $env.PATH
    | prepend ($env.OMARCHY_PATH | path join "bin")
    | append ($nu.home-dir | path join ".local/bin")
)
