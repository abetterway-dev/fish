# ------------------------------------------------------------------
# git-readme <NEW_REPO_NAME>
# Streamlines creating or updating a README.md file
# ------------------------------------------------------------------
function git-readme --description 'Generate README.md for current folder'
    if test (count $argv) -eq 0
            echo "Usage: git-readme <text>"
            return 1
    end
    set -l repo_name $argv[1]
    echo "# $repo_name" > README.md
end
