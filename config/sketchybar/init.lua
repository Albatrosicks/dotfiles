-- Require the sketchybar module
sbar = require("sketchybar")

-- Patch sbar.exec to output errors from stderr
local original_exec = sbar.exec
sbar.exec = function(command, callback)
  local function my_callback(stdout, stderr)
    if stderr and stderr ~= "" then
      -- Print errors to stderr
      io.stderr:write("Error executing command '" .. command .. "': " .. stderr .. "\n")
    end
    if callback then callback(stdout, stderr) end
  end
  original_exec(command, my_callback)
end

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Begin configuration
sbar.begin_config()

-- Wrap configuration requires in an xpcall to catch startup errors.
local ok, err = xpcall(function()
  require("bar")
  require("default")
  require("items")
end, debug.traceback)

if not ok then
  io.stderr:write("Error in configuration: " .. err .. "\n")
end

sbar.end_config()

-- Run the event loop of the sketchybar module
sbar.event_loop()
