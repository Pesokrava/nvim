-- Build the servers table dynamically based on available runtimes.
local has = vim.fn.executable

local servers = {
  -- Global keymaps for all LSP servers
  ["*"] = {
    keys = {
      { "K", "i<CR><Esc>", mode = "n", noremap = true },
    },
  },
  cssls = {
    settings = {
      css = {
        validate = true,
      },
      less = {
        validate = true,
      },
      scss = {
        validate = true,
      },
    },
  },
  yamlls = {
    -- Have to add this for yamlls to understand that we support line folding
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      new_config.settings.yaml.schemas = vim.tbl_deep_extend(
        "force",
        new_config.settings.yaml.schemas or {},
        require("schemastore").yaml.schemas()
      )
    end,
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          -- Must disable built-in schemaStore support to use
          -- schemas from SchemaStore.nvim plugin
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
      },
    },
  },
}

if has("python3") == 1 then
  servers.pyright = {
    settings = {
      pyright = {},
      python = {},
    },
  }
end

if has("go") == 1 then
  servers.gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          ST1000 = false, -- Disable package comment requirement
        },
        staticcheck = true, -- Keep staticcheck enabled
        gofumpt = true,
      },
    },
  }
  servers.golangci_lint_ls = {
    filetypes = { "go", "gomod" },
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = servers,
    },
  },
}
