function zipdir --description 'Archive the current directory to <name>.7z, without bin, obj, .git or node_modules'
    7z a (path basename $PWD).7z . -r '-xr!bin' '-xr!obj' '-xr!.git' '-xr!node_modules'
end
