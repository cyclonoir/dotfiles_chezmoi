# Nushell loads configuration in this order:
#
#   1. env.nu                                   this file
#   2. config.nu                                core $env.config settings
#   3. $nu.data-dir/vendor/autoload/*.nu        generated tool integrations
#   4. $nu.default-config-dir/autoload/*.nu     everything else, alphabetically
#
# Steps 3 and 4 run *after* config.nu, so config.nu cannot use anything they
# define. Only things that must exist before config.nu belong in this file,
# and currently nothing does — hence no code below.
#
# Within autoload/, files numbered 00-30 are kept identical on every machine;
# 40-<platform>.nu is where per-machine settings and commands go.
