# ------------------------------------------------------------------
# dev <PROGRAM> [FOLDER] [ -a | --archive ]
# open a devlopment project
# ------------------------------------------------------------------
function dev --description 'Open ~/Developer/<folder> with PROGRAM (default: ranger)'
    argparse -n dev 'a/archive' -- $argv
    set -l extra (set -q _flag_archive && echo -a)
    set argv $argv   # argparse keeps the remaining positional args

    set -l program $project_explorer
    set -l base_dir $dev_dir

    if test (count $argv) -eq 0
        true
    else if test (count $argv) -eq 1
        if test -d "$base_dir/$argv[1]"
            set folder $argv[1]
        else
            set program $argv[1]
        end
    else
        set program $argv[1]
        set folder $argv[2]
    end

    set -l dir "$base_dir/$folder"

    if test -n "$folder" -a -d "$dir"
        cd $dir
        $program "$dir"
    else
        run $program $extra -from $base_dir
    end
end
