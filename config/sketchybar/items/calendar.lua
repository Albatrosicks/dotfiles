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
  click_script = "$CONFIG_DIR/helpers/extras/bin/extras -c Clock"
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
      -- Hardcoded Russian calendar data
      local weekdays = {
          [1] = "Пн",
          [2] = "Вт",
          [3] = "Ср",
          [4] = "Чт",
          [5] = "Пт",
          [6] = "Сб",
          [7] = "Вс"
      }

      local months = {
          [1] = "янв",
          [2] = "фев",
          [3] = "мар",
          [4] = "апр",
          [5] = "мая",
          [6] = "июн",
          [7] = "июл",
          [8] = "авг",
          [9] = "сен",
          [10] = "окт",
          [11] = "ноя",
          [12] = "дек"
      }

      -- Get current date/time
      local date = os.date("*t")

      -- Format date string (weekday. DD month.)
      local weekday = weekdays[date.wday == 1 and 7 or date.wday - 1] or "??"
      local month = months[date.month] or "???"
      local date_str = string.format("%s. %02d %s.", 
          weekday,
          date.day,
          month
      )

      -- Format time string (HH:MM)
      local time_str = string.format("%02d:%02d", date.hour, date.min)

      -- Set the calendar widget
      cal:set({ 
          icon = date_str,
          label = time_str
      })
  end

  -- Initial set
  set_calendar_time()

end)
