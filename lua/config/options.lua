-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.nu = true
vim.g.autoformat = false
vim.o.autoread = true

-- ---------------------------------------------------------------------------
-- Clipboard
-- ---------------------------------------------------------------------------
-- Inside the Lima VM there is no display server, so xclip/xsel are non-
-- functional. Use OSC52 escape sequences instead: the terminal running on
-- macOS intercepts them and writes the payload directly to the macOS
-- clipboard. This works with iTerm2, kitty, WezTerm, and Ghostty.
--
-- On the macOS host itself, LazyVim's default provider (pbcopy/pbpaste) is
-- used, so we only override vim.g.clipboard when running under Lima.
--
-- LIMA_INSTANCE is set automatically by limactl shell / dev.sh.
if vim.env.LIMA_INSTANCE ~= nil then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
  -- Allow Neovim to sync with the system clipboard via the OSC52 provider.
  vim.opt.clipboard = "unnamedplus"
end
