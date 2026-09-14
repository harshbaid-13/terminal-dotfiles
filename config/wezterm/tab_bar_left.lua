local wezterm = require("wezterm")
local utils = require("utils")

local M = {}

local icons = {
	vim = "",
	nvim = "",
}

function M.get_icon(cmd, cwd)
	if cmd:sub(1, 1) == "~" then
		if utils.is_in(cwd, "config") then
			return ""
		elseif utils.is_in(cwd, "Documents") then
			return "󰃀"
		else
			return "󰉋"
		end
	elseif cmd:sub(1, 1) == "/" then
		return "󰋊"
	end

	return icons[cmd] or ""
end

function M.get_name(title, cmd)
	if cmd:sub(1, 1) == "~" then
		return title:match("[^/]+$")
	end

	return cmd
end

function M.tab_title(tab_info)
	local title = tab_info.active_pane.title or ""
	local cwd = tostring(tab_info.active_pane.current_working_dir or "")
	local cmd = title:match("%S+") or ""
	local icon = M.get_icon(cmd, cwd)
	-- get_name returns nil for titles ending in "/" (e.g. "~/"), so fall back to the raw title.
	local name = M.get_name(title, cmd) or title
	if #name > 10 then
		name = name:sub(1, 9) .. "…"
	end
	return icon .. " " .. name
end

wezterm.on("format-tab-title", function(tab)
	local title = M.tab_title(tab)
	local res
	if not tab.is_active then
		res = {
			{ Background = { Color = "#4c566a" } },
			{ Foreground = { Color = "#2e3440" } },
			{ Text = " " .. title .. " " },
		}
	else
		res = {
			{ Background = { Color = "#4c566a" } },
			{ Foreground = { Color = "#eceff4" } },
			{ Text = " " .. title .. " " },
		}
	end

	utils.appendTables(res, utils.tab_separator)
	return res
end)

-- =======================================

function M.setup(config)
	config.colors = {
		tab_bar = {
			background = "#2e3440",
		},
	}
end

return M
