function load-testdata --description 'Pick a jediv2 test data set with fzf and load it'
    # --skip-build: run dotnet with --no-build
    argparse skip-build -- $argv; or return
    set -l project $work_projects/jediv2/Source/DevTools/TestDataLoader/TestDataLoader.csproj
    set -l build_flag
    set -q _flag_skip_build; and set build_flag --no-build

    set -l selected (dotnet run $build_flag --project $project -- list | fzf)
    test -n "$selected"; or return
    dotnet run $build_flag --project $project -- load $selected
end
