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
        if exit_code == nil or exit_code ~= 0 then
            -- Handle error
            local error_message = "Error fetching GitHub notifications."
            if exit_code ~= nil then
                error_message = error_message .. " Exit code: " .. exit_code
            end
            print(error_message)
            handle_github_error(notifications or error_message)
            return
        end

        -- Clear existing packages
        clear_existing_notifications()

        local count = process_notifications(notifications)

        -- Update GitHub icon based on notification count
        update_github_icon(count)
    end)
end)

function handle_github_error(error_message)
    local error_label = "!"
    if type(error_message) == "string" then
        if string.match(error_message, "TLS handshake timeout") then
            error_label = "TO"
        elseif string.match(error_message, "check your internet connection") then
            error_label = "CN"
        end
    end

    github:set({
        drawing = "on",
        icon = {
            string = icons.bell,
            color = colors.red,
        },
        label = error_label,
    })
end

function clear_existing_notifications()
    local existingNotifications = github:query()
    if existingNotifications.popup and next(existingNotifications.popup.items) ~= nil then
        for _, item in pairs(existingNotifications.popup.items) do
            sbar.remove(item)
        end
    end
end

function process_notifications(notifications)
    local count = 0
    for _, notification in pairs(notifications) do
        count = count + 1
        process_single_notification(notification)
    end
    return count
end

function process_single_notification(notification)
    local id = notification.id
    local url = notification.subject.latest_comment_url or "https://www.github.com/notifications"
    local repo = notification.repository.name
    local title = notification.subject.title
    local type = notification.subject.type

    if url ~= "https://www.github.com/notifications" then
        fetch_html_url(url, id, repo, title)
    end

    add_notification_to_popup(id, repo, title, type, url)
end

function fetch_html_url(url, id, repo, title)
    local tempUrl = url:gsub("^'", ""):gsub("'$", "")
    sbar.exec('gh api "' .. tempUrl .. '" | jq .html_url', function(html_url, api_exit_code)
        if api_exit_code ~= 0 then
            print("Error fetching HTML URL. Exit code: " .. api_exit_code)
            return
        end
        update_click_script("repo", id, html_url, repo)
        update_click_script("message", id, html_url, title)
    end)
end

function update_click_script(item_type, id, html_url, content)
    if content and content ~= "" then
        local cmd = "sketchybar -m --set github.notification." .. item_type .. "." .. tostring(id) .. 
                    ' click_script="open ' .. html_url .. '; ' .. popup_off .. '"'
        sbar.exec(cmd)
    end
end

function add_notification_to_popup(id, repo, title, type, url)
    local color, icon = get_notification_style(type)

    if repo and repo ~= "" then
        github.notification.repo = sbar.add("item", "github.notification.repo." .. tostring(id), {
            label = { padding_right = settings.paddings },
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
            label = { string = title, padding_right = 10 },
            icon = { drawing = "off", padding_left = settings.paddings },
            drawing = true,
            click_script = "open " .. url .. "; " .. popup_off,
            position = "popup." .. github.name,
        })
    end
end

function get_notification_style(type)
    if type == "Issue" then
        return colors.green, icons.git.issue
    elseif type == "Discussion" then
        return colors.text, icons.git.discussion
    elseif type == "PullRequest" then
        return colors.maroon, icons.git.pull_request
    elseif type == "Commit" then
        return colors.text, icons.git.commit
    else
        return colors.text, icons.git.issue
    end
end

function update_github_icon(count)
    github:set({
        drawing = count > 0 and "on" or "off",
        icon = { string = count > 0 and icons.bell or icons.bell_dot },
        label = count > 0 and count or 0,
    })
end

sbar.add("bracket", "widgets.github.bracket", { github.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.github.padding", {
  position = "right",
  width = settings.group_paddings
})
