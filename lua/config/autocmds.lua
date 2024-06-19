-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Disable autoformat for lua files
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "py" },
--   callback = function()
--     vim.b.autoformat = false
--   end,
-- })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  command = "setlocal shiftwidth=4 tabstop=4",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescript",
  command = "setlocal shiftwidth=4 tabstop=4",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescriptreact",
  command = "setlocal shiftwidth=4 tabstop=4",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "scss",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "gruvbox",
--   callback = function()
--     -- Customize function highlighting to remove bold
--     local function_hl = vim.api.nvim_get_hl_by_name("Function", true)
--     function_hl.bold = nil
--     vim.api.nvim_set_hl(0, "Function", function_hl)
--
--     -- Define a darker green color (modify the hex value as desired)
--     local dark_green = "#16ac3c"
--
--     -- Customize string highlighting to use the darker green color
--     vim.api.nvim_set_hl(0, "String", { fg = dark_green, italic = true })
--   end,
-- })
