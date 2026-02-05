return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "pyright",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "stylua",
        "delve",
        "gopls",
      },
    },
  },
}
