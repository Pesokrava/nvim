return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    key = function()
      return vim.loop.cwd()
    end,
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>hm", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Add to harpoon" })

    for i = 1, 4, 1 do
      vim.keymap.set("n", string.format("<leader>%s", i), function()
        harpoon:list():select(i)
      end, { desc = "Harpoon file" })
    end

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon previous" })
    vim.keymap.set("n", "<C-S-N>", function()
      harpoon:list():next()
    end, { desc = "Harpoon next" })
  end,
}
