-- Build the ensure_installed list dynamically based on available runtimes.
-- Tools for languages whose runtime is not on PATH are skipped.
local tools = {
  "stylua",
  "shellcheck",
  "shfmt",
}

local has = vim.fn.executable

if has("python3") == 1 then
  vim.list_extend(tools, { "debugpy", "pyright", "flake8" })
end

if has("go") == 1 then
  vim.list_extend(tools, { "delve", "gopls" })
end

if has("cargo") == 1 then
  vim.list_extend(tools, { "codelldb" })
end

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = tools,
    },
  },
}
