function compress --argument-names src --description 'Archive a file or directory to <name>.tar.gz beside it'
    # The trailing slash has to go, or `compress foo/` writes foo/.tar.gz (a hidden file inside the
    # directory being archived) instead of foo.tar.gz.
    set -l target (string trim --right --chars / -- $src)
    tar -czf $target.tar.gz $target
end
