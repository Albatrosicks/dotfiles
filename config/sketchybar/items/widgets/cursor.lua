local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local cursor = sbar.add("graph", "widgets.cursor", 42, {
    position = "right",
    graph = { color = colors.blue },
    background = {
        height = 22,
        color = { alpha = 0 },
        border_color = { alpha = 0 },
        drawing = true,
    },
    icon = {
        string = icons.cursor,
        color = colors.green,
    },
    label = {
        string = "reqs ??",
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
    update_freq = 300,
    padding_right = settings.paddings + 6
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
    "routine",
    "forced",
    "cursor_update",
}, function(_)

    cursor:set({
        label = {
            string = icons.loading or "",
            highlight_color = colors.blue,
        },
    })

    sbar.exec("source ~/.zshrc.local && curl -s -H 'Content-Type: application/json' -H \"Cookie: WorkosCursorSessionToken=$CURSOR_TOKEN\" \"https://www.cursor.com/api/usage?user=${CURSOR_TOKEN%%::*}\"", function(result)
        local maxRequestUsage = result["gpt-4"].maxRequestUsage
        local numRequests = result["gpt-4"].numRequests
        local remaining = maxRequestUsage - numRequests
        local used_percent = (numRequests / maxRequestUsage) * 100

        local color = colors.green
        if remaining > 50 then
            if remaining < 100 then
                color = colors.orange
            elseif remaining < 250 then
                color = colors.yellow
            else
                color = colors.red
            end
        end
            

        cursor:set({ label = remaining })

        -- Отправляем значение в график, преобразованное в число от 0 до 1
        cursor:push({0.5})
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
