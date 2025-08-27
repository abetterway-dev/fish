function is_swift --description 'true if folder is a Swift/Xcode project'
    argparse 'd/debug' -- $argv
    or return 1
    set -l dir .
    test (count $argv) -ge 1 && set dir $argv[1]
    test -d $dir || return 1

    set -l swift_count (find $dir -maxdepth 4 -name '*.swift' -print | wc -l)
    test $swift_count -eq 0 && return 1

    echo "swift project"
    if set -q _flag_debug
        echo "[swift files detected]"
        echo "Found $swift_count Swift files"
        find $dir -maxdepth 4 -name '*.swift' -print
    end
    return 0
end
