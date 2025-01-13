local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  icon = {
    font = {
      style = settings.font.style_map["Regular"],
      size = 19.0,
    }
  },
  label = { font = { family = settings.font.numbers } },
  update_freq = 180,
  popup = { align = "center" }
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  icon = {
    string = "Time remaining:",
    width = 100,
    align = "left"
  },
  label = {
    string = "??:??h",
    width = 100,
    align = "right"
  },
})


battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    -- Default values for error states
    local icon = icons.battery._0
    local label = "?"
    local color = colors.red
    local charge = 0

    -- Check if we got valid battery info
    if batt_info and type(batt_info) == "string" then
        -- Extract battery percentage
        local found, _, charge_str = batt_info:find("(%d+)%%")
        if found then
            charge = tonumber(charge_str)
            -- Validate charge is in valid range
            if charge and charge >= 0 and charge <= 100 then
                label = charge .. "%"
            else
                charge = 0
                label = "ERR%"
            end
        end

        -- Check power source
        local is_charging = batt_info:find("AC Power") ~= nil
        local is_no_battery = batt_info:find("No Battery") ~= nil

        -- Determine icon and color based on status
        if is_no_battery then
            icon = "⚡" -- or whatever icon you use for AC-only
            color = colors.white
            label = "AC"
        elseif is_charging then
            icon = icons.battery.charging
            color = colors.green
        else
            -- Battery level indicators
            if charge > 80 then
                icon = icons.battery._100
                color = colors.green
            elseif charge > 60 then
                icon = icons.battery._75
                color = colors.green
            elseif charge > 40 then
                icon = icons.battery._50
                color = colors.green
            elseif charge > 20 then
                icon = icons.battery._25
                color = colors.orange
            else
                icon = icons.battery._0
                color = colors.red
            end
        end
    end

    -- Add leading zero for single digit percentages
    local lead = ""
    if charge < 10 and charge >= 0 then
        lead = "0"
    end

    battery:set({
        icon = {
            string = icon,
            color = color
        },
        label = { string = lead .. label },
    })
  end)
end)

battery:subscribe("mouse.clicked", function(env)
  local drawing = battery:query().popup.drawing
  battery:set( { popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      remaining_time:set( { label = label })
    end)
  end
end)

sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.battery.padding", {
  position = "right",
  width = settings.group_paddings
})
