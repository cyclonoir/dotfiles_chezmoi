# Third-party shell integrations: starship, zoxide, carapace, mise, atuin.
#
# Each of these ships a command that prints a nushell script to wire it up
# (`starship init nu`, `zoxide init nushell`, and so on). Running them at every
# shell startup spawns a subprocess per tool and costs tens of milliseconds
# each time. Instead the output is written once into $nu.data-dir/vendor/
# autoload/, which nushell sources automatically on startup, so the recurring
# cost is nothing.
#
# The tradeoff is that the generated scripts go stale when a tool is upgraded.
# Regenerate them with:
#
#     refresh-tool-init
#
# Tools are discovered rather than hardcoded per machine, so this file is the
# same everywhere: each machine generates init only for what it actually has
# installed. To skip a tool that *is* installed, list it in
# $env.NU_TOOL_INIT_SKIP (set in 00-env.nu):
#
#     $env.NU_TOOL_INIT_SKIP = ["atuin"]   # keep nushell's built-in ctrl-r

def tool-init-specs [] {
    {
        starship: {|| starship init nu }
        zoxide: {|| zoxide init --cmd cd nushell }
        carapace: {|| carapace _carapace nushell }
        mise: {|| ^mise activate nu }
        atuin: {|| atuin init nu }
    }
}

def vendor-autoload-dir [] {
    $nu.data-dir | path join "vendor" "autoload"
}

# Write init scripts for every supported tool installed here, and delete the
# scripts for any that are no longer installed or have been skipped.
def refresh-tool-init [] {
    let dir = (vendor-autoload-dir)
    mkdir $dir
    let specs = (tool-init-specs)
    let skip = ($env.NU_TOOL_INIT_SKIP? | default [])

    for name in ($specs | columns) {
        let target = ($dir | path join $"($name).nu")
        if ($name in $skip) {
            if ($target | path exists) {
                rm --force $target
                print $"  removed ($name).nu \(skipped on this machine)"
            }
            continue
        }
        if (which $name | is-empty) {
            if ($target | path exists) {
                rm --force $target
                print $"  removed ($name).nu \(no longer installed)"
            }
            continue
        }
        do ($specs | get $name) | save --force $target
        print $"  wrote ($name).nu"
    }

    print "Restart nushell to pick up the changes."
}

# Nothing generates the scripts automatically, so on a machine where
# refresh-tool-init has never run the integrations are simply absent. Say so
# once, instead of leaving a missing prompt and a missing `cd` to be diagnosed.
if (vendor-autoload-dir | path exists | $in == false) {
    print "nushell: no tool integrations generated yet — run `refresh-tool-init`"
}
