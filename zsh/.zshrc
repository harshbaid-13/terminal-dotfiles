# ==========================================
# ENVIRONMENT VARIABLES
# ==========================================
export TERM="xterm-256color"
export PATH="$HOME/.local/bin:/usr/local/cuda-13.2/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-13.2/lib64:$LD_LIBRARY_PATH"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

# ==========================================
# OH MY ZSH
# ==========================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="" # Left blank because Starship handles the prompt
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

if [ -s "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# ==========================================
# HISTORY
# ==========================================
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# ==========================================
# ALIASES
# ==========================================
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias la="eza -la --icons"
else
  alias la="ls -la"
fi

# ==========================================
# TOOL INITIALIZATIONS
# ==========================================
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Zoxide provides the `z` command.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Starship prompt.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Flutter and Android SDK paths.
[ -d "$HOME/flutter/bin" ] && export PATH="$HOME/flutter/bin:$PATH"
export ANDROID_HOME="$HOME/android-sdk"
[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
[ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Bun completions and binary path.
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"
