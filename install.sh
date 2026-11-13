#!/usr/bin/env bash
# Sets up the terminal (Ghostty + zsh) and VS Code from this repo.
# Safe to run more than once. Existing files are backed up, not deleted.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$1"; }

# Symlink $1 (file in repo) to $2 (where the app expects it).
# If something else is already at $2, it is renamed to $2.backup-<date>.
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "   already linked: $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.backup-$STAMP"
    echo "   backed up: $dest -> $dest.backup-$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "   linked: $dest"
}

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# 2. Terminal tools and font
info "Installing packages from Brewfile"
brew bundle --file="$DOTFILES/Brewfile"

# 3. zsh-shift-select plugin (not on Homebrew)
PLUGIN_DIR="$HOME/.local/share/zsh/plugins/zsh-shift-select"
if [ ! -f "$PLUGIN_DIR/zsh-shift-select.plugin.zsh" ]; then
  info "Installing zsh-shift-select"
  mkdir -p "$(dirname "$PLUGIN_DIR")"
  git clone --depth 1 https://github.com/jirutka/zsh-shift-select.git "$PLUGIN_DIR"
fi

# 4. Terminal config files
info "Linking terminal config"
link "$DOTFILES/terminal-ghostty/zsh/.zshrc"               "$HOME/.zshrc"
link "$DOTFILES/terminal-ghostty/starship/starship.toml"   "$HOME/.config/starship.toml"
link "$DOTFILES/terminal-ghostty/ghostty/config"           "$HOME/.config/ghostty/config"
link "$DOTFILES/terminal-ghostty/ghostty/themes/rosetta"   "$HOME/.config/ghostty/themes/rosetta"

# 5. VS Code
info "Setting up VS Code"
link "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

CODE="$(command -v code || true)"
VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
[ -z "$CODE" ] && [ -x "$VSCODE_BIN" ] && CODE="$VSCODE_BIN"

if [ -n "$CODE" ]; then
  while read -r ext; do
    [ -z "$ext" ] && continue
    "$CODE" --install-extension "$ext" >/dev/null && echo "   extension: $ext"
  done < "$DOTFILES/vscode/extensions.txt"
else
  warn "VS Code not found in /Applications. Install it, then run this script again for the extensions."
fi

info "Done. Open a new Ghostty window (or press Cmd+Shift+, to reload Ghostty)."
