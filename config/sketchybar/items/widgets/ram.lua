local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "ram_update" for
-- the RAM usage data, which is fired every 2.0 seconds.
sbar.exec("killall ram_load >/dev/null; $CONFIG_DIR/helpers/event_providers/ram_load/bin/ram_load ram_update 2.0")

local ram = sbar.add("graph", "widgets.ram", 42, {
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.memory },
  label = {
    string = "ram ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4
  },
  padding_right = settings.paddings + 6
})

ram:subscribe("ram_update", function(env)
  local used_ram = tonumber(env.used_ram)
  local total_ram = tonumber(env.total_ram)
  local load = (used_ram / total_ram) * 100
  ram:push({ load / 100. })

  local color = colors.blue
  if load > 30 then
    if load < 60 then
      color = colors.yellow
    elseif load < 80 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  ram:set({
    graph = { color = color },
    label = "ram " .. string.format("%.0f", load) .. "%",
  })
end)

ram:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the ram item
sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
  background = { color = colors.bg1 }
})

-- Background around the ram item
sbar.add("item", "widgets.ram.padding", {
  position = "right",
  width = settings.group_paddings
})

