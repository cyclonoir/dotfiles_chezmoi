# Third-party shell integrations: starship, zoxide, carapace, mise, atuin, vivid.
#
# Most of these ship a command that prints a nushell script to wire it up
# (`starship init nu`, `zoxide init nushell`, and so on). vivid is the odd one:
# it prints an LS_COLORS value rather than a script, so its spec wraps that
# value in the assignment itself. Running them at every
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
        # atuin 18.19 emits both of its keybindings with `name: atuin`, and
        # nushell 0.115 warns about that (nu::shell::shared_keybindings_name)
        # on every startup. Both bindings keep working, so rename the up-arrow
        # one to make the names unique. No-op once atuin fixes this upstream.
        atuin: {|| atuin init nu | str replace --regex '(?m)^(\s*)name: atuin(\s*\n\s*modifier: none)' '${1}name: atuin_up${2}' }
        # The "ansi" theme paints with the terminal's own 16 ANSI colors
        # instead of hardcoded hex, so LS_COLORS follows whatever Omarchy
        # theme is active and never needs regenerating on a theme switch.
        # Same reasoning as $env.BAT_THEME in 00-env.nu.
        vivid: {|| $"$env.LS_COLORS = '(vivid generate ansi | str trim)'" }
    }
}

# Some tools emit init scripts that nushell complains about. Patch the output
# on the way past rather than editing the generated file, which the next
# refresh-tool-init would overwrite anyway.
#
# atuin 18.19.0 gives both its ctrl-r and its up-arrow keybinding the name
# "atuin", and nushell warns about duplicate keybinding names at every startup.
# Both bindings work; only the warning is a problem. Remove this once upstream
# gives them distinct names.
def fixup-tool-init [name: string, script: string] {
    if $name == "atuin" {
        $script | str replace --all --regex 'name: atuin(\n\s*modifier: none)' 'name: atuin_up${1}'
    } else {
        $script
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
        let script = (do ($specs | get $name) | into string)
        fixup-tool-init $name $script | save --force $target
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
