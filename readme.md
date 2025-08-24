# My config.fish

A Fish shell configuration with custom functions, prompts, and development workflow tools.

#### Development Workflow
- **`dev.fish`** - Open development projects with specified programs
  - Supports archive flag for archived projects
  - Integrates with ranger file manager by default
  - Handles both program and folder arguments

- **`find-project.fish`** - Interactive project finder using fzf
  - Searches `~/Developer` directory for projects
  - Supports archive directory browsing
  - Filters out hidden and documentation files

- **`runon.fish`** - Execute commands in project directories
  - Run commands on selected projects via interactive picker
  - Supports both `-from` (directory) and `-on` (project) flags
  - Provides visual feedback for command execution

#### Shell Interface
- **`fish_prompt.fish`** - Custom prompt function (fallback when Starship unavailable)
  - Multi-line prompt with decorative elements
  - Shows user, current directory, and timestamp
  - Integrates vi-mode indicators, virtual environment, git status
  - Displays background jobs and battery status

## Key Features

- **Smart Development Workflow**: Quickly navigate and work with projects in `~/Developer`
- **System Information**: Displays OS, terminal, CPU, and memory info on startup
- **Tool Integration**: Seamless integration with ranger, nvim, zed, zoxide, starship, and fzf
- **Cross-Platform**: Supports macOS and Linux with appropriate fallbacks
- **Visual Prompt**: Rich, informative prompt with git integration and status indicators
- **Archive Support**: Special handling for archived development projects

## Dependencies

The configuration checks for and integrates with these external tools:
- `ranger` - File manager
- `nvim` - Text editor
- `zed` - IDE
- `zoxide` - Smart directory jumper
- `starship` - Cross-shell prompt
- `fzf` - Fuzzy finder

Missing tools are reported during shell startup with helpful warnings.
