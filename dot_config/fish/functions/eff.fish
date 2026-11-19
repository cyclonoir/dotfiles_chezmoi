function eff --description 'Pick a file with fzf (bat preview) and open it in Neovim'
    set -l file (fzf --preview 'bat --style=numbers --color=always {}')
    test -n "$file"; and nvim $file
end
