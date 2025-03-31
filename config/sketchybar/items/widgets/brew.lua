local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

local brew = sbar.add("item", "brew", {
    position = "right",
    drawing = "off", -- Start hidden until we know there are packages
    icon = {
        string = icons.brew.empty,
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

brew.details = sbar.add("item", "brew.details", {
    position = "popup." .. brew.name,
    click_script = "sketchybar --set brew popup.drawing=off",
    background = {
        corner_radius = 12,
        padding_left = 5,
        padding_right = 10,
    },
})

brew.clearPopup = function()
    -- Clear existing packages
    local existingPackages = brew:query()
    if existingPackages.popup and next(existingPackages.popup.items) ~= nil then
        for _, item in pairs(existingPackages.popup.items) do
            sbar.remove(item)
        end
    end
end

brew.skipCleanup = true
brew.packageCount = 0 -- Store the actual count

brew:subscribe({
    "mouse.clicked",
}, function(info)
    if info.BUTTON == "left" then
        sbar.exec("sketchybar --set brew popup.drawing=toggle")
    end

    if info.BUTTON == "right" then
        sbar.trigger("brew_update")
    end
end)

brew:subscribe({
    "mouse.exited",
    "mouse.exited.global",
}, function(_)
    brew:set({ 
        popup = { drawing = false },
        label = "?" -- Show ? when not hovered
    })
end)

brew:subscribe({
    "mouse.entered",
}, function(_)
    brew:set({ 
        popup = { drawing = true },
        label = brew.packageCount -- Show actual count when hovered
    })
end)

brew:subscribe({
    "brew_cleanup",
}, function(_)
    if brew.skipCleanup == false then
        brew.packageCount = 0
        brew:set({ 
            label = "?",
            drawing = "off" -- Hide when no packages
        })
        brew.clearPopup()
    end
end)

brew:subscribe({
    "routine",
    "forced",
    "brew_update",
}, function(_)
    brew.skipCleanup = false,

    -- fetch new information
    brew:set({ 
        label = { 
            string = icons.loading,
            highlight_color = colors.blue,
        },
    })
    sbar.exec("command brew update -q")
    sbar.exec("command brew outdated -q", function(outdated)
        -- NOTE: sbar.exec will not run callback if command doesn't return anything.
        -- We use a variable to determine if we should skip cleaning up the count
        -- and popup
        brew.skipCleanup = true

        local thresholds = {
            { count = 30, color = colors.red },
            -- { count = 20, color = colors.peach },
            { count = 10, color = colors.yellow },
            { count = 1, color = colors.green },
            { count = 0, color = colors.green },
        }

        local count = 0
        for _ in outdated:gmatch("\n") do
            count = count + 1
        end

        brew.packageCount = count -- Store the actual count

        -- Clear existing packages
        brew.clearPopup()

        -- Add packages to popup
        for package in outdated:gmatch("[^\n]+") do
            sbar.add("item", "brew.package." .. package, {
                label = {
                    string = tostring(package),
                    align = "right",
                    padding_right = 20,
                    padding_left = 20,
                },
                icon = {
                    string = tostring(package),
                    drawing = false,
                },
                click_script = "sketchybar --set brew popup.drawing=off",
                position = "popup." .. brew.name,
            })
        end

        -- Hide widget if no packages
        if count == 0 then
            brew:set({
                drawing = "off",
                label = "?",
            })
            return
        else
            brew:set({
                drawing = "on",
                label = "?", -- Default to ? when not hovered
            })
        end

        -- Change icon color depending on packages
        for _, threshold in ipairs(thresholds) do
            if count >= threshold.count then
                brew:set({
                    icon = {
                        color = threshold.color,
                    },
                })
                break
            end
        end
    end)
    sbar.trigger("brew_cleanup")
end)

sbar.add("bracket", "widgets.brew.bracket", { brew.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.brew.padding", {
  position = "right",
  width = settings.group_paddings
})

return brew
