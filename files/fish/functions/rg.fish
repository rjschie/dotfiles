function rg --wraps=rg --description 'rg with global ignore file'
    command rg --ignore-file=$CONFIG/ripgrep/global_ignore $argv
end
