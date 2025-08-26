# My config.fish

A Fish shell configuration with custom functions, prompts, and development workflow tools.

---
## New Commands

### Navigation
<details>
<summary><code>find-project</code> – returns project folder path</summary>

**Dependencies**
- `fzf`
</details>
<details>
<summary><code>run</code> – runs cmds on different directory</summary>

**Dependencies**
- `find-project` (fish function)
</details>
<details>
<summary><code>configs</code> – opens configuration files/folders</summary>

**Dependencies**
- `fzf`

**Customization**
Add or remove items in `$programs`, then toggle `$prog`.

**Notes**
- Uses `$editor` for files
- Uses `$ide` for directories
</details>

### Development
<details>
<summary><code>dev</code> – opens programming projects</summary>

**Dependencies**
- `run` (fish function)

**Notes**
- Uses `$dev_dir` for default projects folder
- Uses `$project_explorer` for default program to open projects
</details>


### Project Management

### Package Management

### Version Control
<details>
<summary><code>git-repo</code> – streamlines creating a new github repo</summary>

**Dependencies**
- `gh`
- `git`
- `git-readme` (fish function)
- `git-ignore` (fish function)
</details>
<details>
<summary><code>git-readme</code> – streamlines creating/updating a readme.md</summary>

**Dependencies**
- `sponge`

**Notes**
- Uses `$ai_cli` with cmd "<prompt>" for ai tasks
</details>
<details>
<summary><code>git-ignore</code> – streamlines creating/updating a .gitignore</summary>

**Dependencies**
- `sponge`

**Notes**
- Uses `$ai_cli` with cmd "<prompt>" for ai tasks
</details>

### Automation & LLM support
---
## Flavors

### workstation

### vm

### server

### minimal
