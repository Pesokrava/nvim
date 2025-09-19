return {
  "olimorris/codecompanion.nvim",
  opts = {
    log_level = "DEBUG",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>at", ":CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "Open Code Companion" },
    { "<leader>ae", ":CodeCompanionChat /explain<CR>", mode = { "v" }, desc = "Explain code" },
    { "<leader>aa", ":CodeCompanionChat Add<CR>", mode = { "v" }, desc = "Add to code companion context" },
    { "<leader>ai", ":CodeCompanionChat<CR>", mode = { "n", "v" }, desc = "Inline assistant" },
    { "<leader>ap", ":CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "Code Companion Action Pallete" },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              commands = {
                default = {
                  "gemini",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-flash",
                },
                pro = {
                  "gemini",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-pro",
                },
              },
              defaults = {
                auth_method = "vertex-ai",
                mcpServers = {},
                timeout = 20000, -- 20 seconds
              },
            })
          end,
        },
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = "openai_api_key",
            },
            schema = {
              model = {
                default = "gpt-4.1",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "gemini_cli",

          keymaps = {
            send = {
              modes = { n = { "<CR>", "<C-a>" }, i = "<C-a>" },
              opts = {},
            },
            close = {
              modes = { n = "<C-c>", i = "<C-c>" },
              opts = {},
            },
            -- Add further custom keymaps here
          },
        },
        inline = {
          adapter = "openai",
        },
      },
    })
  end,
}
