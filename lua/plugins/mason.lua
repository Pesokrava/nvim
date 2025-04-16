return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "pyright",
        "flake8",
        "ruff"
      },
    },
  },
}
