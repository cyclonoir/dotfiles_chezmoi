function tex --description 'Compile a .tex file with pdflatex in a container; the PDF lands beside it'
    # tex FILE [--image NAME] [-q|--quiet] [-- PDFLATEX_FLAGS...]
    # The current directory is mounted at /work; --userns=keep-id keeps the output yours, not root's.
    argparse --min-args 1 image= q/quiet -- $argv; or return
    set -l file $argv[1]
    set -q _flag_image; or set _flag_image localhost/latex-rubric
    if not test -e $file
        echo "no such file in $PWD: $file" >&2
        return 1
    end

    # :z relabels the mount for SELinux and is ignored elsewhere.
    set -l output (podman run --rm --userns=keep-id --volume $PWD:/work:z --workdir /work $_flag_image \
        --interaction=nonstopmode --halt-on-error $argv[2..] $file)
    set -l code $status
    set -l pdf (path change-extension pdf $file)

    if test $code -eq 0
        set -q _flag_quiet; or printf '%s\n' $output
        echo (set_color green)built(set_color normal) $pdf
    else
        # pdflatex reports errors on stdout, not stderr
        printf '%s\n' $output | string match -r '^(!|l\.[0-9])'
        echo "pdflatex failed on $file - see "(path change-extension log $file) >&2
        return 1
    end
end
