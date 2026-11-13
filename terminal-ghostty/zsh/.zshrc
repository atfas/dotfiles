# Homebrew
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Machine-specific settings (PATHs for languages/tools) live outside the repo
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Shift + arrows select text at the prompt
source ~/.local/share/zsh/plugins/zsh-shift-select/zsh-shift-select.plugin.zsh
# Bind the standard key codes directly (needed for Ghostty)
for s w in '^[[1;2D' backward-char '^[[1;2C' forward-char '^[[1;2H' beginning-of-line '^[[1;2F' end-of-line '^[[1;4D' backward-word '^[[1;4C' forward-word; do
  bindkey -M emacs $s shift-select::$w; bindkey -M shift-select $s shift-select::$w
done
zle_highlight=(region:bg=blue,fg=white)

# Prompt
eval "$(starship init zsh)"

# Smarter navigation and history
eval "$(zoxide init zsh)"          # `z <folder>` jumps to a folder you've visited before
source <(fzf --zsh)                # Ctrl+R = fuzzy history search, Ctrl+T = fuzzy file picker

# Nicer ls
alias ls='eza --group-directories-first'
alias ll='eza -l --git --group-directories-first'   # shows git status per file

# Grey suggestions from history (Right arrow to accept)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Commands turn green/red as you type — must stay LAST
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
