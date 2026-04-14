# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Works on macOS and Linux.

## Structure

```
dotfiles/
├── install.sh                 # Bootstrap script (installs stow, backs up conflicts, stows packages)
├── nvim/.config/nvim/         # Neovim — LazyVim-based config
├── kitty/.config/kitty/       # Kitty terminal emulator
├── tmux/.config/tmux/         # Tmux + custom Catppuccin status modules
├── git/.gitconfig             # Git global config
└── zsh/.zshrc.example         # Zsh reference template (not managed by stow)
```

Each top-level directory is a **stow package**. Running `stow nvim` from `~/dotfiles` creates a symlink at `~/.config/nvim` pointing into this repo.

## Installation

Before installing, check [PREREQUISITES.md](PREREQUISITES.md) for the full list of required tools and runtimes.

```bash
git clone git@github.com:Pesokrava/nvim.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:
1. Install GNU Stow if missing (via `brew`, `apt`, `pacman`, or `dnf`)
2. Back up any existing configs that would conflict (to `~/.dotfiles-backup-<timestamp>/`)
3. Stow all packages, creating these symlinks:

| Symlink | Target |
|---|---|
| `~/.config/nvim` | `~/dotfiles/nvim/.config/nvim` |
| `~/.config/kitty` | `~/dotfiles/kitty/.config/kitty` |
| `~/.config/tmux` | `~/dotfiles/tmux/.config/tmux` |
| `~/.gitconfig` | `~/dotfiles/git/.gitconfig` |

## Zsh

`~/.zshrc` is **not** managed by stow — it's configured manually per machine since it typically contains oh-my-zsh setup, machine-specific paths, and secrets. See `zsh/.zshrc.example` for a reference template. API keys should live in `~/.env.llm` (sourced by the example).

## Cross-platform notes

- **Kitty**: Font size shortcuts use `ctrl+` (works on both macOS and Linux). `macos_option_as_alt` is silently ignored on Linux.
- **Tmux**: Clipboard copy uses `pbcopy` on macOS and `xclip` on Linux (auto-detected). Battery status bar widget only appears when battery hardware is present.
- **Neovim clipboard**: OSC 52 escape sequences are used automatically when running inside a Lima VM, over SSH, or when no native clipboard tool (`xclip`, `xsel`, `wl-copy`) is detected.

## Neovim

Built on [LazyVim](https://github.com/LazyVim/LazyVim) with extras for Go, Python, Rust, and TypeScript. Key customizations:

- **LSP**: pyright, gopls, cssls, yamlls
- **DAP**: Python (debugpy), Go (delve), Rust (codelldb), Flutter/Dart
- **Testing**: neotest with pytest, gotestsum, and Rust runners
- **Navigation**: harpoon, fzf-lua, tmux-navigate
- **Theme**: Catppuccin (Frappe dark / Latte light toggle)
