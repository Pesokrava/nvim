return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "codecompanion" },
  config = function()
    require("render-markdown").setup({})

    if vim.fn.has("mac") ~= 1 then
      return
    end

    local css_path = vim.fn.stdpath("data") .. "/github-markdown.css"
    local function ensure_css()
      if vim.fn.filereadable(css_path) == 1 then
        return css_path
      end
      local url = "https://raw.githubusercontent.com/sindresorhus/github-markdown-css/main/github-markdown.css"
      vim.fn.system({ "curl", "-sL", url, "-o", css_path })
      if vim.v.shell_error ~= 0 then
        vim.notify("markdown-preview: failed to download CSS, using pandoc default", vim.log.levels.WARN)
        return nil
      end
      return css_path
    end

    local function open_in_browser()
      local filepath = vim.fn.expand("%:p")
      if filepath == "" or vim.fn.filereadable(filepath) ~= 1 then
        vim.notify("markdown-preview: save the file first", vim.log.levels.WARN)
        return
      end

      local filename = vim.fn.fnamemodify(filepath, ":t:r")
      local file_dir = vim.fn.fnamemodify(filepath, ":h")
      local hash = vim.fn.sha256(filepath):sub(1, 8)
      local out = "/tmp/nvim-md-preview-" .. hash .. ".html"

      local css = ensure_css()
      local cmd = {
        "pandoc",
        "--standalone",
        "--from=gfm",
        "--to=html5",
        "--embed-resources", -- requires pandoc >= 2.19 (older versions used --self-contained)
        "--resource-path=" .. file_dir,
        "--metadata=title:" .. filename,
      }
      if css then
        table.insert(cmd, "--css=" .. css)
      end
      table.insert(cmd, "-o")
      table.insert(cmd, out)
      table.insert(cmd, filepath)

      local result = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify("markdown-preview: pandoc error\n" .. result, vim.log.levels.ERROR)
        return
      end

      local open_result = vim.fn.system({ "open", out })
      if vim.v.shell_error ~= 0 then
        vim.notify("markdown-preview: failed to open browser\n" .. open_result, vim.log.levels.ERROR)
        return
      end

      vim.notify("markdown-preview: opened " .. out, vim.log.levels.INFO)
    end

    local function clean_previews()
      local files = vim.fn.glob("/tmp/nvim-md-preview-*.html", false, true)
      if #files == 0 then
        vim.notify("markdown-preview: no preview files found", vim.log.levels.INFO)
        return
      end
      local deleted = 0
      for _, f in ipairs(files) do
        if vim.fn.delete(f) == 0 then deleted = deleted + 1 end
      end
      vim.notify("markdown-preview: deleted " .. deleted .. "/" .. #files .. " preview file(s)", vim.log.levels.INFO)
    end

    local group = vim.api.nvim_create_augroup("MarkdownPreview", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "markdown",
      callback = function()
        vim.keymap.set("n", "<leader>mo", open_in_browser, {
          buffer = true,
          desc = "Markdown: open in browser",
        })
        vim.keymap.set("n", "<leader>mx", clean_previews, {
          buffer = true,
          desc = "Markdown: clean preview files",
        })
      end,
    })
  end,
}
