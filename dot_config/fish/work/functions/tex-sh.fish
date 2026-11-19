function tex-sh --description 'Interactive shell in the LaTeX image, current directory mounted'
    argparse image= -- $argv; or return
    set -q _flag_image; or set _flag_image localhost/latex-rubric
    podman run --rm -it --userns=keep-id --volume $PWD:/work:z --workdir /work --entrypoint /bin/bash $_flag_image
end
