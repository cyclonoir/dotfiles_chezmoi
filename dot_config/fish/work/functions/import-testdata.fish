function import-testdata --description 'Load a job (and with --with-materials its reference data) with TestDataFromSql'
    # import-testdata JOB SITE [options]
    #   JOB    job number, e.g. 1111-0453
    #   SITE   Butler, Fallon, Hope, Juarez, LakeCity, Salem
    # --v2              load from the V2 (JEDIv2) database instead of V1
    # --with-materials  also load material and v1/v2 reference data
    # --format          sql (default), codegen, json
    # --output          console, database (default), file
    # --output-path     file path (required if --output is file)
    argparse --min-args 2 --max-args 2 v2 with-materials format= output= output-path= -- $argv
    or return
    set -l job $argv[1]
    set -l site $argv[2]
    set -q _flag_format; or set _flag_format sql
    set -q _flag_output; or set _flag_output database
    set -l verb load-v1-job
    set -l ref_verb load-v1-references
    if set -q _flag_v2
        set verb load-v2-job
        set ref_verb load-v2-references
    end

    set -l project $work_projects/jediv2/Source/DevTools/TestDataFromSql/TestDataFromSql.csproj
    set -l out --site $site --output-format $_flag_format --output-type $_flag_output
    set -l args run --project $project -- $verb --site $site --job $job \
        --output-format $_flag_format --output-type $_flag_output
    set -q _flag_output_path; and set -a args --output-path $_flag_output_path
    dotnet $args

    if set -q _flag_with_materials
        dotnet run --project $project -- load-material-references $out
        dotnet run --project $project -- $ref_verb $out
    end
end
