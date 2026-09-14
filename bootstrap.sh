#!/usr/bin/env bash
set -e

echo "==> Installing core packages..."
sudo apt update
sudo apt install -y zsh git curl fzf zoxide eza unzip

echo "==> Adding WezTerm's APT repo..."
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install -y wezterm

echo "==> Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo "==> Installing oh-my-zsh (unattended)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Cloning zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" 2>/dev/null || true

echo "==> Installing JetBrainsMono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  curl -Lo /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -o /tmp/JetBrainsMono.zip -d "$FONT_DIR" >/dev/null
  fc-cache -f
  rm /tmp/JetBrainsMono.zip
fi

echo "==> Symlinking dotfiles..."
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$DIR/install.sh"

echo "==> Setting zsh as default shell..."
chsh -s "$(command -v zsh)"

echo ""
echo "Bootstrap done. Restart your terminal."
echo "NOT automated (install manually if needed on this machine): CUDA, NVM, Flutter, Android SDK, Bun"
