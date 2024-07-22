local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local github_count = sbar.add("item", "widgets.github_count", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "0",
    padding_left = -1,
    font = { family = settings.font.numbers }
  },
})

local github_icon = sbar.add("item", "widgets.github_icon", {
  position = "right",
  padding_right = -1,
  icon = {
    string = icons.bell_empty,
    width = 0,
    align = "left",
    color = colors.blue,
    font = {
      style = settings.font.style_map["Bold"],
      size = 14.0,
    },
  },
  label = {
    width = 25,
    align = "left",
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
})

local github_bracket = sbar.add("bracket", "widgets.github.bracket", {
  github_icon.name,
  github_count.name
}, {
  background = { color = colors.bg1 },
  popup = { align = "center" }
})

sbar.add("item", "widgets.github.padding", {
  position = "right",
  width = settings.group_paddings
})

local function update_github_notifications()
  sbar.exec("gh api notifications", function(notifications)
    local count = 0
    for _, _ in pairs(notifications) do
      count = count + 1
    end

    -- if count = 0 then set icon.bell_empty and if greater than 0 set bell icon
    if count > 0 then
      github_icon.icon.string = icons.bell
    else
      github_icon.icon.string = icons.bell_empty
    end
    github_count:set({ label = count })
  end)
end

local function open_github_notifications(env)
  if env.BUTTON == "left" then
    sbar.exec("open https://github.com/notifications")
  end
end

github_icon:subscribe("mouse.clicked", open_github_notifications)
github_count:subscribe("mouse.clicked", open_github_notifications)

-- Initial update
update_github_notifications()

-- Periodically update the GitHub notifications count
sbar.add("routine", "github_update", {
  interval = 180,
  script = update_github_notifications
})

return github_bracket
