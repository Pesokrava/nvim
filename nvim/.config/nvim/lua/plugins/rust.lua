return {
  -- rustaceanvim is installed by the lang.rust extra, we just override opts here
  {
    "mrcjkb/rustaceanvim",
    cond = function()
      return vim.fn.executable("cargo") == 1
    end,
    opts = {
      server = {
        on_attach = function(_, bufnr)
          -- <leader>cR is consistent with LazyVim's code action pattern
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Rust Code Action", buffer = bufnr })

          -- <leader>dR opens the rustaceanvim debuggables picker
          -- (avoids conflict with existing <leader>dr = clear all breakpoints)
          vim.keymap.set("n", "<leader>dR", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })

          -- <leader>dE opens the rustaceanvim runnables picker
          vim.keymap.set("n", "<leader>dE", function()
            vim.cmd.RustLsp("runnables")
          end, { desc = "Rust Runnables", buffer = bufnr })
        end,
      },
    },
  },
}
