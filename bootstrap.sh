#!/usr/bin/env bash
# Sets up a fresh Ubuntu/Debian machine. Safe to re-run: every step skips work that's already done.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing core packages..."
sudo apt update
sudo apt install -y zsh git curl gpg fzf zoxide eza unzip fontconfig

echo "==> Adding WezTerm's APT repo..."
if [ ! -f /etc/apt/sources.list.d/wezterm.list ]; then
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' |
    sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
  sudo apt update
fi
sudo apt install -y wezterm

echo "==> Installing Starship..."
if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

echo "==> Installing oh-my-zsh (unattended)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  omz_installer="$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  sh -c "$omz_installer" "" --unattended
fi

echo "==> Installing JetBrainsMono Nerd Font..."
# grep without -q reads all input, so fc-list never gets SIGPIPE (which pipefail would report as a miss).
if ! fc-list : family | grep -i "JetBrainsMono Nerd Font" >/dev/null; then
  FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"
  font_zip="$(mktemp --suffix=.zip)"
  curl -fL -o "$font_zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  mkdir -p "$FONT_DIR"
  unzip -o "$font_zip" -d "$FONT_DIR" >/dev/null
  rm -f "$font_zip"
  fc-cache -f
fi

echo "==> Symlinking dotfiles and cloning zsh plugins..."
"$DIR/install.sh"

echo "==> Setting zsh as default shell..."
current_shell="$(getent passwd "$(id -un)" | cut -d: -f7)"
if [ "${current_shell##*/}" != "zsh" ]; then
  chsh -s "$(command -v zsh)"
fi

echo ""
echo "Bootstrap done. Restart your terminal."
echo "NOT automated (install manually if needed on this machine): CUDA, NVM, Flutter, Android SDK, Bun, Cargo"
