# Settings and commands specific to this machine (Windows).

# Stop nushell emitting the OSC 9;9 (report cwd) and OSC 133 (mark prompt
# boundaries) escape sequences to the terminal.
$env.config.shell_integration.osc9_9 = false
$env.config.shell_integration.osc133 = false

# Windows ships no ssh-copy-id. This lives in the per-machine file rather than
# the shared one because Linux does ship it, and a nushell command of the same
# name would shadow the real binary there.
def ssh-copy-id [host: string, identity_file: path] {
    open $identity_file | ssh $host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
}

alias zipdir = 7z a (pwd | path basename | $in + ".7z") . -r -xr!bin -xr!obj -xr!.git -xr!node_modules

alias deps = uv run --project c:/Users/adam.miller/Documents/Projects/py_scripts c:/Users/adam.miller/Documents/Projects/py_scripts/project_dependency.py

# jediv2
alias services = dotnet run --project Source/RemoteServices/WebApi/WebApi.csproj
alias client = dotnet run --project Source/Jedi/Jedi.csproj
alias devup  = podman compose --env-file .env -f Infrastructure\docker\compose.dev-environment.yml up -d --wait
alias devdown  = podman compose --env-file .env -f Infrastructure\docker\compose.dev-environment.yml down -v

def load-testdata [
    --skip-build                        # Run dotnet with --no-build
] {
    let project = 'C:\Users\adam.miller\Documents\Projects\jediv2\Source\DevTools\TestDataLoader\TestDataLoader.csproj'
    let build_flag = if $skip_build { ["--no-build"] } else { [] }
    let selected = (dotnet run ...$build_flag --project $project -- list | fzf)

    if ($selected | is-empty) {
        return
    }

    dotnet run ...$build_flag --project $project -- load $selected
}

def generate-db [
    --verb: string = "generate"        # Verb: generate, migrate, augment, current-db-version, generate-pocos, delete-test-databases
    --database: string = "All"         # Target: All, Jedi2, Legacy, Hangfire
    --recreate-db                      # Create the initial database
    --skip-backup                      # Skip creating a database backup
    --skip-build                       # Run dotnet with --no-build
    --env-file: string = ".env"        # Path to .env file
    --command-timeout: int = 30        # SQL command timeout in seconds
    --root-dir: string = 'C:\Users\adam.miller\Documents\Projects\jediv2'
] {
    let project = 'C:\Users\adam.miller\Documents\Projects\jediv2\Source\DevTools\DatabaseGenerator\DatabaseGenerator.csproj'
    let build_flag = if $skip_build { ["--no-build"] } else { [] }

    mut args = [
        "run" "--project" $project ...$build_flag "--"
        $verb
        "--root-dir" $root_dir
        "--env-file" $env_file
        "--database" $database
        "--command-timeout" ($command_timeout | into string)
    ]

    if $recreate_db {
        $args = ($args | append "--recreate-db")
    }

    if $skip_backup {
        $args = ($args | append "--skip-backup")
    }

    dotnet ...$args
}

def import-testdata [
    job: string        # Job number (e.g., 1111-0453)
    site: string       # Site name: Butler, Fallon, Hope, Juarez, LakeCity, Salem
    --v2               # Load from V2 (JEDIv2) database instead of V1
    --with-materials   # Also load material and v1/v2 reference data
    --format: string = "sql"       # Output format: sql, codegen, json
    --output: string = "database"  # Output type: console, database, file
    --output-path: string          # File path (required if --output is "file")
] {
    let verb = if $v2 { "load-v2-job" } else { "load-v1-job" }
    let ref_verb = if $v2 { "load-v2-references" } else { "load-v1-references" }
    let project = 'C:\Users\adam.miller\Documents\Projects\jediv2\Source\DevTools\TestDataFromSql\TestDataFromSql.csproj'

    mut args = [
        "run" "--project" $project "--"
        $verb
        "--site" $site
        "--job" $job
        "--output-format" $format
        "--output-type" $output
    ]

    if ($output_path != null) {
        $args = ($args | append ["--output-path" $output_path])
    }

    dotnet ...$args

    if $with_materials {
        let base = ["run" "--project" $project "--"]
        let out = ["--site" $site "--output-format" $format "--output-type" $output]

        dotnet ...($base | append ["load-material-references"] | append $out)
        dotnet ...($base | append [$ref_verb] | append $out)
    }
}

def audit-all [
    ...hosts: string      # one or more SSH targets
    --since: string = ""  # passed to journalctl, e.g. "2026-05-07" or "2 days ago"
    --until: string = ""
] {
    let prog = '/container start/ && match($0,/[ ,]image=[^ ,)]+/){img=substr($0,RSTART+7,RLENGTH-7); if(!(img in seen)){seen[img]=1; print $4","$6","img}}'
    let since_part = (if $since != "" { $"--since '($since)' " } else { "" })
    let until_part = (if $until != "" { $"--until '($until)' " } else { "" })
    let remote = $"journalctl -u docker-events-start.service ($since_part)($until_part)| awk '($prog)'"

    $hosts | par-each { |h|
        ssh $h $remote
        | from csv --noheaders
        | rename server_name start_date image_name
        | update start_date { $in | into datetime | date to-timezone America/Indiana/Indianapolis | format date "%Y-%m-%d %H:%M:%S %Z" }
        | insert ssh_host $h
    } | flatten
}

def gen-event-index [
      --out: string      # Output HTML path (default: event-index.html in the generator dir)
  ] {
      let dir = 'C:\Users\adam.miller\Documents\Projects\jediv2-event-index-generator'
      let script = ($dir | path join gen_event_index.py)
      let target = (if ($out != null) { $out | path expand } else { $dir | path join event-index.html })

      mut args = ["run" "--project" $dir $script "--out" $target]
      uv ...$args

      start $target
  }

# management

# Compile a .tex file with pdflatex inside the container.
# The current directory is mounted at /work, so output lands next to
# the source and is owned by you (via --userns=keep-id).
export def tex [
    file: string                                # .tex file in the current directory
    --image: string = "localhost/latex-rubric"  # image name or tag
    --quiet (-q)                                # suppress pdflatex chatter
    ...rest: string                             # extra flags passed to pdflatex
]: nothing -> nothing {
    if not ($file | path exists) {
        error make {msg: $"no such file in ($env.PWD): ($file)"}
    }

    let args = [
        --rm
        --userns=keep-id                    # output files stay yours, not root's
        --volume $"($env.PWD):/work:z"      # :z relabels for SELinux, ignored elsewhere
        --workdir /work
        $image
        --interaction=nonstopmode
        --halt-on-error
        ...$rest
        $file
    ]

    let result = (podman run ...$args | complete)

    let pdf = ($file | path parse | update extension pdf | path join)

    if $result.exit_code == 0 {
        if not $quiet { print $result.stdout }
        print $"(ansi green)built(ansi reset) ($pdf)"
    } else {
        # pdflatex reports errors on stdout, not stderr
        print ($result.stdout | lines | where $it =~ '^(!|l\.[0-9])' | str join "\n")
        error make {msg: $"pdflatex failed on ($file) — see ($file | path parse | update extension log | path join)"}
    }
}

# Interactive shell in the same image, current directory mounted.
export def tex-sh [
    --image: string = "localhost/latex-rubric"
]: nothing -> nothing {
    (podman run --rm -it
        --userns=keep-id
        --volume $"($env.PWD):/work:z"
        --workdir /work
        --entrypoint /bin/bash
        $image)
}
