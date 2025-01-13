local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    padding_left = 8,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    width = 49,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1
  },
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.grey,
  }
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
    local function set_calendar_time()
      -- Default values for error states
      local date_str = "???"
      local time_str = "--:--"

      -- Save current locale and attempt to set Russian
      local original_locale = os.setlocale(nil)
      local locale_set = os.setlocale("ru_RU.UTF-8")

      -- Fallback locales in case primary fails
      if not locale_set then
          locale_set = os.setlocale("ru_RU.utf8") or
                      os.setlocale("rus_RUS.UTF-8") or
                      os.setlocale("Russian_Russia.UTF-8")
      end

      -- Get current time/date
      local success, date_result = pcall(function()
          -- Try to get formatted date
          local date = os.date("*t")
          if date then
              -- Format time in 24-hour format
              time_str = string.format("%02d:%02d", date.hour or 0, date.min or 0)

              -- Format date with Russian abbreviations
              local weekdays = {
                  ["Sunday"] = "Вс",
                  ["Monday"] = "Пн",
                  ["Tuesday"] = "Вт",
                  ["Wednesday"] = "Ср",
                  ["Thursday"] = "Чт",
                  ["Friday"] = "Пт",
                  ["Saturday"] = "Сб"
              }

              local months = {
                  ["January"] = "янв",
                  ["February"] = "фев",
                  ["March"] = "мар",
                  ["April"] = "апр",
                  ["May"] = "мая",
                  ["June"] = "июн",
                  ["July"] = "июл",
                  ["August"] = "авг",
                  ["September"] = "сен",
                  ["October"] = "окт",
                  ["November"] = "ноя",
                  ["December"] = "дек"
              }

              local weekday = weekdays[os.date("%A")] or "??"
              local month = months[os.date("%B")] or "???"

              date_str = string.format("%s. %02d %s.", 
                  weekday,
                  date.day or 0,
                  month
              )
          end
      end)

      -- Always restore original locale, even if errors occur
      if original_locale then
          os.setlocale(original_locale)
      end

      -- Set the calendar widget
      cal:set({ 
          icon = date_str,
          label = time_str
      })

      -- If there was an error, log it (if you have logging)
      if not success then
          -- You might want to add your logging mechanism here
          -- log.error("Calendar format error: " .. tostring(date_result))
      end
  end

  -- Initial set
  set_calendar_time()

end)
