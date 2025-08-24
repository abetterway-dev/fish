# ------------------------------------------------------------------
# run <CMD> [CMDS...] [ -on <FOLDER> &| -from <FOLDER> ]
# Run commands on a different directory
# ------------------------------------------------------------------
function run --description 'Run commands on a folder via find-project'
    if test (count $argv) -eq 0
        printf 'Usage: run <cmd> [cmd …] -from <folder> -on <sub>\n' >&2
        return 1
    end

    set -l cmds
    set -l from_dir $dev_dir
    set -l on_sub

    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -from
                test (count $argv) -le $i && printf 'run: -from needs a folder\n' >&2 && return 1
                set from_dir $argv[(math $i + 1)]
                set i (math $i + 2)
            case -on
                test (count $argv) -le $i && printf 'run: -on needs a project\n' >&2 && return 1
                set on_sub $argv[(math $i + 1)]
                set i (math $i + 2)
            case '*'
                set -a cmds $argv[$i]
                set i (math $i + 1)
        end
    end

    set -l chosen
    if test -n "$on_sub"
        set chosen "$from_dir/$on_sub"
        cd "$from_dir/$on_sub"
    else
        set chosen (find-project $from_dir)
        test -z "$chosen" && return 1
    end

    if not command -sq $cmds[1]
        printf 'Command not found: %s\n' $cmd >&2
        return 1
    end

    echo (set_color green)"→ running $cmds on $chosen"(set_color normal)
    $cmds "$chosen"
end
