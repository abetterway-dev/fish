function git-repo --description 'Create a GitHub repo from the current directory'
    if test (count $argv) -lt 2 -o (count $argv) -gt 3
        echo "Usage: github-repo <public|private> <repo-name>"
        return 1
    end

    set -l visibility $argv[1]
    set -l repo_name $argv[2]
    set -l islocal false

    if test (count $argv) -eq 3
        switch $argv[3]
            case local
                set islocal true
            case '*'
                echo "Third argument must be 'local' (or omitted)"
                return 1
        end
    end

    switch $visibility
        case public private
            # valid
        case '*'
            echo "First argument must be 'public' or 'private'"
            return 1
    end

    if test -d .git
        echo "Directory already contains a .git folder. Aborting."
        return 1
    end

    if count (ls | string match -i 'readme.md') -eq 0
        echo "README.md not found – running git-readme…"
        git-readme $repo_name
    end

    if not test -f .gitignore
        echo "Generating a .gitignore file..."
        git-ignore
    end

    git init
    git add .
    git commit -m "Initial commit"
    git branch -M main

    if $islocal
        echo "Local git repository initialized."
    else
        set -l gh_args --source=.
        if test $visibility = "private"
            set gh_args $gh_args --private
        else
            set gh_args $gh_args --public
        end

        set -l out (gh repo create $repo_name $gh_args 2>&1)
        set -l url "$out.git"

        if test -z "$url"
            echo "Failed to create repository. GitHub CLI output:"
            echo $out
            echo $url
            return 1
        end

        echo "Repository created:"
        echo "$url"
        git push -u origin main
        echo "Repository updated with Initial commit"
    end
end

function git-ignore --description 'Generate .gitignore for current folder via aichat'

    echo    "Generating a .gitignore file"
    set -l target (pwd)

    # Build a concise file-tree string (depth 1) to give the model context
    set -l tree (string join '\n' (find . -maxdepth 1 -type f -o -type d | sort))

    set -l prompt "
You are a cross-platform .gitignore generator.
Look at the following file/folder list:

$tree

Produce a concise .gitignore that ignores common OS/editor/build artefacts
(macOS, Linux, Windows) plus anything obviously machine-specific
from the list above.  Output ONLY the lines that belong in .gitignore.
Always include:
.vscode/
.idea/
*.swp
*.swo
*~
*.tmp
*.bak
.env
.dev.env
.DS_Store
"

# write the AI response (without backticks) to a temp file
aichat $prompt | string trim -r | sed '1s/^```//; $s/```$//' | sponge .gitignore
echo "AI-generated rules written to .gitignore"
end

function git-readme --description 'Generate README.md for current folder'
    if test (count $argv) -eq 0
            echo "Usage: git-readme <text>"
            return 1
    end
    set -l repo_name $argv[1]
    echo "# $repo_name" > README.md
end
