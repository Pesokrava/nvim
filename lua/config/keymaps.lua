-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap_set = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "wO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
vim.keymap.set("n", "wo", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete into black hole" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete into black hole" })

vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "J", "mzJ`z`")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank into system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank into system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Refactor" })

vim.keymap.set("n", "<leader>cui", "<cmd>TransferInit<cr>", { desc = "Init transfer in the current repo" })
vim.keymap.set("n", "<leader>cuf", "<cmd>DiffRemote<cr>", { desc = "Remote diff of the current file" })
vim.keymap.set("n", "<leader>cuu", "<cmd>TransferUpload<cr>", { desc = "Upload current file to remote" })
vim.keymap.set("n", "<leader>cud", "<cmd>TransferDownload<cr>", { desc = "Download current file from remote" })
-- vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
  "n",
  "<leader>fh",
  "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,-u<cr>",
  { desc = "Find all files" }
)
vim.keymap.set(
  "n",
  "<leader>fG",
  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { desc = "Live grep with args" }
)

-- autoimport
vim.keymap.set("n", "<leader>i", require("lspimport").import, { noremap = true, desc = "Autoimport" })

-- quick kebinding to hide virtual text
local isLspDiagnosticsVisible = true
vim.keymap.set("n", "<leader>cx", function()
  isLspDiagnosticsVisible = not isLspDiagnosticsVisible
  vim.diagnostic.config({
    virtual_text = isLspDiagnosticsVisible,
    underline = isLspDiagnosticsVisible,
  })
end, { desc = "Hide virtual text LSP" })


-- below is setup for toggling neotree position

-- Path to the file that stores the Neo-tree position
local position_file = vim.fn.stdpath('config') .. '/neotree_position.txt'

-- Function to read the Neo-tree position from the file
local function read_neotree_position()
  local file = io.open(position_file, "r")
  if file then
    local position = file:read("*a")
    file:close()
    return position
  end
  return 'left' -- Default position if file does not exist
end

-- Function to write the Neo-tree position to the file
local function write_neotree_position(position)
  local file = io.open(position_file, "w")
  if file then
    file:write(position)
    file:close()
  end
end

-- Function to toggle Neo-tree position between left and right
function Toggle_neotree_position()
  -- Read the current position from the file
  local current_position = read_neotree_position()

  -- Toggle position
  if current_position == 'left' then
    -- Close current Neo-tree and open it on the right

    vim.cmd("Neotree close")
    vim.cmd("Neotree filesystem reveal right")
    write_neotree_position('right')
  else
    -- Close current Neo-tree and open it on the left
    vim.cmd("Neotree close")
    vim.cmd("Neotree filesystem reveal left")
    write_neotree_position('left')
  end
end

-- Key mapping to toggle Neo-tree position with <leader>rt
vim.api.nvim_set_keymap('n', '<leader>rt', ':lua Toggle_neotree_position()<CR>', { noremap = true, silent = true })

