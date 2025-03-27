return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = function(_, opts)
    local fzf = require("fzf-lua")
    local config = fzf.config
    config.defaults.keymap.fzf["alt-j"] = "down"
    config.defaults.keymap.fzf["alt-k"] = "up"
  end
}
