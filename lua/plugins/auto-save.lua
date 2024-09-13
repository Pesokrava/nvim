return {
  "pocco81/auto-save.nvim",
  config = function()
    vim.api.nvim_set_keymap("n", "<leader>a", ":ASToggle<CR>", {})
  end,
}
