-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                          GENTLEMAN DOTS - WEZTERM                            ║
-- ║                           Optimized for Neovim                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
--config.default_prog = { "powershell.exe" }
-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                   FONT                                       │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- SF Mono (la fuente de Terminal.app). Instalada via Homebrew: font-sf-mono
config.font = wezterm.font("SF Mono", { weight = "Regular" })
config.font_size = 12.0

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  WINDOW                                      │
-- └──────────────────────────────────────────────────────────────────────────────┘
-- Look "Clear Dark" de Terminal.app: fondo solido translucido + blur (sin imagen)
config.window_background_opacity = 0.90
config.macos_window_background_blur = 30
config.win32_system_backdrop = "Acrylic"

config.window_padding = {
	top = 0,
	right = 0,
	left = 0,
	bottom = 0,
}

config.enable_scroll_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  CURSOR                                      │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            NEOVIM OPTIMIZATIONS                              │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- Terminal & Colors
-- WSL doesn't have wezterm terminfo, so we use xterm-256color there
-- See: https://github.com/Gentleman-Programming/Gentleman.Dots/issues/117
if wezterm.target_triple:find("windows") then
	config.term = "xterm-256color"
end
config.enable_csi_u_key_encoding = true

-- Undercurl support (LSP diagnostics, spelling)
config.underline_thickness = 2
config.underline_position = -2

-- Scrollback
config.scrollback_lines = 10000

-- Performance
config.max_fps = 165

-- Image support
config.enable_kitty_graphics = true

-- Input handling
config.use_dead_keys = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                           GENTLEMAN THEME                                    │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- config.colors = {
-- 	-- Base Colors
-- 	foreground = "#f3f6f9",
-- 	background = "#06080f",
-- 
-- 	-- Cursor
-- 	cursor_bg = "#e0c15a",
-- 	cursor_fg = "#06080f",
-- 	cursor_border = "#e0c15a",
-- 
-- 	-- Selection
-- 	selection_fg = "#f3f6f9",
-- 	selection_bg = "#263356",
-- 
-- 	-- Normal Colors
-- 	ansi = {
-- 		"#06080f", -- black
-- 		"#cb7c94", -- red
-- 		"#b7cc85", -- green
-- 		"#ffe066", -- yellow
-- 		"#7fb4ca", -- blue
-- 		"#ff8dd7", -- magenta
-- 		"#7aa89f", -- cyan
-- 		"#f3f6f9", -- white
-- 	},
-- 
-- 	-- Bright Colors
-- 	brights = {
-- 		"#8a8fa3", -- black
-- 		"#de8fa8", -- red
-- 		"#d1e8a9", -- green
-- 		"#fff7b1", -- yellow
-- 		"#a3d4d5", -- blue
-- 		"#ffaeea", -- magenta
-- 		"#7fb4ca", -- cyan
-- 		"#f3f6f9", -- white
-- 	},
-- }
-- Paleta "Clear Dark": fondo/texto del perfil + colores ANSI por defecto de Terminal.app
config.colors = {
	background = "#222733",
	foreground = "#E0E0E0",

	cursor_bg = "#E0E0E0",
	cursor_fg = "#191D27",
	cursor_border = "#E0E0E0",

	selection_bg = "#3A4150",
	selection_fg = "#E0E0E0",

	ansi = {
		"#000000", -- black
		"#990000", -- red
		"#00a600", -- green
		"#999900", -- yellow
		"#6e98b7", -- blue (valor que Terminal.app *muestra* tras su realce de legibilidad)
		"#b200b2", -- magenta
		"#00a6b2", -- cyan
		"#bfbfbf", -- white
	},
	brights = {
		"#666666", -- bright black
		"#e50000", -- bright red
		"#00d900", -- bright green
		"#e5e500", -- bright yellow
		"#0000ff", -- bright blue
		"#e500e5", -- bright magenta
		"#00e5e5", -- bright cyan
		"#e5e5e5", -- bright white
	},
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            WINDOWS (WSL)                                     │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- For Windows/WSL:
if wezterm.target_triple:find("windows") then
	config.default_domain = "WSL:Ubuntu"
	config.front_end = "OpenGL"
end
-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            KEY MAP                                           │
-- └──────────────────────────────────────────────────────────────────────────────┘
config.keys = {
	-- Tabs
	{ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "n", mods = "ALT", action = act.SpawnWindow },

	-- Moverse entre tabs
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "ALT|SHIFT", action = act.ActivateTabRelative(1) },

	-- Ir directo a tabs 1-9
	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = act.ActivateTab(8) },

	-- Splits
	{ key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "=", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Moverse entre panes estilo Vim
	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

	-- Cerrar pane actual
	{ key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
}

return config
