local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local update_interval = 60 -- обновление каждые 60 секунд
local cached_remaining = 0 -- кэшированное значение remaining

local cursor = sbar.add("item", "widgets.cursor", {
    position = "right",
    icon = {
        string = icons.cursor,
        color = colors.green,
    },
    background = {
        padding_left = 5,
    },
    label = "?",
    update_freq = update_interval,
    popup = {
        align = "right",
        height = 20,
    },
    padding_right = settings.paddings + 6
})

cursor.details = sbar.add("item", "cursor.details", {
    position = "popup." .. cursor.name,
    click_script = "sketchybar --set cursor popup.drawing=off",
    background = {
        corner_radius = 12,
        padding_left = 5,
        padding_right = 10,
    },
})

cursor:subscribe({
    "mouse.clicked",
}, function(info)
    if info.BUTTON == "left" then
        sbar.exec("sketchybar --set cursor popup.drawing=toggle")
    end
    if info.BUTTON == "right" then
        sbar.trigger("cursor_update")
    end
end)

cursor:subscribe({
    "mouse.exited",
    "mouse.exited.global",
}, function(_)
    cursor:set({ popup = { drawing = false } })
end)

cursor:subscribe({
    "mouse.entered",
}, function(_)
    cursor:set({ popup = { drawing = true } })
end)

cursor:subscribe({
    "routine",
    "forced",
    "cursor_update",
}, function(_)
    -- отображаем индикатор загрузки перед выполнением запроса
    cursor:set({
        label = { 
            string = icons.loading,
            highlight_color = colors.blue,
        },
    })

    sbar.exec("source ~/.zshrc.local && curl -s -H 'Content-Type: application/json' -H \"Cookie: WorkosCursorSessionToken=$CURSOR_TOKEN\" \"https://www.cursor.com/api/usage?user=${CURSOR_TOKEN%%::*}\"", function(result)
        if not result or not result["gpt-4"] then
            cursor:set({ label = "ERR" })
            return
        end

        local maxRequestUsage = result["gpt-4"].maxRequestUsage
        local numRequests = result["gpt-4"].numRequests
        local remaining = maxRequestUsage - numRequests
        cached_remaining = remaining  -- сохраняем новое значение в кэш

        local thresholds = {
            { count = 250, color = colors.green },
            { count = 100, color = colors.yellow },
            { count = 50, color = colors.orange },
            { count = 0, color = colors.red },
        }

        -- Change icon color depending on remaining requests
        for _, threshold in ipairs(thresholds) do
            if remaining >= threshold.count then
                cursor:set({
                    icon = {
                        color = threshold.color,
                    },
                    label = remaining,
                })
                break
            end
        end

        -- Add details to popup
        cursor.details:set({
            label = {
                string = "Used: " .. numRequests .. " / " .. maxRequestUsage,
                align = "right",
                padding_right = 20,
                padding_left = 20,
            },
        })
    end)
end)

sbar.add("bracket", "widgets.cursor.bracket", { cursor.name }, {
    background = { color = colors.bg1 }
})

sbar.add("item", "widgets.cursor.padding", {
    position = "right",
    width = settings.group_paddings
})

return cursor
