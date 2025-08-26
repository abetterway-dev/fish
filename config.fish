function fish_greeting
    set -g fullname (dscl . -read /Users/(whoami) RealName 2>/dev/null | sed -n '2p' | string trim)
    test -z "$fullname"; and set fullname (whoami)
    echo (set_color green)"Welcome back, $fullname!"(set_color normal)

    # Helper to trim command output
    function __sys
        eval $argv 2>/dev/null | string trim
    end

    switch (uname -s)
        case Darwin
            set -g os  "macOS "(__sys "sw_vers -productVersion")
            set -g cpu (__sys "sysctl -n machdep.cpu.brand_string")
            set -g mem (math -s1 (__sys "sysctl -n hw.memsize") / 1024 / 1024 / 1024)" GB"
            set -g cores (__sys "sysctl -n hw.ncpu")
        case Linux
            set -g os  (__sys "lsb_release -d | cut -f2")
            test -z "$os"; and set os (__sys "grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"'")
            set -g cpu (__sys "grep -m1 'model name' /proc/cpuinfo | cut -d: -f2-")
            set -g mem (math -s1 (__sys "grep -m1 MemTotal /proc/meminfo | awk '{print $2}'") / 1024 / 1024)" GB"
            set -g cores (__sys "grep -c processor /proc/cpuinfo")
    end

    echo "[System]";
    set_color brblue; printf "%-8s" "OS:"; set_color normal; echo $os
    set_color brblue; printf "%-8s" "Term:"; set_color normal; echo $TERM_PROGRAM
    set_color brblue; printf "%-8s" "CPU:"; set_color normal; printf "%s (%s cores)\n" $cpu $cores
    set_color brblue; printf "%-8s" "Memory:"; set_color normal; echo $mem

    set -g project_explorer ranger
    set -gx EDITOR nvim #used in ranger/rifle
    set -g editor nvim
    set -g ide zed
    set -g ai_cli aichat
    set -g programs_with_configs nvim fish starship git gh ranger node aichat awesome zed ghostty crush

    # Checks for required programs
    set -g required_programs $project_explorer $editor $ide $ai_cli fzf gh git sponge jq
    for prog in $required_programs
        if command -sq $prog
            true
        else
            printf "[";set_color yellow; printf "WARN"; set_color normal; printf "] missing program: "; set_color normal; echo $prog
        end
    end

    # Checks for ~/Development Folder and if not there set's it output
    set -g dev_dir ~/Developer
    set -l dev_archive $dev_dir/_archive

    for d in $dev_dir $dev_archive
        if not test -d $d
            mkdir -p $d
            and echo "[AUTO ACTION] - created $d"
            or begin
                printf "[";set_color yellow; printf "WARN"; set_color normal; printf "] no dev_dir"; set_color normal;
                echo "Could not create $d" >&2
                return 1
            end
        end
    end
end

# Alias zeditor as zed
if test (uname -s) != Darwin
    command -sq zeditor && alias zeditor='zed'
end

# Amend PATH
# Homebrew
if test -d /opt/homebrew/bin
    and not contains /opt/homebrew/bin $PATH
    set -gx PATH /opt/homebrew/bin $PATH
else if test -d /usr/local/bin
    and test -x /usr/local/bin/brew
    and not contains /usr/local/bin $PATH
    set -gx PATH /usr/local/bin $PATH
end

# Activate Fish Enhancements
if command -sq zoxide
    zoxide init fish | source
    function cd --wraps=cd
        z $argv
    end
end

set -l NERD_FONT_SAFE ghostty
if command -sq starship && contains -- "$TERM_PROGRAM" $NERD_FONT_SAFE
    starship init fish | source
end
