function n --wraps nvim --description 'Neovim on the current directory, or on the given files'
    if test (count $argv) -eq 0
        nvim .
    else
        nvim $argv
    end
end
