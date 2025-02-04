-- complete dap config
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "Weissle/persistent-breakpoints.nvim",
    "mfussenegger/nvim-dap-python",
    "ldelossa/nvim-dap-projects",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    local dpy_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(dpy_path)
    require("nvim-dap-virtual-text").setup({})
    require("persistent-breakpoints").setup({
      load_breakpoints_event = { "BufReadPost" },
    })
    require("nvim-dap-projects").search_project_config()
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --   dapui.close()
    -- end
    vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

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
    vim.keymap.set("n", "<leader>dh", "<cmd>DapVirtualTextToggle<cr>", { desc = "Hide dap virtual text"})
    vim.keymap.set("n", "<leader>dl", function()
      dap.toggle_breakpoint(nil, nil, vim.fn.input("Log message > "))
    end, { desc = "Toggle logpoint" })
    vim.keymap.set("n", "<leader>de", "<cmd>lua require('dapui').eval()<cr>", { desc = "Eval current cursor position" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue in debug mode" })
    vim.keymap.set("n", "<leader>ds", dap.close, { desc = "Stop debugging" })
    vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Next" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "<leader>duo", dapui.open, { desc = "Open debug windows" })
    vim.keymap.set("n", "<leader>duc", dapui.close, { desc = "Close debug windows" })
  end,
}
