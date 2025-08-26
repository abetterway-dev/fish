function extfish_settings
    set_color blue
    echo -n "Projects in: "
    set_color normal
    echo $dev_dir

    set_color green
    echo -n "Editor: "
    set_color normal
    echo -n "$editor, "

    set_color green
    echo -n "IDE: "
    set_color normal
    echo -n "$ide, "

    set_color green
    echo -n "AI: "
    set_color normal
    echo -n "$ai_cli, "

    set_color green
    echo -n "Explorer: "
    set_color normal
    echo $project_explorer

    set_color purple
    echo -n "Configs: "
    set_color normal
    for prog in $programs_with_configs
        echo -n "$prog "
    end

    echo ""

    set_color red
    echo -n "Required: "
    set_color normal
    for prog in $required_programs
        echo -n "$prog "
    end

    echo ""

    # --- required programs check ---
    for prog in $required_programs
        if not command -sq $prog
            set_color red
            echo -n "[FIX] missing program: "
            set_color normal
            echo $prog
        end
    end

    # --- optional programs check ---
    set -l optional_programs starship zoxide
    for prog in $optional_programs
        if not command -sq $prog
            set_color yellow
            echo -n "[WARN] missing program: "
            set_color normal
            echo $prog
        end
    end
end
