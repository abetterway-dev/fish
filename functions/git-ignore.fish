# ------------------------------------------------------------------
# git-readme <NEW_REPO_NAME>
# Streamlines creating or updating a .gitignore file
# ------------------------------------------------------------------
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
$ai_cli $prompt | string trim -r | sed '1s/^```//; $s/```$//' | sponge .gitignore
echo "AI-generated rules written to .gitignore"
end
