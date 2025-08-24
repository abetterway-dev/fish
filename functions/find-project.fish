# ------------------------------------------------------------------
# find-project [base_dir]   [ -a | --archive ]
# Produce the list of directories/files to show in fzf.
# ------------------------------------------------------------------
function find-project --description 'Searches Folder to Open with a Program'
    argparse -n find-project 'a/archive' -- $argv
    set argv $argv   # argparse leaves remaining args

    set -l base_dir (test -n "$argv[1]" && echo "$argv[1]" || echo .)

    if set -q _flag_archive
        set base_dir "$base_dir/_archive"
        if not test -d "$base_dir"
            printf 'No Archive Found\n' >&2
            return 1
        end
    end

    set -l choices (
        find "$base_dir" -mindepth 1 -maxdepth 1 \
             ! -name '_*' ! -name '.*' -type d |
        while read -l d
            set -l bn (basename "$d")
            set -l files (find "$d" -maxdepth 1 -type f \
                          ! -name '.*' ! -name '*.txt' ! -name '*.md')
            if test (count $files) -gt 0
                printf '%s\n' $bn
            else
                set -l subs (find "$d" -mindepth 1 -maxdepth 1 -type d \
                             ! -name '_*' ! -name '.*')
                for s in $subs
                    printf '%s/%s\n' $bn (basename "$s")
                end
            end
        end
    )

    test -z "$choices"; and begin
            printf 'No projects to open\n' >&2
            return 1
        end

    set -l choice (
        printf '%s\n' $choices |
        fzf --prompt="Select folder: "
    )

    test -n "$choice" && cd "$base_dir/$choice" && echo "$base_dir/$choice"
end
