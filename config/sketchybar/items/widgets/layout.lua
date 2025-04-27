local settings = require("settings")
local colors   = require("colors")

-- Register macOS input-source change event
sbar.add("event", "keyboard_change", "AppleSelectedInputSourcesChangedNotification")

-- Create layout indicator
local layout = sbar.add("item", "widgets.layout", {
  position = "right",
  icon     = { drawing = false },
  label    = {
    font   = { family = settings.font.text,
               style  = settings.font.style_map["Semibold"],
               size   = 14.0 },
    color  = colors.white,
    string = "US",  -- default
  },
})

-- Command pipeline to extract the layout name
local cmd = 'defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev'

-- Update callback: map name to US/RU
local function update_layout()
  sbar.exec(cmd, function(out)
    local name = out and out:match("^%s*(.-)%s*$") or ""
    local code = "US"
    if name:find("Russian") then
      code = "RU"
    end
    layout:set({ label = { string = code } })
  end)
end

-- Subscribe to change and wake events
layout:subscribe({ "keyboard_change", "system_woke" }, update_layout)

-- Initial update
update_layout()

-- Bracket + padding for styling
sbar.add("bracket", "widgets.layout.bracket", { layout.name }, {
  background = { color = colors.bg1 },
})
sbar.add("item", "widgets.layout.padding", {
  position = "right",
  width    = settings.group_paddings,
})

return layout