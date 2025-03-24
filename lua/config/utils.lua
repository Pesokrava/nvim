local utils = {}

-- Path to the file that stores the Neo-tree position
local position_file = vim.fn.stdpath("config") .. "/neotree_position.txt"

-- Function to read the Neo-tree position from the file
local function read_neotree_position()
  local file = io.open(position_file, "r")
  if file then
    local position = file:read("*a")
    file:close()
    return position
  end
  return "left" -- Default position if file does not exist
end

-- Function to write the Neo-tree position to the file
local function write_neotree_position(position)
  local file = io.open(position_file, "w")
  if file then
    file:write(position)
    file:close()
  end
end

-- Function to toggle Neo-tree position between left and right
function utils.Toggle_neotree_position(swap)
  -- Read the current position from the file
  local current_position = read_neotree_position()
  if swap then
    if current_position == "left" then
      current_position = "right"
    else
      current_position = "left"
    end
  end

  -- Toggle position
  if current_position == "left" then
    -- Close current Neo-tree and open it on the right

    vim.cmd("Neotree close")
    vim.cmd("Neotree filesystem reveal right")
    write_neotree_position("right")
  else
    -- Close current Neo-tree and open it on the left
    vim.cmd("Neotree close")
    vim.cmd("Neotree filesystem reveal left")
    write_neotree_position("left")
  end
end

function _G.set_trace()
  if vim.bo.filetype == "python" then
    -- Check if 'import ipdb' is in the file
    local ipdb_present = false
    for i = 1, vim.fn.line("$") do
      if string.find(vim.fn.getline(i), "import ipdb") then
        ipdb_present = true
        break
      end
    end

    -- If 'import ipdb' is not in the file, add it at the beginning
    if not ipdb_present then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, { "import ipdb" })
    end

    -- Get the current line's indentation
    local indent = vim.fn.indent(".")
    local spaces = string.rep(" ", indent)

    -- Add 'ipdb.set_trace()' at the current line with the correct indentation
    vim.api.nvim_put({ spaces .. "ipdb.set_trace()" }, "l", true, true)
  end
end

function _G.clear_trace()
  if vim.bo.filetype == "python" then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local new_lines = {}

    for _, line in ipairs(lines) do
      if not string.find(line, "import ipdb") and not string.find(line, "ipdb.set_trace()") then
        table.insert(new_lines, line)
      end
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
  end
end

vim.api.nvim_set_keymap("n", "<leader>c", ":lua clear_trace()<CR>", { noremap = true, silent = true })
return utils
