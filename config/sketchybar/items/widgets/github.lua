local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local popup_off = "sketchybar --set github popup.drawing=off"

local github = sbar.add("item", "github", {
    position = "right",
    icon = {
        string = icons.bell,
        color = colors.blue,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 15.0,
        },
    },
    background = {
        padding_left = 0,
    },
    label = {
        string = icons.loading,
        highlight_color = colors.blue,
    },
    update_freq = 180,
    popup = {
        align = "right",
    },
})

local github_details = sbar.add("item", "github.details", {
    position = "popup.github",
    click_script = popup_off,
    background = {
        corner_radius = 12,
        padding_left = 7,
        padding_right = 7,
    },
    icon = {
        background = {
            height = 2,
            y_offset = -12,
        },
    },
})

local github_bracket = sbar.add("bracket", "github.bracket", {
    github.name,
    github_details.name
}, {
    background = { color = colors.bg1 },
    popup = { align = "center", height = 30 }
})

local function toggle_popup(info)
    local should_draw = github_bracket:query().popup.drawing == "off"
    github_bracket:set({ popup = { drawing = should_draw } })
end

github:subscribe("mouse.clicked", function(info)
    if info.BUTTON == "left" then
        toggle_popup(info)
    elseif info.BUTTON == "right" then
        sbar.trigger("github_update")
    end
end)

github:subscribe({"mouse.exited", "mouse.exited.global"}, function(_)
    github:set({ popup = { drawing = false } })
end)

github:subscribe("mouse.entered", function(_)
    github:set({ popup = { drawing = true } })
end)

github:subscribe({"routine", "forced", "github_update"}, function(_)
    sbar.exec("gh api notifications", function(notifications)
        local existingNotifications = github:query()
        if existingNotifications.popup and next(existingNotifications.popup.items) ~= nil then
            for _, item in pairs(existingNotifications.popup.items) do
                sbar.remove(item)
            end
        end

        local count = 0
        for _, notification in pairs(notifications) do
            count = count + 1

            local id = notification.id
            local url = notification.subject.latest_comment_url or "https://www.github.com/notifications"
            local repo = notification.repository.name
            local title = notification.subject.title
            local type = notification.subject.type

            local color, icon
            if type == "Issue" then
                color = colors.green
                icon = icons.git and icons.git.issue or icons.issue
            elseif type == "Discussion" then
                color = colors.text
                icon = icons.git and icons.git.discussion or icons.discussion
            elseif type == "PullRequest" then
                color = colors.maroon
                icon = icons.git and icons.git.pull_request or icons.pull_request
            elseif type == "Commit" then
                color = colors.text
                icon = icons.git and icons.git.commit or icons.commit
            else
                color = colors.text
                icon = icons.git and icons.git.issue or icons.issue
            end

            if repo then
                sbar.add("item", "github.notification.repo" .. tostring(id), {
                    label = { padding_right = settings.paddings },
                    icon = {
                        string = icon .. " " .. repo,
                        color = color,
                        font = {
                            family = settings.font.text,
                            size = 14.0,
                            style = settings.font.style_map["Bold"],
                        },
                        padding_left = settings.paddings,
                    },
                    drawing = true,
                    click_script = "open " .. url .. "; " .. popup_off,
                    position = "popup.github",
                })
            end

            if title then
                sbar.add("item", "github.notification.message." .. tostring(id), {
                    label = {
                        string = title,
                        padding_right = 10,
                    },
                    icon = {
                        drawing = "off",
                        padding_left = settings.paddings,
                    },
                    drawing = true,
                    click_script = "open " .. url .. "; " .. popup_off,
                    position = "popup.github",
                })
            end
        end

        github:set({
            icon = { string = icons.bell_dot },
            label = 0,
        })

        if count > 0 then
            github:set({
                icon = { string = icons.bell },
                label = count,
            })
        end
    end)
end)

return github
