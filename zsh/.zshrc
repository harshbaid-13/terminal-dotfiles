# ==========================================
# ENVIRONMENT VARIABLES
# ==========================================
export PATH="$HOME/.local/bin:$PATH"

# CUDA: prefer the version-independent /usr/local/cuda symlink, else the newest /usr/local/cuda-X.Y.
if [ -d /usr/local/cuda/bin ]; then
  CUDA_HOME="/usr/local/cuda"
else
  cuda_dirs=(/usr/local/cuda-[0-9]*(N/nOn))
  CUDA_HOME="${cuda_dirs[1]}"
  unset cuda_dirs
fi
if [ -n "$CUDA_HOME" ] && [ -d "$CUDA_HOME/bin" ]; then
  export CUDA_HOME
  export PATH="$CUDA_HOME/bin:$PATH"
  export LD_LIBRARY_PATH="$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
else
  unset CUDA_HOME
fi

# Flatpak apps; fall back to the XDG default so system dirs aren't dropped when the variable is unset.
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

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

# fzf key bindings and completion. `fzf --zsh` needs fzf 0.48+; older Debian/Ubuntu packages ship the scripts instead.
if command -v fzf >/dev/null 2>&1; then
  if fzf_init="$(fzf --zsh 2>/dev/null)"; then
    eval "$fzf_init"
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
  fi
  unset fzf_init
fi

# Starship prompt.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Flutter and Android SDK paths.
if [ -d "$HOME/flutter/bin" ]; then
  export PATH="$HOME/flutter/bin:$PATH"
fi
if [ -d "$HOME/android-sdk" ]; then
  export ANDROID_HOME="$HOME/android-sdk"
  [ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
  [ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$ANDROID_HOME/platform-tools:$PATH"
fi

# Bun completions and binary path.
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
  [ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Keep the final status clean so the first prompt doesn't show an error when optional tools are absent.
true
