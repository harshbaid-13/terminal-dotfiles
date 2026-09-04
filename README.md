# Harsh's Terminal Dotfiles

This folder contains the shareable parts of the terminal setup:

- Zsh shell config with Oh My Zsh
- `zsh-autosuggestions` and `zsh-syntax-highlighting`
- `zoxide` for the `z` directory-jump feature
- Starship prompt
- `eza` aliases with icons
- Ghostty, WezTerm, and Kitty appearance/config files
- JetBrainsMono Nerd Font expectation for icons/glyphs

It intentionally does not include shell history, SSH keys, tokens, PEM files, Git credentials, or machine-specific cache folders.

## Quick Install

Clone this repo, then run:

```bash
cd terminal-dotfiles
./install.sh
```

Restart the terminal after installation.

## Ubuntu/Debian Dependencies

Install the basic packages first:

```bash
sudo apt update
sudo apt install -y zsh git curl fzf zoxide eza kitty wezterm
```

Install Starship:

```bash
curl -sS https://starship.rs/install.sh | sh
```

Install Oh My Zsh if it is not already installed:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the required Oh My Zsh plugins:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

Set Zsh as the default shell:

```bash
chsh -s "$(command -v zsh)"
```

## Font

Install `JetBrainsMono Nerd Font`. Without a Nerd Font, icons in the prompt, `eza`, Kitty, and WezTerm may show as boxes.

Download from:

```text
https://www.nerdfonts.com/font-downloads
```

After installing it, select `JetBrainsMono Nerd Font` in the terminal app.

## What The Installer Does

`install.sh` creates symlinks from this folder into the home directory:

- `zsh/.zshrc` -> `~/.zshrc`
- `zsh/.zshenv` -> `~/.zshenv`
- `config/ghostty/config` -> `~/.config/ghostty/config`
- `config/kitty/*` -> `~/.config/kitty/*`
- `config/wezterm/*` -> `~/.config/wezterm/*`

Existing files are moved into a timestamped backup folder:

```text
~/.terminal-dotfiles-backup-YYYYMMDD-HHMMSS
```

## Notes

- The `z` command comes from `zoxide`, initialized by `eval "$(zoxide init zsh)"`.
- The prompt comes from Starship, initialized by `eval "$(starship init zsh)"`.
- The `ls` and `la` aliases use `eza --icons`.
- Flutter, Android SDK, CUDA, Bun, NVM, and Cargo paths are included with guards where possible, but those tools must be installed separately if needed.
