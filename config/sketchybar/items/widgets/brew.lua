local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local brew = sbar.add("item", "widgets.brew", {
  position = "right",
  icon = {
    string = icons.brew,
    font = {
      style = settings.font.style_map["Regular"],
      size = 19.0,
    }
  },
  label = { font = { family = settings.font.numbers } },
  update_freq = 180,
  popup = { align = "center" }
})

local outdated_packages = sbar.add("item", {
  position = "popup." .. brew.name,
  icon = {
    string = "Outdated packages:",
    width = 200,
    align = "left"
  },
  label = {
    string = "?",
    width = 50,
    align = "right"
  },
})

brew:subscribe("routine", function()
  sbar.exec("brew outdated | wc -l | tr -d ' '", function(brew_count)
    sbar.exec("port outdated -q | wc -l | tr -d ' '", function(port_count)
      local count = tonumber(brew_count) + tonumber(port_count)
      local label = tostring(count)
      local color = colors.red

      if count > 30 then
        color = colors.orange
      elseif count > 10 then
        color = colors.yellow
      elseif count > 0 then
        color = colors.white
      else
        color = colors.green
        label = icons.checkmark
      end

      brew:set({
        icon = {
          string = icons.brew,
          color = color
        },
        label = { string = label },
      })
    end)
  end)
end)

brew:subscribe("mouse.clicked", function(env)
  local drawing = brew:query().popup.drawing
  brew:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("brew outdated; port outdated -q", function(outdated_list)
      local label = outdated_list ~= "" and outdated_list or "No outdated packages"
      outdated_packages:set({ label = label })
    end)
  end
end)

sbar.add("bracket", "widgets.brew.bracket", { brew.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.brew.padding", {
  position = "right",
  width = settings.group_paddings
})

