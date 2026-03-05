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

-- Autocmd to assign groovy to Jenkinsfiles
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Jenkinsfile" },
  callback = function()
    vim.bo.filetype = "groovy"
  end,
})

vim.filetype.add({
  pattern = {
    [".*/kube/templates/.*%.yml"] = "jinja_yaml",
    [".*/kube/environment/.*%.yml"] = "jinja_yaml",
    [".*%.yml%.j2"] = "jinja_yaml",
    [".*%.yaml%.j2"] = "jinja_yaml",
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    local parsers = require("nvim-treesitter.parsers")
    local parser_config = parsers.get_parser_configs and parsers.get_parser_configs() or parsers
    parser_config.jinja_yaml = {
      install_info = {
        path = vim.fn.expand("~/bloomreach/repos/tree-sitter-jinja-yaml"),
        files = { "src/parser.c", "src/scanner.c" },
      },
      filetype = "jinja_yaml",
    }
  end,
})

vim.treesitter.language.register("jinja_yaml", { "jinja_yaml" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "jinja_yaml",
  callback = function(ev)
    local ok, err = pcall(vim.treesitter.start, ev.buf)
    if not ok then
      vim.notify("jinja_yaml treesitter parser not available: " .. err, vim.log.levels.WARN)
    end
  end,
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
