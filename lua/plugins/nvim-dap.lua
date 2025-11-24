-- complete dap config
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "igorlfs/nvim-dap-view",
    "Weissle/persistent-breakpoints.nvim",
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
    "ldelossa/nvim-dap-projects",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapview = require("dap-view")

    -- Enable debug logging
    dap.set_log_level("DEBUG")
    -- Use the project's venv Python for Loomi Agentic API
    local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
    if vim.fn.filereadable(venv_python) == 1 then
      require("dap-python").setup(venv_python)
    else
      -- Fallback to Mason's debugpy
      local dpy_path = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
      require("dap-python").setup(dpy_path)
    end
    require("nvim-dap-virtual-text").setup({})
    require("dap-go").setup()
    require("persistent-breakpoints").setup({
      load_breakpoints_event = { "BufReadPost" },
    })

    -- Loomi Agentic API: Direct debugpy adapter (bypasses nvim-dap-python)
    -- This works with the debugpy server started by `make dev-api-debug`
    dap.adapters.loomi_debugpy = {
      type = "server",
      host = "127.0.0.1",
      port = 5678,
    }

    table.insert(dap.configurations.python, {
      type = "loomi_debugpy",
      request = "attach",
      name = "Attach to Loomi API (port 5678)",
      justMyCode = false,
      pathMappings = { {
        localRoot = vim.fn.getcwd(),
        remoteRoot = vim.fn.getcwd(),
      } },
    })

    require("nvim-dap-projects").search_project_config()

    -- Setup nvim-dap-view
    dapview.setup({
      auto_toggle = false,
    })
    vim.fn.sign_define("DapBreakpoint", { text = "💚", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "❤️️", texthl = "", linehl = "", numhl = "" })

    -- key bindings
    vim.keymap.set(
      "n",
      "<leader>dt",
      "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>",
      { desc = "Toggle breakpoint at current line" }
    )
    vim.keymap.set(
      "n",
      "<leader>dT",
      "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>",
      { desc = "Toggle conditional breakpoint at current line" }
    )
    vim.keymap.set(
      "n",
      "<leader>dr",
      "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>",
      { desc = "Clear all breakpoints" }
    )
    vim.keymap.set("n", "<leader>dh", "<cmd>DapVirtualTextToggle<cr>", { desc = "Hide dap virtual text" })
    vim.keymap.set("n", "<leader>dl", function()
      dap.toggle_breakpoint(nil, nil, vim.fn.input("Log message > "))
    end, { desc = "Toggle logpoint" })
    vim.keymap.set("n", "<leader>da", "<cmd>DapViewWatch<cr>", { desc = "Add expression under cursor to watch" })
    vim.keymap.set("n", "<leader>de", function()
      require("dap.ui.widgets").hover()
    end, { desc = "Evaluate expression under cursor (inline)" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue in debug mode" })
    vim.keymap.set("n", "<leader>ds", dap.close, { desc = "Stop debugging" })
    vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Next" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "<leader>duo", "<cmd>DapViewOpen<cr>", { desc = "Open debug windows" })
    vim.keymap.set("n", "<leader>duc", "<cmd>DapViewClose<cr>", { desc = "Close debug windows" })
    vim.keymap.set("n", "<leader>dut", "<cmd>DapViewToggle<cr>", { desc = "Toggle debug windows" })
  end,
}
