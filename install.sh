#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.terminal-dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

backup_path() {
  local target="$1"
  local rel="${target#$HOME/}"

  if [ -L "$target" ]; then
    rm "$target"
    return
  fi

  if [ -e "$target" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    mv "$target" "$BACKUP_DIR/$rel"
  fi
}

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"
  backup_path "$target"
  ln -s "$source" "$target"
  printf 'linked %s -> %s\n' "$target" "$source"
}

ensure_oh_my_zsh_plugin() {
  local name="$1"
  local repo="$2"
  local dest="$HOME/.oh-my-zsh/custom/plugins/$name"

  if [ -d "$dest" ]; then
    printf 'plugin exists: %s\n' "$name"
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    printf 'missing git; install git, then clone %s into %s\n' "$repo" "$dest"
    return
  fi

  git clone "$repo" "$dest"
}

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf 'Oh My Zsh is not installed yet.\n'
  printf 'Install it first: sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"\n'
else
  ensure_oh_my_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
  ensure_oh_my_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
fi

link_file "$ROOT/zsh/.zshrc" "$HOME/.zshrc"
link_file "$ROOT/zsh/.zshenv" "$HOME/.zshenv"

link_file "$ROOT/config/ghostty/config" "$HOME/.config/ghostty/config"

mkdir -p "$HOME/.config/kitty"
for file in "$ROOT"/config/kitty/*; do
  link_file "$file" "$HOME/.config/kitty/$(basename "$file")"
done

mkdir -p "$HOME/.config/wezterm"
for file in "$ROOT"/config/wezterm/*; do
  link_file "$file" "$HOME/.config/wezterm/$(basename "$file")"
done

cat <<'MSG'

Done. Restart your terminal.

If icons look broken, install JetBrainsMono Nerd Font and select it in your terminal app.
If z, starship, or eza are missing, install the dependencies listed in README.md.
MSG
