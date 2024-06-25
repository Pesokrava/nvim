return {
  {
    "vuki656/package-info.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("package-info").setup()
      -- Show dependency versions
      vim.keymap.set({ "n" }, "<LEADER>ns", require("package-info").show, { silent = true, noremap = true, desc = "Show npm dependency version" })

      -- Hide dependency versions
      vim.keymap.set({ "n" }, "<LEADER>nc", require("package-info").hide, { silent = true, noremap = true, desc = "Hide npm dependency version" })

      -- Toggle dependency versions
      vim.keymap.set({ "n" }, "<LEADER>nt", require("package-info").toggle, { silent = true, noremap = true, desc = "Toggle npm dependency versions" })

      -- Update dependency on the line
      vim.keymap.set({ "n" }, "<LEADER>nu", require("package-info").update, { silent = true, noremap = true, desc = "Update npm dependency on line" })

      -- Delete dependency on the line
      vim.keymap.set({ "n" }, "<LEADER>nd", require("package-info").delete, { silent = true, noremap = true, desc = "Delete npm dependency on line" })

      -- Install a new dependency
      vim.keymap.set({ "n" }, "<LEADER>ni", require("package-info").install, { silent = true, noremap = true, desc = "Install new npm dependency" })

      -- Install a different dependency version
      vim.keymap.set({ "n" }, "<LEADER>np", require("package-info").change_version, { silent = true, noremap = true, desc = "Install different npm dependency version" })
    end,
  },
}
