# Harsh's Terminal Dotfiles

This repo contains the shareable parts of the terminal setup:

- Zsh shell config with Oh My Zsh
- `zsh-autosuggestions` and `zsh-syntax-highlighting`
- `zoxide` for the `z` directory-jump feature
- Starship prompt
- `eza` aliases with icons
- WezTerm config (tab bar, workspaces, key bindings)
- JetBrainsMono Nerd Font for icons/glyphs

It intentionally does not include shell history, SSH keys, tokens, PEM files, Git credentials, or machine-specific cache folders.

## Quick Start (fresh Ubuntu/Debian machine)

```bash
git clone git@github.com:harshbaid-13/terminal-dotfiles.git ~/terminal-dotfiles
cd ~/terminal-dotfiles
./bootstrap.sh
```

Restart the terminal afterwards. `bootstrap.sh` is safe to re-run; each step skips work that's already done.

Requires Ubuntu 24.04+ or Debian 13+ — older releases don't package `eza` and `zoxide`, so the apt step fails.

## What `bootstrap.sh` Does

1. Installs apt packages: `zsh git curl gpg fzf zoxide eza unzip fontconfig`
2. Adds WezTerm's APT repo (`apt.fury.io/wez`) and installs `wezterm`
3. Installs Starship (if not already on `PATH`)
4. Installs Oh My Zsh unattended (if `~/.oh-my-zsh` doesn't exist)
5. Downloads JetBrainsMono Nerd Font into `~/.local/share/fonts/JetBrainsMono` (if not already installed)
6. Runs `install.sh`
7. Sets zsh as the login shell (if it isn't already)

Not automated — install these yourself if a machine needs them: CUDA, NVM, Flutter, Android SDK, Bun, Cargo.

## What `install.sh` Does

Use this on its own if the dependencies are already installed.

- Clones `zsh-autosuggestions` and `zsh-syntax-highlighting` into `~/.oh-my-zsh/custom/plugins/` (skipped if Oh My Zsh is missing or the plugin already exists)
- Creates symlinks from this repo into the home directory:
  - `zsh/.zshrc` -> `~/.zshrc`
  - `zsh/.zshenv` -> `~/.zshenv`
  - `config/wezterm/*` -> `~/.config/wezterm/*`

Existing non-symlink files are moved into a timestamped backup folder:

```text
~/.terminal-dotfiles-backup-YYYYMMDD-HHMMSS
```

Because these are symlinks, editing `~/.config/wezterm/keys.lua` (or any linked file) edits the file in this repo directly. Commit and push to carry the change to other machines; after pulling on another machine no re-install is needed unless new files were added.

## Notes

- The `z` command comes from `zoxide`, initialized by `eval "$(zoxide init zsh)"`.
- The prompt comes from Starship, initialized by `eval "$(starship init zsh)"`.
- The `ls` and `la` aliases use `eza --icons` (plain `ls` fallback if `eza` is missing).
- CUDA, Flutter, Android SDK (`~/android-sdk`), Bun, NVM, and Cargo paths are only added when those tools are present, so the shell starts cleanly on machines without them.
- `fzf` key bindings (`Ctrl+R` history, `Ctrl+T` files, `Alt+C` cd) and completion come from `eval "$(fzf --zsh)"`; on fzf older than 0.48 it falls back to the Debian-packaged scripts.
