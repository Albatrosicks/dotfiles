local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local popup_off = "sketchybar --set github popup.drawing=off"

local github = sbar.add("item", "github", {
	position = "right",
	drawing = "on",
	icon = {
		string = icons.bell,
		color = colors.blue,
		font = {
      style = settings.font.style_map["Bold"],
			size = 15.0,
		},
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

github.details = sbar.add("item", "github.details", {
	position = "popup." .. github.name,
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

github:subscribe({
	"mouse.clicked",
}, function(info)
	if info.BUTTON == "left" then
		sbar.exec("sketchybar --set " .. (info.NAME) .. " popup.drawing=toggle")
	end

	if info.BUTTON == "right" then
		sbar.trigger("github_update")
	end
end)

github:subscribe({
	"mouse.exited",
	"mouse.exited.global",
}, function(_)
	github:set({ popup = { drawing = false } })
end)

github:subscribe({
	"mouse.entered",
}, function(_)
	github:set({ popup = { drawing = true } })
end)

github:subscribe({
    "routine",
    "forced",
    "github_update",
}, function(_)
    -- fetch new information
    sbar.exec("gh api notifications", function(notifications, exit_code)
        if exit_code ~= 0 then
            -- Handle error
            print("Error fetching GitHub notifications. Exit code: " .. exit_code)
            github:set({
                drawing = "on",
                icon = {
                    string = icons.bell,
                    color = colors.red,
                },
                label = "!",
            })
            return
        end

        -- Clear existing packages
        local existingNotifications = github:query()
        if existingNotifications.popup and next(existingNotifications.popup.items) ~= nil then
            for _, item in pairs(existingNotifications.popup.items) do
                sbar.remove(item)
            end
        end

        local count = 0
        for _, notification in pairs(notifications) do
            -- increment count for label
            count = count + 1

            local id = notification.id
            local url = notification.subject.latest_comment_url
            local repo = notification.repository.name
            local title = notification.subject.title
            local type = notification.subject.type

            -- set click_script for each notification
            if url == nil then
                url = "https://www.github.com/notifications"
            else
                local tempUrl = url:gsub("^'", ""):gsub("'$", "")
                sbar.exec('gh api "' .. tempUrl .. '" | jq .html_url', function(html_url, api_exit_code)
                    if api_exit_code ~= 0 then
                        print("Error fetching HTML URL. Exit code: " .. api_exit_code)
                        return
                    end

                    local cmd = "sketchybar -m --set github.notification"
                    if repo and repo ~= "" then
                        cmd = cmd .. ".repo." .. tostring(id) .. ' click_script="open ' .. html_url .. '"'
                        sbar.exec(cmd)
                    end

                    cmd = "sketchybar -m --set github.notification"
                    if title and title ~= "" then
                        cmd = cmd .. ".message." .. tostring(id) .. ' click_script="open ' .. html_url .. '"'
                        sbar.exec(cmd)
                    end
                end)
            end

            -- get icon and color for each notification
            -- depending on the type
            local color, icon
            if type == "Issue" then
                color, icon = colors.green, icons.git.issue
            elseif type == "Discussion" then
                color, icon = colors.text, icons.git.discussion
            elseif type == "PullRequest" then
                color, icon = colors.maroon, icons.git.pull_request
            elseif type == "Commit" then
                color, icon = colors.text, icons.git.commit
            else
                color, icon = colors.text, icons.git.issue
            end

            -- add notification to popup
            github.notification = {}
            if repo and repo ~= "" then
                github.notification.repo = sbar.add("item", "github.notification.repo." .. tostring(id), {
                    label = {
                        padding_right = settings.paddings,
                    },
                    icon = {
                        string = icon .. " " .. repo,
                        color = color,
                        font = {
                            family = settings.nerd_font,
                            size = 14.0,
                            style = settings.font.style_map["Bold"],
                        },
                        padding_left = settings.paddings,
                    },
                    drawing = true,
                    click_script = "open " .. url .. "; " .. popup_off,
                    position = "popup." .. github.name,
                })
            end

            if title and title ~= "" then
                github.notification.message = sbar.add("item", "github.notification.message." .. tostring(id), {
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
                    position = "popup." .. github.name,
                })
            end
        end

        -- Change icon and color depending on packages
        github:set({
            drawing = "off",
            icon = {
                string = icons.bell_dot,
            },
            label = 0,
        })

        if count > 0 then
            github:set({
                drawing = "on",
                icon = {
                    string = icons.bell,
                },
                label = count,
            })
        end
    end)
end)


sbar.add("bracket", "widgets.github.bracket", { github.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.github.padding", {
  position = "right",
  width = settings.group_paddings
})
