return {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfffc5d7c,
  green = 0xff9ed072,
  blue = 0xff76cce0,
  yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xff7f8490,
  transparent = 0x00000000,

  bar = {
    bg = 0xf02c2e34,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490
  },
  bg1 = 0xff363944,
  bg2 = 0xff414550,

  rose_pallete = {
  	nc = "0xff1f1d30",

  	-- Primary Background
  	-- General background, e.g. windows, tabs
  	-- Extended panels, e.g. sidebars
  	base = "0xff232136",

  	-- Secondary background atop base
  	-- Accessory panels, e.g. popups, floats, editor terminals
  	-- Inputs, e.g. text search, checkboxes
  	surface = "0xff2a273f",

  	-- Tertiary background atop surface
  	-- Active backgrounds, e.g. tabs, list items
  	-- High contrast inputs, e.g. text search, checkboxes
  	-- Hover selections
  	-- Terminal black
  	overlay = "0xff393552",

  	-- Low contrast foreground
  	-- Ignored content, e.g. ignored Git files
  	-- Terminal bright black
  	muted = "0xff6e6a86",

  	-- Medium contrast foreground
  	-- Inactive foregrounds, e.g. tabs, list items
  	subtle = "0xff908caa",

  	-- Text
  	-- High contrast foreground
  	-- Active foregrounds, e.g. tabs, list items
  	-- Cursor foreground paired with highlight high background
  	-- Selection foreground paired with highlight med background
  	-- Terminal white, bright white
  	text = "0xffe0def4",

  	-- Per favore ama tutti
  	-- Diagnostic errors
  	-- Deleted Git files
  	-- Terminal red, bright red
  	love = "0xffeb6f92",

  	-- Lemon tea on a summer morning
  	-- Diagnostic warnings
  	-- Terminal yellow, bright yellow
  	gold = "0xfff6c177",

  	-- A beautiful yet cautious blossom
  	-- Matching search background paired with base foreground
  	-- Modified Git files
  	-- Terminal cyan, bright cyan
  	rose = "0xffea9a97",

  	-- Fresh winter greenery
  	-- Renamed Git files
  	-- Terminal green, bright green
  	pine = "0xff3e8fb0",

  	-- Saltwater tidepools
  	-- Diagnostic information
  	-- Git additions
  	-- Terminal blue, bright blue
  	foam = "0xff9ccfd8",

  	-- Smells of groundedness
  	-- Diagnostic hints
  	-- Inline links
  	-- Merged and staged Git modifications
  	-- Terminal magenta, bright magenta
  	iris = "0xffc4a7e7",

  	-- Low contrast highlight
  	-- Cursorline background
  	highlight_low = "0xff2a283e",

  	-- Medium contrast highlight
  	-- Selection background paired with text foreground
  	highlight_med = "0xff44415a",

  	-- High contrast highlight
  	-- Borders / visual dividers
  	-- Cursor background paired with text foreground
  	highlight_high = "0xff56526e",

  	none = "NONE",
  },

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
