function configs --description 'Find config folders for installed programs'
    set -l programs nvim fish starship git gh ranger node aichat awesome zed ghostty
    set -l program_configs

    for prog in $programs
        if command -sq $prog
            switch $prog
                case nvim
                    set -a program_configs "$prog ~/.config/nvim"
                case fish
                    set -a program_configs "$prog ~/.config/fish"
                case starship
                    set -a program_configs "$prog ~/.config/starship.toml"
                case git
                    set -a program_configs "$prog ~/.gitconfig"
                case gh
                    set -a program_configs "$prog ~/.config/gh"
                case ranger
                    set -a program_configs "$prog ~/.config/ranger/rifle.conf"
                case node
                    set -a program_configs "$prog ~/.npmrc"
                case aichat
                    if test (uname) = Darwin
                        set -a program_configs "$prog /Library/Application Support/aichat/config.yaml"
                    else
                        set -a program_configs "$prog ~/.config/aichat/config.yaml"
                    end
                case awesome
                    set -a program_configs "$prog ~/.config/awesome"
                case zed
                    if test (uname) = Darwin
                        set -a program_configs "$prog ~/Library/Application Support/Zed"
                    else
                        set -a program_configs "$prog ~/.config/zed"
                    end
                case ghostty
                    if test (uname) = Darwin
                        set -a program_configs "$prog ~/Library/Application Support/com.mitchellh.ghostty/config"
                    else
                        set -a program_configs "$prog ~/.config/ghostty/config"
                    end
            end
        end
    end

    if test (count $program_configs) -gt 0
        set -l selected (printf '%s\n' $program_configs | fzf | cut -d ' ' -f2-)
        if test -n "$selected"
            set -l resolved (string replace -a -- '~' "$HOME" "$selected")
            if test -f "$resolved"
                $editor "$resolved"
            else if test -d "$resolved"
                cd "$resolved"
                $ide "$resolved"
            else
                echo "$resolved"
            end
        end
    else
        echo "No config folders found for the specified programs."
    end
end
