local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local arc_first_space = nil -- Tracks the first space where Arc is found
local arc_in_spaces = {} -- Tracks which spaces have Arc

for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      font = { family = settings.font.numbers },
      string = i,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
    popup = { background = { border_width = 5, border_color = colors.black } }
  })

  spaces[i] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2
    }
  })

  -- Padding space
  sbar.add("space", "space.padding." .. i, {
    space = i,
    script = "",
    width = settings.group_paddings,
  })

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left= 5,
    padding_right= 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    local color = selected and colors.grey or colors.bg2
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
      background = { border_color = selected and colors.black or colors.bg2 }
    })
    space_bracket:set({
      background = { border_color = selected and colors.grey or colors.bg2 }
    })
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    else
      local op = (env.BUTTON == "right") and "--destroy" or "--focus"
      sbar.exec("yabai -m space " .. op .. " " .. env.SID)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

-- Modify the space_window_observer:subscribe function
space_window_observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  local no_app = true
  local current_space = env.INFO.space

  -- Check if Arc is in this space
  local has_arc = false
  for app, count in pairs(env.INFO.apps) do
    if app == "Arc" then
      has_arc = true
      break
    end
  end

  -- Update our tracking of Arc's presence in this space
  arc_in_spaces[current_space] = has_arc

  -- If Arc is no longer in the first space, find a new first space
  if arc_first_space ~= nil and not arc_in_spaces[arc_first_space] then
    arc_first_space = nil
    for space = 1, 10 do
      if arc_in_spaces[space] then
        arc_first_space = space
        break
      end
    end
  end

  -- If Arc is in this space and we haven't recorded a first space yet,
  -- mark this as the first space
  if has_arc and arc_first_space == nil then
    arc_first_space = current_space
  end

  -- Build the icon line
  for app, count in pairs(env.INFO.apps) do
    -- Skip Arc if this is not the first space where it was found
    if app == "Arc" and current_space ~= arc_first_space then
      -- Skip this icon
    else
      no_app = false
      local lookup = app_icons[app]
      -- Add fallback to "?" if both lookup and default icon are nil
      local icon = ((lookup == nil) and (app_icons["Default"] or "?") or lookup)
      icon_line = icon_line .. " " .. icon
    end
  end

  if (no_app) then
    icon_line = " —"
  end

  sbar.animate("tanh", 10, function()
    if spaces and env and env.INFO and env.INFO.space and spaces[env.INFO.space] then
      spaces[env.INFO.space]:set({ label = icon_line })
    else
      print("Error: One of the required values is nil")
      -- You can add more detailed error logging here to identify which value is nil
      if not spaces then print("spaces is nil") end
      if not env then print("env is nil") end
      if env and not env.INFO then print("env.INFO is nil") end
      if env and env.INFO and not env.INFO.space then print("env.INFO.space is nil") end
      if spaces and env and env.INFO and env.INFO.space and not spaces[env.INFO.space] then
        print("spaces[env.INFO.space] is nil")
      end
    end
  end)
end)


spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
