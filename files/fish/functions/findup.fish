function findup --description 'Walk up the tree looking for files matching a glob'
    if test (count $argv) -eq 0
        echo "usage: findup <pattern>" >&2
        return 1
    end
    set -l d $PWD
    while test "$d" != /
        for m in (command ls -d $d/$argv[1] 2>/dev/null)
            echo $m
        end
        set d (dirname "$d")
    end
end
