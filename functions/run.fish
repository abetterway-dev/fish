# ------------------------------------------------------------------
# run <CMD> [CMDS...] [ -on <FOLDER> &| -from <FOLDER> ] [-g]
# Run commands on a different directory
# ------------------------------------------------------------------
function run --description 'Run commands on a folder via find-project'
    if test (count $argv) -eq 0
        printf 'Usage: run <cmd> [cmd …] -from <folder> -on <sub>\n' >&2
        return 1
    end

    set -l from_dir $dev_dir
    set -l on_sub

    echo "$argv"
    argparse 'a' 'g' 'from=' 'on=' -- $argv
    or return 1

    # if --on || --from
    if test -n "$_flag_on"
        set on_sub $_flag_on
        set chosen "$from_dir/$on_sub"
        cd "$from_dir/$on_sub"
    else if test -n "$_flag_from"
        set from_dir $_flag_from
        if test -n "$_flag_a"
            set from_dir "$from_dir/_archive"
        end
        set chosen (find-project $from_dir)
        test -z "$chosen" && return 1
    end

    if not command -sq $argv
        printf 'Command not found: %s\n' $argv[1] >&2
        return 1
    end

    # kotlin and swift guard
    if test -n "$_flag_g"
        echo "guarding"
        if is_kotlin $chosen; and test "$argv[1]" = "$ide"
            echo "found kotlin, opening in Android Studio rather than $ide"
            set argv "android"
        else if is_swift $chosen; and test "$argv[1]" = "$ide"
            echo "found swift, opening in Xcode rather than $ide"
            set argv "xed"
        end
    end

    echo (set_color green)"→ running $argv on $chosen"(set_color normal)
    $argv $chosen
end
