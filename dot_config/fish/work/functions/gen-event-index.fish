function gen-event-index --description 'Build the jediv2 event index page and open it'
    # --out  output HTML path (default: event-index.html in the generator's directory)
    argparse out= -- $argv; or return
    set -l dir $work_projects/jediv2-event-index-generator
    set -l target $dir/event-index.html
    set -q _flag_out; and set target (path resolve $_flag_out)

    uv run --project $dir $dir/gen_event_index.py --out $target
    and xdg-open $target 2>/dev/null
end
