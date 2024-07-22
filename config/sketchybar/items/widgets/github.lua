local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local function fetch_notifications(callback)
  sbar.exec("gh api notifications", function(notifications)
    callback(notifications)
  end)
end

local function create_notification_item(notification, index)
  local id = notification.id
  local url = notification.subject.latest_comment_url or "https://www.github.com/notifications"
  local repo = notification.repository.name
  local title = notification.subject.title
  local type = notification.subject.type

  local icon, color
  if type == "Issue" then
    color = colors.green
    icon = icons.git.issue
  elseif type == "Discussion" then
    color = colors.text
    icon = icons.git.discussion
  elseif type == "PullRequest" then
    color = colors.maroon
    icon = icons.git.pull_request
  elseif type == "Commit" then
    color = colors.text
    icon = icons.git.commit
  else
    color = colors.text
    icon = icons.git.issue
  end

  local notification_item = sbar.add("item", "github.notification." .. index, {
    position = "popup.github_icon",
    label = {
      string = title,
      padding_right = 10,
    },
    icon = {
      string = icon .. " " .. repo,
      color = color,
      font = {
        family = settings.nerd_font,
        size = 14.0,
        style = "Bold",
      },
      padding_left = settings.paddings,
    },
    drawing = true,
    click_script = "open " .. url,
    right_click_script = "gh api --method PATCH /notifications/threads/" .. id,
  })

  return notification_item
end

local function update_github_notifications()
  fetch_notifications(function(notifications)
    local count = 0
    for _, _ in pairs(notifications) do
      count = count + 1
    end

    github_icon:set({ icon = { string = icons.bell } })
    github_count:set({ label = count })

    local existingNotifications = github_icon:query()
    if existingNotifications.popup and next(existingNotifications.popup.items) ~= nil then
      for _, item in pairs(existingNotifications.popup.items) do
        sbar.remove(item)
      end
    end

    for index, notification in ipairs(notifications) do
      create_notification_item(notification, index)
    end
  end)
end

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
    string = icons.bell,
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

github_icon:subscribe("mouse.entered", function()
  github_icon:set({ popup = { drawing = true } })
end)

github_icon:subscribe("mouse.exited", function()
  github_icon:set({ popup = { drawing = false } })
end)

github_icon:subscribe("mouse.exited.global", function()
  github_icon:set({ popup = { drawing = false } })
end)

-- Initial update
update_github_notifications()

-- Periodically update the GitHub notifications count
sbar.add("routine", "github_update", {
  interval = 180,
  script = update_github_notifications
})

return github_bracket
