# dotfiles

My macOS setup for the terminal (Ghostty + zsh) and VS Code.

## Setup on a new Mac

1. Install [Ghostty](https://ghostty.org) and [VS Code](https://code.visualstudio.com) and move both into `/Applications`.
2. Clone this repo and run the install script:

   ```bash
   git clone https://github.com/Atfas/dotfiles.git ~/Documents/dotfiles
   cd ~/Documents/dotfiles
   ./install.sh
   ```

3. Open a new Ghostty window. Done.

The script:

- installs Homebrew if it's missing
- installs the terminal tools and the font from the `Brewfile`
- installs the `zsh-shift-select` plugin
- links the config files in this repo to where Ghostty, zsh, Starship and VS Code expect them
- installs the VS Code extensions from `vscode/extensions.txt`

Existing config files are never deleted. They are renamed to `<file>.backup-<date>`.

The configs are **linked**, not copied, so editing `~/.zshrc`, the Ghostty config or VS Code settings edits the file in this repo. Commit the change and push.

## Terminal: `terminal-ghostty/`

| File | Goes to |
|---|---|
| `ghostty/config` | `~/.config/ghostty/config` |
| `ghostty/themes/rosetta` | `~/.config/ghostty/themes/rosetta` |
| `zsh/.zshrc` | `~/.zshrc` |
| `starship/starship.toml` | `~/.config/starship.toml` |

**Ghostty**
- Theme: **Rosetta**, recreated from the Rosetta VS Code theme's terminal colours
- Font: JetBrains Mono (Ghostty's built-in default)
- `Shift + arrows` selects text at the prompt
- `Cmd + Shift + Left/Right` selects to the start or end of the line
- `Cmd + A` select all, `Cmd + C` copy, `Cmd + V` paste

**Shell (zsh)**

| Tool | What it does |
|---|---|
| [Starship](https://starship.rs) | Prompt: `user:folder branch changes`, then `❯` on the next line (red after a failed command). Uses colour names, so it follows the Ghostty theme |
| [zsh-shift-select](https://github.com/jirutka/zsh-shift-select) | Select text you're typing with Shift + arrows |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Grey suggestions from history. `→` accepts |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Commands turn green (valid) or red (unknown) as you type |
| [fzf](https://github.com/junegunn/fzf) | `Ctrl + R` fuzzy history search, `Ctrl + T` fuzzy file picker |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `z <name>` jumps to a folder you've been to before |
| [eza](https://github.com/eza-community/eza) | `ls` with folders first. `ll` shows details and git status per file |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git in the terminal. Run `lazygit` inside a repo, `?` shows the keys |

**Machine-specific settings.** PATHs for languages and tools (Java, Python, Haskell, …) differ between machines, so they're not in this repo. Put them in `~/.zshrc.local`. `.zshrc` loads it automatically if it exists.

## VS Code: `vscode/`

| File | Goes to |
|---|---|
| `settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `extensions.txt` | installed by `install.sh` |

- Theme: **Rosetta Theme** (Steven Kustov)
- Icons: **Material Icon Theme**
- Font: **JetBrains Mono**, with ligatures, in the editor and the built-in terminal
- Sidebar on the right, auto save, git auto-fetch, `Cmd + scroll` to zoom
- Transparent window with GlassIt

The extensions list covers languages (Python, Java, C/C++, Go, Haskell, Prolog, Astro), Jupyter, Docker and Dev Containers, Copilot, Prettier, Error Lens, Live Server, Live Share, Markdown Preview Enhanced, Rainbow CSV and the PDF viewer.

To update the list after installing or removing extensions:

```bash
code --list-extensions > ~/Documents/dotfiles/vscode/extensions.txt
```

## Updating the tools list

After adding a new Homebrew tool, add it to `Brewfile`. Then on any machine:

```bash
brew bundle --file=~/Documents/dotfiles/Brewfile
```
