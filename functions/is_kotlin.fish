function is_kotlin
    argparse 'd/debug' -- $argv
    or return 1
    set -l dir .
    test (count $argv) -ge 1 && set dir $argv[1]
    test -d $dir || return 1

    set -l kotlin_count (find $dir -maxdepth 4 -type f \( -name '*.kt' -o -name '*.kts' \) -print | wc -l)
    test $kotlin_count -eq 0 && return 1

    echo "kotlin project"
    if set -q _flag_debug
        echo "[kotlin files detected]"
        echo "Found $kotlin_count Kotlin files"
        find $dir -maxdepth 4 -type f \( -name '*.kt' -o -name '*.kts' \) -print
    end

    return 0
end
