return {
  "nvim-flutter/flutter-tools.nvim",
  cond = function()
    return vim.fn.executable("flutter") == 1
  end,
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("flutter-tools").setup({
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
    })
  end,
}
