# Prerequisites

Everything needed for a fully working setup from a fresh machine. Items marked
**auto** are installed automatically by Mason, lazy.nvim, or TPM on first launch.

## Core (required)

| Tool | macOS | Linux (apt) | Notes |
|---|---|---|---|
| git | `brew install git` | `sudo apt install git` | Bootstraps lazy.nvim, TPM |
| Neovim >= 0.10 | `brew install neovim` | [github releases](https://github.com/neovim/neovim/releases) or `sudo apt install neovim` | OSC 52 clipboard needs 0.10+ |
| tmux >= 3.1 | `brew install tmux` | `sudo apt install tmux` | XDG config dir support needs 3.1+ |
| Kitty | `brew install --cask kitty` | [kitty.app](https://sw.kovidgoez.net/kitty/) | Or substitute your own terminal |
| GNU Stow | auto-installed by `install.sh` | auto-installed by `install.sh` | |
| Hack Nerd Font Mono | `brew install --cask font-hack-nerd-font` | Download from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) | Required by kitty and tmux status bar |

## Language runtimes

Only install what you need. **Language support is auto-detected** — if a runtime
binary is not on `PATH`, the corresponding LSP server, DAP adapter, test runner,
and Mason tools are silently skipped. No per-machine configuration is needed to
disable a language; simply don't install its runtime.

| Runtime | Binary checked | macOS | Linux (apt) | What gets enabled |
|---|---|---|---|---|
| Python 3 | `python3` | `brew install python` | `sudo apt install python3 python3-pip python3-venv` | pyright, debugpy, pytest, flake8 |
| Go | `go` | `brew install go` | [go.dev/dl](https://go.dev/dl/) | gopls, golangci-lint-ls, delve, gotestsum |
| Rust | `cargo` | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | same | rustaceanvim, codelldb, cargo test |
| Node.js + npm | — (always on) | `brew install node` or via `nvm` | `sudo apt install nodejs npm` or via `nvm` | cssls, yamlls, eslint, TypeScript LSP |
| Flutter / Dart | `flutter` | [flutter.dev](https://docs.flutter.dev/get-started/install) | same | flutter-tools, flutter DAP |

## CLI tools

| Tool | macOS | Linux (apt) | Used by |
|---|---|---|---|
| ripgrep | `brew install ripgrep` | `sudo apt install ripgrep` | fzf-lua file search |
| fzf | `brew install fzf` | `sudo apt install fzf` | `kc()` kubectl context switcher in zsh |
| kubectl | `brew install kubectl` | [kubernetes.io](https://kubernetes.io/docs/tasks/tools/) | Only if doing Kubernetes work |
| xclip | n/a | `sudo apt install xclip` | tmux + nvim clipboard on Linux (X11) |

## Python packages (project-level, not system-wide)

Install these in your project virtualenv or globally via `pip install --user`:

| Package | Used by |
|---|---|
| `pytest` | neotest Python runner |
| `ipdb` | `set_trace()` / `clear_trace()` keymaps in nvim |
| `golangci-lint` | golangci-lint-langserver (Go linting) |

## Auto-managed (no manual install needed)

### Mason (Neovim — installs on first launch)

Mason tools are also auto-detected. Only tools for available runtimes are
installed:

| Always | With `python3` | With `go` | With `cargo` |
|---|---|---|---|
| stylua, shellcheck, shfmt | debugpy, pyright, flake8 | delve, gopls | codelldb |

### lazy.nvim (Neovim plugins — installs on first launch)

All plugins listed in `nvim/.config/nvim/lua/plugins/` are auto-installed.

### TPM (tmux plugins — installs on first `prefix + I`)

sunaku/tmux-navigate, catppuccin/tmux, tmux-nerd-font-window-name,
tmux-which-key, tmux-cpu, tmux-battery, tmux-primary-ip, tmux-resurrect,
tmux-sessionx
