# Environment variables for this machine (Windows).

$env.EDITOR = "nvim"

# Installed tools to leave out of refresh-tool-init anyway. Adding "atuin"
# here keeps nushell's built-in ctrl-r instead of atuin's history search.
$env.NU_TOOL_INIT_SKIP = []

# $env.CARAPACE_BRIDGES is deliberately unset. Bridging carapace to zsh/fish/
# bash completions requires those shells to be installed and shells out to them
# on demand, which is a poor trade where process creation is this expensive.
