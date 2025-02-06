return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",
            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            python = "/usr/local/bin/python",
            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- is_test_file = function(file_path)
            --   ...
            -- end,
            -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
            -- instances for files containing a parametrize mark (default: false)
            pytest_discover_instances = true,
          }),
        },
      })

      vim.keymap.set("n", "<leader>tS", "<cmd>Neotest summary<cr>", { desc = "Test summaries" })
      vim.keymap.set("n", "<leader>tO", "<cmd>Neotest output-panel<cr>", { desc = "Show test output panel" })
      vim.keymap.set("n", "<leader>to", "<cmd>Neotest output<cr>", { desc = "Show test output" })
      vim.keymap.set("n", "<leader>ts", "<cmd>Neotest stop<cr>", { desc = "Stop test" })
      vim.keymap.set(
        "n",
        "<leader>tF",
        '<cmd>lua require("neotest").run.run({vim.fn.expand("%"), strategy = "dap"})<cr>',
        { desc = "Run the current file test in debug mode" }
      )
      vim.keymap.set(
        "n",
        "<leader>tf",
        '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>',
        { desc = "Run the current file test" }
      )
      vim.keymap.set(
        "n",
        "<leader>tN",
        '<cmd>lua require("neotest").run.run({strategy = "dap"})<cr>',
        { desc = "Run the nearest test in debug mode" }
      )
      vim.keymap.set("n", "<leader>tn", '<cmd>lua require("neotest").run.run()<cr>', { desc = "Run the nearest test" })
      vim.keymap.set(
        "n",
        "<leader>tl",
        '<cmd>lua require("neotest").run.run_last()<cr>',
        { desc = "Run the last test again" }
      )
    end,
  },
}
