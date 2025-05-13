local icons            = require("icons")
local settings         = require("settings")
local colors           = require("colors")

local update_interval  = 60 -- обновление каждые 60 секунд
local switch_interval  = 5 -- flip display every 5 s
local ticks_per_fetch  = update_interval / switch_interval
local tick_count       = 0
local cached_credits   = 0
local credit_err       = false
local remain_err       = true
local cached_remaining = 0 -- кэшированное значение remaining
local cursor_disabled  = true -- disable cursor API checking

local cursor           = sbar.add("item", "widgets.cursor", {
    position = "right",
    icon = {
        string = icons.cursor,
        color = colors.green,
    },
    background = {
        padding_left = 5,
    },
    label = "?",
    update_freq = switch_interval,
    popup = {
        align = "right",
        height = 30,
    },
    padding_right = settings.paddings + 6
})

-- OpenRouter credits display in popup
local cred_item        = sbar.add("item", "cursor.credits", {
    position = "popup." .. cursor.name,
    label = {
        padding_left = 5,
        padding_right = 5,
        align = "right",
        max_chars = 40,
    },
})

-- Cursor requests remaining display in popup
local req_item         = sbar.add("item", "cursor.requests", {
    position = "popup." .. cursor.name,
    label = {
        padding_left = 5,
        padding_right = 5,
        align = "right",
        max_chars = 40,
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
    "forced",
    "cursor_update",
}, function()
    tick_count = 0
    cursor:set({ label = { string = icons.loading, highlight_color = colors.blue } })

    -- Get OpenRouter credits
    sbar.exec(
    "zsh -ic 'source ~/.zshrc.local && curl -s -H \"Authorization: Bearer $OPENROUTER_API_KEY\" https://openrouter.ai/api/v1/credits'",
        function(cres)
            if not cres or not cres.data then
                credit_err, cached_credits = true, 0
            else
                credit_err = false
                cached_credits = (tonumber(cres.data.total_credits) or 0)
                    - (tonumber(cres.data.total_usage) or 0)
            end

            -- Update popup labels
            cred_item:set({
                label = {
                    string =
                        credit_err
                        and "OpenRouter Credits: ERR"
                        or string.format("OpenRouter Credits: $%.2f", cached_credits)
                }
            })
            
            -- Display "Disabled" for cursor API
            req_item:set({
                label = {
                    string = "Cursor API: Disabled"
                }
            })

            -- Update the main label with OpenRouter credits
            if not credit_err then
                cursor:set({
                    icon = { color = colors.green },
                    label = string.format("$%.2f", cached_credits)
                })
            else
                cursor:set({ 
                    icon = { color = colors.red },
                    label = "ERR" 
                })
            end
        end)
end)

-- Check for updates every 60s
cursor:subscribe({ "routine" }, function()
    tick_count = tick_count + 1
    if tick_count >= ticks_per_fetch then
        tick_count = 0
        sbar.trigger("cursor_update")
    end
end)

-- kick off an initial fetch
sbar.trigger("cursor_update")

sbar.add("bracket", "widgets.cursor.bracket", { cursor.name }, {
    background = { color = colors.bg1 }
})

sbar.add("item", "widgets.cursor.padding", {
    position = "right",
    width = settings.group_paddings
})

return cursor