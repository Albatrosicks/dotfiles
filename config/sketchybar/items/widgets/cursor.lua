local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local cursor = sbar.add("item", "cursor", {
    position = "right",
    icon = {
        -- Задайте свою иконку для Cursor AI
        string = icons.cursor or "",
        color = colors.green,
    },
    background = {
        padding_left = 5,
    },
    label = "?",
    update_freq = 300,
    popup = {
        align = "right",
        height = 20,
    },
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

cursor.clearPopup = function()
    local existingItems = cursor:query()
    if existingItems.popup and next(existingItems.popup.items) ~= nil then
        for _, item in pairs(existingItems.popup.items) do
            sbar.remove(item)
        end
    end
end

cursor.skipCleanup = true

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
    "mouse.entered",
}, function(_)
    cursor:set({ popup = { drawing = true } })
end)

cursor:subscribe({
    "mouse.exited",
    "mouse.exited.global",
}, function(_)
    cursor:set({ popup = { drawing = false } })
end)

cursor:subscribe({
    "cursor_cleanup",
}, function(_)
    if cursor.skipCleanup == false then
        cursor:set({ label = 0 })
        cursor.clearPopup()
    end
end)

cursor:subscribe({
    "routine",
    "forced",
    "cursor_update",
}, function(_)
    cursor.skipCleanup = false

    cursor:set({
        label = {
            string = icons.loading or "",
            highlight_color = colors.blue,
        },
    })

    -- Исправленный путь к bash скрипту
    local cmd = "bash ~/.config/sketchybar/items/widgets/cursor_balance.sh"
    sbar.exec(cmd, function(result)
        -- Обрезаем пробелы в начале и конце строки
        result = result:gsub("^%s*(.-)%s*$", "%1")
        -- Извлекаем значение remaining, используя более строгий шаблон
        local remaining = result:match('{"remaining":(%d+),')
        if remaining then
            remaining = tonumber(remaining)
        else
            remaining = "N/A"
        end

        local thresholds = {
            { count = 1000, color = colors.green },
            { count = 500, color = colors.yellow },
            { count = 100, color = colors.peach },
            { count = 0, color = colors.red },
        }

        if type(remaining) == "number" then
            for _, threshold in ipairs(thresholds) do
                if remaining >= threshold.count then
                    cursor:set({
                        icon = { color = threshold.color },
                        label = remaining,
                    })
                    break
                end
            end
        else
            cursor:set({ label = result })
        end
    end)

    sbar.trigger("cursor_cleanup")
end)

sbar.add("bracket", "widgets.cursor.bracket", { cursor.name }, {
    background = { color = colors.bg1 }
})

sbar.add("item", "widgets.cursor.padding", {
    position = "right",
    width = settings.group_paddings
})

return cursor

