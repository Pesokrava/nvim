# Markdown Browser Preview Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `<leader>mo` (open in browser) and `<leader>mx` (clean previews) keymaps to markdown buffers on macOS, using pandoc to generate self-contained GFM HTML.

**Architecture:** A macOS guard wraps two Lua functions and their keymaps inside the existing `markdown.lua` plugin spec. pandoc converts the current buffer to standalone HTML with embedded CSS and resources; `open` launches it in the default browser. A separate function glob-deletes all `/tmp/nvim-md-preview-*.html` files.

**Tech Stack:** Neovim (LazyVim), Lua, pandoc (already installed), macOS `open`, GitHub Markdown CSS (sindresorhus/github-markdown-css via curl on first use)

---

### Task 1: Ensure CSS asset is fetched on first use

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/markdown.lua`

- [ ] **Step 1: Read the current file**

Open `nvim/.config/nvim/lua/plugins/markdown.lua`. Current content:
```lua
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "codecompanion" }
}
```

- [ ] **Step 2: Add CSS helper at top of the plugin config function**

Replace the file contents with the following. This adds a helper that downloads the CSS once into the Neovim data directory and returns the path (or `nil` if unavailable):

```lua
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "codecompanion" },
  config = function()
    require("render-markdown").setup({})

    if vim.fn.has("mac") ~= 1 then
      return
    end

    -- CSS asset: download once on first use
    local css_path = vim.fn.stdpath("data") .. "/github-markdown.css"
    local function ensure_css()
      if vim.fn.filereadable(css_path) == 1 then
        return css_path
      end
      local url = "https://raw.githubusercontent.com/sindresorhus/github-markdown-css/main/github-markdown.css"
      local result = vim.fn.system({ "curl", "-sL", url, "-o", css_path })
      if vim.v.shell_error ~= 0 then
        vim.notify("markdown-preview: failed to download CSS, using pandoc default", vim.log.levels.WARN)
        return nil
      end
      return css_path
    end

  end,
}
```

- [ ] **Step 3: Verify the file is valid Lua (no syntax errors)**

Run:
```bash
nvim --headless -c "luafile nvim/.config/nvim/lua/plugins/markdown.lua" -c "qa" 2>&1
```
Expected: no output (no errors). If errors appear, fix them before continuing.

---

### Task 2: Implement `open_in_browser()` function

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/markdown.lua`

- [ ] **Step 1: Add the `open_in_browser` function inside the macOS guard**

After the `ensure_css` function definition (and still inside `config = function()`), add:

```lua
    local function open_in_browser()
      local filepath = vim.fn.expand("%:p")
      if filepath == "" or vim.fn.filereadable(filepath) ~= 1 then
        vim.notify("markdown-preview: save the file first", vim.log.levels.WARN)
        return
      end

      local filename = vim.fn.fnamemodify(filepath, ":t:r")
      local file_dir = vim.fn.fnamemodify(filepath, ":h")
      -- unique output filename per source file
      local hash = vim.fn.sha256(filepath):sub(1, 8)
      local out = "/tmp/nvim-md-preview-" .. hash .. ".html"

      local css = ensure_css()
      local cmd = {
        "pandoc",
        "--standalone",
        "--from=gfm",
        "--to=html5",
        "--embed-resources",
        "--resource-path=" .. file_dir,
        "--metadata=title:" .. filename,
        "-o", out,
        filepath,
      }
      if css then
        table.insert(cmd, "--css=" .. css)
      end

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
```

- [ ] **Step 2: Verify no syntax errors**

```bash
nvim --headless -c "luafile nvim/.config/nvim/lua/plugins/markdown.lua" -c "qa" 2>&1
```
Expected: no output.

---

### Task 3: Implement `clean_previews()` function

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/markdown.lua`

- [ ] **Step 1: Add the `clean_previews` function after `open_in_browser`**

Still inside the macOS guard in `config = function()`, add:

```lua
    local function clean_previews()
      local files = vim.fn.glob("/tmp/nvim-md-preview-*.html", false, true)
      if #files == 0 then
        vim.notify("markdown-preview: no preview files found", vim.log.levels.INFO)
        return
      end
      for _, f in ipairs(files) do
        vim.fn.delete(f)
      end
      vim.notify("markdown-preview: deleted " .. #files .. " preview file(s)", vim.log.levels.INFO)
    end
```

- [ ] **Step 2: Verify no syntax errors**

```bash
nvim --headless -c "luafile nvim/.config/nvim/lua/plugins/markdown.lua" -c "qa" 2>&1
```
Expected: no output.

---

### Task 4: Register keymaps

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/markdown.lua`

- [ ] **Step 1: Add keymaps after both function definitions (still inside macOS guard)**

```lua
    vim.api.nvim_create_autocmd("FileType", {
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
```

- [ ] **Step 2: Verify no syntax errors**

```bash
nvim --headless -c "luafile nvim/.config/nvim/lua/plugins/markdown.lua" -c "qa" 2>&1
```
Expected: no output.

- [ ] **Step 3: Review the complete final file**

The complete `markdown.lua` should look exactly like this:

```lua
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
      local result = vim.fn.system({ "curl", "-sL", url, "-o", css_path })
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

      local cmd = {
        "pandoc",
        "--standalone",
        "--from=gfm",
        "--to=html5",
        "--embed-resources",
        "--resource-path=" .. file_dir,
        "--metadata=title:" .. filename,
        "-o", out,
        filepath,
      }
      local css = ensure_css()
      if css then
        table.insert(cmd, "--css=" .. css)
      end

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
      for _, f in ipairs(files) do
        vim.fn.delete(f)
      end
      vim.notify("markdown-preview: deleted " .. #files .. " preview file(s)", vim.log.levels.INFO)
    end

    vim.api.nvim_create_autocmd("FileType", {
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
```

---

### Task 5: Manual smoke test and commit

**Files:**
- No code changes — test and commit only

- [ ] **Step 1: Open a markdown file in Neovim and press `<leader>mo`**

```bash
nvim some-test.md
```
Expected: default browser opens a styled HTML page with GFM rendering.

- [ ] **Step 2: Press `<leader>mx`**

Expected: notification "markdown-preview: deleted 1 preview file(s)".

- [ ] **Step 3: Press `<leader>mx` again**

Expected: notification "markdown-preview: no preview files found".

- [ ] **Step 4: Commit**

```bash
git add nvim/.config/nvim/lua/plugins/markdown.lua docs/superpowers/specs/2026-04-22-markdown-browser-preview-design.md docs/superpowers/plans/2026-04-22-markdown-browser-preview.md
git commit -m "feat(nvim): add markdown browser preview with pandoc (macOS only)"
```
