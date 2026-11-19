function generate-db --description 'Run the jediv2 DatabaseGenerator'
    # --verb             generate (default), migrate, augment, current-db-version, generate-pocos,
    #                    delete-test-databases
    # --database         All (default), Jedi2, Legacy, Hangfire
    # --recreate-db      create the initial database
    # --skip-backup      skip creating a database backup
    # --skip-build       run dotnet with --no-build
    # --env-file         path to the .env file (default .env)
    # --command-timeout  SQL command timeout in seconds (default 30)
    # --root-dir         jediv2 checkout (default $work_projects/jediv2)
    argparse verb= database= recreate-db skip-backup skip-build env-file= 'command-timeout=!_validate_int' root-dir= -- $argv
    or return
    set -q _flag_verb; or set _flag_verb generate
    set -q _flag_database; or set _flag_database All
    set -q _flag_env_file; or set _flag_env_file .env
    set -q _flag_command_timeout; or set _flag_command_timeout 30
    set -q _flag_root_dir; or set _flag_root_dir $work_projects/jediv2

    set -l project $work_projects/jediv2/Source/DevTools/DatabaseGenerator/DatabaseGenerator.csproj
    set -l args run --project $project
    set -q _flag_skip_build; and set -a args --no-build
    set -a args -- $_flag_verb --root-dir $_flag_root_dir --env-file $_flag_env_file \
        --database $_flag_database --command-timeout $_flag_command_timeout
    set -q _flag_recreate_db; and set -a args --recreate-db
    set -q _flag_skip_backup; and set -a args --skip-backup

    dotnet $args
end
