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
        case Linux
            set -g os  (__sys "lsb_release -d | cut -f2")
            test -z "$os"; and set os (__sys "grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"'")
            set -g cpu (__sys "grep -m1 'model name' /proc/cpuinfo | cut -d: -f2-")
            set -g mem (math -s1 (__sys "grep -m1 MemTotal /proc/meminfo | awk '{print $2}'") / 1024 / 1024)" GB"
    end

    echo "[System]";
    set_color brblue; printf "%-8s" "OS:"; set_color normal; echo $os
    set_color brblue; printf "%-8s" "Term:"; set_color normal; echo $TERM_PROGRAM
    set_color brblue; printf "%-8s" "CPU:"; set_color normal; echo $cpu
    set_color brblue; printf "%-8s" "Memory:"; set_color normal; echo $mem


    # Checks for preferred programs
    set wanted ranger nvim zed zoxide starship fzf aichat gh git sponge
    for prog in $wanted
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

    set -g project_explorer ranger
    set -gx EDITOR nvim #used in ranger/rifle
    set -g editor nvim
    set -g ide zed
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
if command -sq starship
    starship init fish | source
end
