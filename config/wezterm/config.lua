local wezterm = require("wezterm")
local mux = wezterm.mux

local cache_dir = os.getenv("HOME") .. "/.cache/wezterm/"
local window_size_cache_path = cache_dir .. "window_size_cache.txt"

local multiplexing_unix_socket_name = "@multiplexingName@"

local color_scheme_name = "Afterglow (Gogh)"
local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]

wezterm.on("gui-startup", function()
	os.execute("mkdir " .. cache_dir)

	local window_size_cache_file = io.open(window_size_cache_path, "r")
	if window_size_cache_file ~= nil then
		local _, _, width, height = string.find(window_size_cache_file:read(), "(%d+),(%d+)")
		mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
		window_size_cache_file:close()
	else
		local _, _, window = mux.spawn_window({})
		window:gui_window():maximize()
	end
end)

wezterm.on("window-resized", function(_, pane)
	local window_size_cache_file = io.open(window_size_cache_path, "r")
	if window_size_cache_file == nil then
		local tab_size = pane:tab():get_size()
		local contents = string.format("%d,%d", tab_size["cols"], tab_size["rows"] + 2)
		window_size_cache_file = assert(io.open(window_size_cache_path, "w"))
		window_size_cache_file:write(contents)
		window_size_cache_file:close()
	end
end)

return {
	front_end = "WebGpu",
	hide_tab_bar_if_only_one_tab = true,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
	quit_when_all_windows_are_closed = false,
	use_fancy_tab_bar = true,
	font = wezterm.font_with_fallback({
		{
			family = "RecMonoLinear Nerd Font Mono",
			weight = "Regular",
			style = "Normal",
			harfbuzz_features = { "calt=1", "clig=0", "liga=0" },
		},
		"Menlo",
	}),
	font_size = 15,
	window_decorations = "RESIZE",
	color_scheme = color_scheme_name,
	initial_cols = 100,
	initial_rows = 40,

	window_frame = {
		active_titlebar_bg = color_scheme.background,
		inactive_titlebar_bg = color_scheme.background,
	},

	window_padding = {
		left = "1cell",
		right = "1cell",
		top = "0.5cell",
		bottom = "0.5cell",
	},

	skip_close_confirmation_for_processes_named = {
		"bash",
		"sh",
		"zsh",
		"fish",
		"tmux",
		"nu",
		"cmd.exe",
		"pwsh.exe",
		"powershell.exe",
	},

	unix_domains = {
		{
			name = multiplexing_unix_socket_name,
		},
	},
	default_gui_startup_args = { "connect", multiplexing_unix_socket_name },
	keys = {
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},

		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		-- CTRL-SHIFT-l activates the debug overlay
		{ key = "L", mods = "CMD", action = wezterm.action.ShowDebugOverlay },
	},
	colors = {
		tab_bar = {
			inactive_tab_edge = color_scheme.background,
			-- The active tab is the one that has focus in the window
			active_tab = {
				-- The color of the background area for the tab
				bg_color = color_scheme.background,
				-- The color of the text for the tab
				fg_color = color_scheme.brights[8],

				-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
				-- label shown for this tab.
				-- The default is "Normal"
				intensity = "Bold",
			},
			-- Inactive tabs are the tabs that do not have focus
			inactive_tab = {
				bg_color = color_scheme.background,
				fg_color = color_scheme.foreground,
			},
		},
	},
}
