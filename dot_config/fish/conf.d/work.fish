# Work machines only (chezmoi leaves this file and ../work/ out elsewhere): work functions and
# abbreviations.

# Where work repos are cloned; the functions in ../work/functions build their paths from it.
set -g work_projects ~/Documents/Projects

set -p fish_function_path $__fish_config_dir/work/functions

if status is-interactive
    # Run these from a jediv2 checkout.
    abbr -a services dotnet run --project Source/RemoteServices/WebApi/WebApi.csproj
    abbr -a client dotnet run --project Source/Jedi/Jedi.csproj
    abbr -a devup podman compose --env-file .env -f Infrastructure/docker/compose.dev-environment.yml up -d --wait
    abbr -a devdown podman compose --env-file .env -f Infrastructure/docker/compose.dev-environment.yml down -v

    abbr -a deps uv run --project $work_projects/py_scripts $work_projects/py_scripts/project_dependency.py
end
