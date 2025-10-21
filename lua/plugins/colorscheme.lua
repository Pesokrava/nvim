return {
  -- { "ellisonleao/gruvbox.nvim" },

  -- {
  --   "sainnhe/sonokai",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.sonokai_style = "andromeda"
  --     vim.g.sonokai_enable_italic = true
  --   end,
  -- },
  --
  -- {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },

  --   { "tanvirtin/monokai.nvim" },
  --
  --   -- Configure LazyVim to load gruvbox
  --   {
  --     "LazyVim/LazyVim",
  --     opts = {
  --       colorscheme = "monokai_pro",
  --     },
  --   },
}
