# Markdown Browser Preview — Design Spec

**Date:** 2026-04-22

## Goal

Add keymaps to Neovim that, when triggered in a markdown buffer on macOS, convert the current file to self-contained GFM-styled HTML using pandoc and open it in the default browser. A second keymap cleans up all generated preview files from `/tmp`.

## Context

- Config: LazyVim-based, Lua, located at `nvim/.config/nvim/`
- Existing markdown plugin: `render-markdown.nvim` (in-buffer rendering only)
- Available tool: `pandoc` (already installed via Homebrew)
- OS: macOS (uses `open` to launch browser)

## Platform Guard

The entire feature (functions and keymaps) is only registered when `vim.fn.has("mac") == 1`. On non-macOS systems the plugin spec loads normally but registers nothing, so it is safe in a shared dotfiles repo.

## Architecture

Two Lua functions are added to the existing `lua/plugins/markdown.lua` file inside an `if vim.fn.has("mac") == 1` guard.

**`open_in_browser()`** function:

1. Reads the current buffer's full file path.
2. Validates the file is saved (has a path and exists on disk).
3. Shells out to `pandoc --standalone --from=gfm --to=html5 --embed-resources --resource-path=<file_dir> --metadata title:<filename> --css=<css_path> -o /tmp/nvim-md-preview-<hash>.html <filepath>`.
4. Opens the output file via `open` (macOS).
5. Shows a notification on success or failure.

**`clean_previews()`** function:

1. Finds all `/tmp/nvim-md-preview-*.html` files via `vim.fn.glob`.
2. Deletes each with `vim.fn.delete`.
3. Reports the count deleted via `vim.notify`.

The HTML output is fully self-contained (`--embed-resources`) — no external network requests needed after generation. GitHub-like CSS is applied via pandoc's `--css` with a bundled stylesheet downloaded into the Neovim data directory on first use.

Each generated file gets a unique name derived from the source path hash (`nvim-md-preview-<hash>.html`) so multiple files can coexist if the user previews several documents.

## Keymaps

Both keymaps are normal mode, filetype-scoped to `markdown`, registered inside the `if vim.fn.has("mac") == 1` guard:

- `<leader>mo` — "markdown open" — runs `open_in_browser()`
- `<leader>mx` — "markdown clean" — runs `clean_previews()`

Registered as `keys` entries in the LazyVim plugin spec inside `markdown.lua`.

## Files Modified

| File | Change |
|------|--------|
| `lua/plugins/markdown.lua` | Add `open_in_browser` + `clean_previews` functions and keymap entries, wrapped in macOS guard |

No new files are created. No new plugin dependencies are added.

## Error Handling

| Condition | Behavior |
|-----------|----------|
| Buffer has no file path (unsaved) | `vim.notify` warning: "Save the file first" |
| Not on macOS | Functions not registered; keymaps not created |
| pandoc exits non-zero | `vim.notify` error with stderr output |
| `open` fails | `vim.notify` error with exit code |
| No preview files to clean | `vim.notify` info: "No preview files found" |

## CSS Styling

Pandoc's `--embed-resources` will inline everything. We use a GitHub Markdown CSS file fetched from `sindresorhus/github-markdown-css` (raw GitHub URL) and stored at `~/.local/share/nvim/github-markdown.css`. The fetch happens on first use via `vim.fn.system("curl -sL ... -o ...")`; if it fails, pandoc falls back to its default styling.

## Success Criteria

- Pressing `<leader>mo` in a markdown buffer opens a styled HTML page in the default browser
- The HTML renders GFM correctly (tables, task lists, fenced code blocks)
- Images with relative paths resolve relative to the source file
- Unsaved buffers show a helpful error rather than crashing
- Pressing `<leader>mx` deletes all `/tmp/nvim-md-preview-*.html` files and reports the count
- Neither keymap nor function is registered on non-macOS systems
