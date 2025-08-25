# ------------------------------------------------------------------
# git-repo <'private' | 'public'> <NEW_REPO_NAME> ['local']
# Streamlines adding a new repo to github
# ------------------------------------------------------------------
function git-repo --description 'Create a GitHub repo from the current directory'
    if test (count $argv) -lt 2 -o (count $argv) -gt 3
        echo "Usage: git-repo <'private' | 'public'> <NEW_REPO_NAME> ['local']"
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
        open "$url"
    end
end
