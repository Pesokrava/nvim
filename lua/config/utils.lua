local utils = {}

-- Path to the file that stores the Neo-tree position
local position_file = vim.fn.stdpath('config') .. '/neotree_position.txt'

-- Function to read the Neo-tree position from the file
local function read_neotree_position()
  local file = io.open(position_file, "r")
  if file then
    local position = file:read("*a")
    file:close()
    return position
  end
  return 'left' -- Default position if file does not exist
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
    if current_position == 'left' then
      current_position = 'right'
    else
      current_position = 'left'
    end
  end

  -- Toggle position
  if current_position == 'left' then
    -- Close current Neo-tree and open it on the right

    vim.cmd("Neotree close")
    vim.cmd("Neotree filesystem reveal right")
    write_neotree_position('right')
  else
    -- Close current Neo-tree and open it on the left
    vim.cmd("Neotree close")
    vim.cmd("Neotree filesystem reveal left")
    write_neotree_position('left')
  end
end

return utils
